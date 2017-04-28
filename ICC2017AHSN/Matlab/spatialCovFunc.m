function [ cov ] = spatialCovFunc( location1, location2, hyp )
%SPATIALCOVFUNC 
%   Inputs: location 1, location 2, hyper-parameters
%   Output: covariance

% Hyper-parameters, par = {alpha, theta}
alpha = hyp(1);
theta = hyp(2);

cov = alpha^2*exp(-norm(location1 - location2)^2/theta^2);

end

