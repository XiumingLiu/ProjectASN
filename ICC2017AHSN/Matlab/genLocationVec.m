function [ locationVec ] = genLocationVec( SIZE_GRF )
%GENLOCATIONVEC Generate a vector of corrdinates for all locations in GRF
%   locationMat = [ (1, 1), (1, 2), ..., (1, SIZE_GRF);
%                   (2, 1), (2, 2), ..., (2, SIZE_GRF);
%                   ...
%                   (SIZE_GRF, 1), (SIZE_GRF, 2), ..., (SIZE_GRF, SIZE_GRF)]
%   locationVec = [ (1, 1,), ..., (1, SIZE_GRF), (2, 1), (2, 2), ..., (2,
%                   SIZE_GRF), ..., (SIZE_GRF, SIZE_GRF)]

locationMat = zeros(SIZE_GRF, SIZE_GRF, 2);
for row = 1:SIZE_GRF
    for col = 1:SIZE_GRF
        locationMat(row, col, :) = [col row];
    end
end
locationVec = reshape(locationMat, SIZE_GRF^2, 2);

end

