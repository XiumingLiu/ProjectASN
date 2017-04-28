function [ locationBS ] = genLocationBS( NUM_BS, SIZE_GRF )
%GENLOCATIONBS Generate a vecotor of locations for base stations
%   Detailed explanation goes here

switch NUM_BS
    case 1
        locationBS = [SIZE_GRF/2, SIZE_GRF/2]';
    case 4
        locationBS = [SIZE_GRF/4, SIZE_GRF/4; SIZE_GRF/4, 3*SIZE_GRF/4;...
            3*SIZE_GRF/4, SIZE_GRF/4; 3*SIZE_GRF/4, 3*SIZE_GRF/4]';
    otherwise
        error('Support NUM_BS: 1 or 4.');
end

end

