classdef Network < handle
    properties
        width
        depth
        voltage
        fires
        delays
        timer
        weights
        biases
        threshold
        refractory
    end
    
    methods
        %Constructor
        function obj = Network(w,d,M,B,D)
            obj.width=w;
            obj.depth=d;
            obj.voltage=zeros(w,d);
            obj.fires=zeros(w,d);
            obj.timer=zeros(w,d);
            obj.threshold=1;
            obj.refractory=1;
            
            # assign weights
            if nargin<3
                obj.weights=zeros(d,d,w,w);
            else
                obj.weights=M;
            end
            
            # assign biases
            if nargin < 4
                obj.biases=zeros(w,d);
            else
                obj.biases=B;
            end
            
            # assign delays
            if nargin<5
                obj.delays=ones(w,d);
            else
                obj.delays=D;
            end
        
        end
       
        function iterate(obj,feed)
            %Figure out what's firing and iterate active timers
            for w=1:obj.width
                for d=1:obj.depth
                    %Neuron Fires 
                    if obj.timer(w,d)>=obj.delays(w,d)
                        obj.timer(w,d)=-obj.refractory;
                        obj.fires(w,d)=1;
                        obj.voltage(w,d)=0;
                    %Neuron in delay or refractory
                    elseif obj.timer(w,d)~=0
                        obj.timer(w,d)=obj.timer(w,d)+1;
                    end
                end
            end

           %Update voltages based on whats firing and the weightings
           tempV=zeros(obj.width,obj.depth);
           tempV(1,:)=feed;
           for d=1:obj.depth
               for i=1:obj.depth
                   %%TODO: Check order of weight vector multiplication
                   tempV(:,d)=tempV(:,d)+squeeze(obj.weights(d,i,:,:))*squeeze(obj.fires(:,i));
               end
           end
           obj.voltage(:,:)=tempV(:,:);

            %Check for things that should fire
            for w=1:obj.width
                for d=1:obj.depth
                    if obj.voltage(w,d)>obj.threshold && obj.timer(w,d)==0
                        obj.timer(w,d)=1;
                    end
                end
            end
        end
        
        % a function that loads neural net weights 
        % and biases from python
        function load_data(obj, filename)
            % load data into structure
            data = load(filename)
            
            % loop over layers
            for field=fieldnames(data)'
                % extract layer number (last element)
                d = str2num(field{1}(end));
                % determine if unpacking weights or biases
                if strfind(field{1}, 'weight')
                    % extract value
                    weights = data.(field{1});
                    % assign weights from layer d to d+1
                    [m,n] = size(weights); 
                    Weights(d, d+1, 1:m, 1:n) = weights; 
                else
                    % extract biases
                    biases = data.(field{1});
                    # assign biases for layer d
                    w = length(biases)
                    Biases(1:w, d) = biases;
                end
            end
            
        end
        
        % a function that makes neurons leaky over
        % time
        function add_leak(obj, leak_param)
            % create leaky identity matrix
            leak = leak_param*eye(obj.width)
            % loop over each layer of network
            for d = 1:obj.depth
                % store in weights
                weights(d, d, :, :) = leak;
            end
        end
        
        function 
    end
    
    % nonlinearity static methods
    methods(static)
        % ReLU nonlinearity
        function y = relu(x)
            % return the rectified linear unit
            y = max(0,x)
        end
        
        % Softmax nonlinearity
        function y = softmax(x)
            % calculate normalized softmax output 
            y = exp(x)/sum(exp(x))
        end
    end
end