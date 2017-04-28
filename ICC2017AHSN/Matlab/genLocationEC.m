function [ locationEC ] = genLocationEC( NUM_EC, SIZE_GRF )
%GENLOCATIONBS Generate a vecotor of locations for base stations
%   Detailed explanation goes here

switch NUM_EC
    case 1
        locationEC = [SIZE_GRF/2, SIZE_GRF/2]';
    case 4
        locationEC = [SIZE_GRF/4, SIZE_GRF/4; SIZE_GRF/4, 3*SIZE_GRF/4;...
            3*SIZE_GRF/4, SIZE_GRF/4; 3*SIZE_GRF/4, 3*SIZE_GRF/4]';
    otherwise
        error('Support NUM_EC: 1 or 4.');
end

end

