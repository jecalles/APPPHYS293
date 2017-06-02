Weights = zeros(3,3, 784, 784);
Biases = zeros(784, 3);

leak_param = 0.9;

% load data into structure
data = load('weights.mat');

% create leaky identity matrix
leak = leak_param*eye(784)
% loop over each layer of network
for d = 1:4
    % store in weights
    weights(d, d, :, :) = leak;
end