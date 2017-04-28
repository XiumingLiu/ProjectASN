function [ H ] = genSensingMat( positionVec, SIZE_GRF, SIZE_ASN )
%SENSINGMAT 
%   Inputs: Current sensors' position vector, size of random field, number
%   of sensors
%   Output: Current sensing matirx H
H = zeros(SIZE_ASN, SIZE_GRF^2);

for row = 1:SIZE_ASN
    for col = 1:SIZE_GRF^2
        if (positionVec(1, row) == floor(col/SIZE_GRF)+1 && ...
                positionVec(2, row) == col-floor((col-1)/SIZE_GRF)*SIZE_GRF)
            H(row, col) = 1;
        else
            H(row, col) = 0;
        end
    end
end

end

