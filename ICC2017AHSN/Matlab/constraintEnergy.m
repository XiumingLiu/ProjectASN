function [ flagMotion ] = constraintEnergy( n, flagMotion, positionVec,...
    batteryLife, NUM_EC, locationEC )
%CONSTRAINTENERGY Summary of this function goes here
%   Detailed explanation goes here

if NUM_EC == 4
    distToSensorEC = zeros(1, 4);
elseif NUM_EC == 1
    distToSensorEC = zeros(1, 1);
else
    error('Invalid number of ECs!');
end
    
batteryLifeMin = zeros(1, 5);

positionsAdj = zeros(2, 4); % Adjcent positions
positionsAdj(:, 1) = [positionVec(1, n); positionVec(2, n) - 1];
positionsAdj(:, 2) = [positionVec(1, n); positionVec(2, n) + 1];
positionsAdj(:, 3) = [positionVec(1, n) - 1; positionVec(2, n)];
positionsAdj(:, 4) = [positionVec(1, n) + 1; positionVec(2, n)];

% Calculate the minimum lifetime requirement for all potential positions
for i = 1:4
    % Calculate the manhanttan distance between the potential positions
    % and ECs
    for ECid = 1:NUM_EC
        distToSensorEC(ECid) =...
            pdist([positionsAdj(:, i)'; locationEC(:, ECid)'], 'cityblock');
    end
    distSensorECmin = min(distToSensorEC);
    batteryLifeMin(i) = distSensorECmin;
end

% Calculate the manhattan distance between the current positions
% and ECs
for ECid = 1:NUM_EC
    distToSensorEC(ECid) = pdist([positionVec(:, n)'; locationEC(:, ECid)'], 'cityblock');
end
distSensorECmin = min(distToSensorEC);
batteryLifeMin(5) = distSensorECmin;

% Generate constraints
if ((batteryLife - 1) < batteryLifeMin(1))
    flagMotion(1) = 0;
end

if ((batteryLife - 1) < batteryLifeMin(2))
    flagMotion(2) = 0;
end

if ((batteryLife - 1) < batteryLifeMin(3))
    flagMotion(3) = 0;
end

if ((batteryLife - 1) < batteryLifeMin(4))
    flagMotion(4) = 0;
end

if ((batteryLife - 1) < batteryLifeMin(5))
    flagMotion(5) = 0;
end

end

