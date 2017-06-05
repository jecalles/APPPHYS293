classdef Simulate < handle
    % define properties
    properties
        % NOTE: add properties as they become
        % necessary
        network
    end
    
    % define methods
    methods
        % constructor
        function obj = Simulate(network)
            obj.network = network
        end
    end
    
    % define static methods
    methods(static)
        % define noising function   
        function  out = addnoise(in, frac)
            % adds uniformly distributed noise at 
            % amplitude = amp to an input  as a fraction
            % of the  maximum value of input
            amp = frac*max(in(:))
            out = in + amp*rand(size(in))
        end
    end
end