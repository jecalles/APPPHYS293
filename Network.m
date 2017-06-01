classdef Network < handle
   properties
       width
       depth
       voltage
       fires
       delays
       timer
       weights
       threshold
       refractory
   end
   methods
       %Constructor
       function obj = Network(w,d,M,D)

           obj.width=w;
           obj.depth=d;
           obj.voltage=zeros(w,d);
           obj.fires=zeros(w,d);
           obj.timer=zeros(w,d);
           obj.threshold=1;
           obj.refractory=1;

           if nargin<3
            obj.weights=zeros(d,d,w,w);
           else
               obj.weights=M;
           end

           if nargin<4
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
   end
end