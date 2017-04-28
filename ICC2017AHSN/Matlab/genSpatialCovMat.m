function [ COV ] = genSpatialCovMat( locationVec1, locationVec2, hyp )
%GENSPATIALCOV Generate a spatial covariance function based on the given
%spatial covariance function. 
%   Detailed explanation goes here

M = size(locationVec1, 1); 
N = size(locationVec2, 1);
COV = zeros(M, N);

for row = 1:M
    for col = 1:N
        COV(row, col) =...
            spatialCovFunc(locationVec1(row, :), locationVec2(col, :), hyp);
    end
end

end

