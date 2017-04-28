function [ positionVecNew, indexes, flagMotion ] = utilityMaxInfoGain(n, SIZE_GRF, indexes, flagMotion, positionVecNew, COV)
%UTILITYMAXINFOGAIN Summary of this function goes here
%   Detailed explanation goes here

positionsAdj = zeros(2, 4); % Adjcent positions
positionsAdj(:, 1) = [positionVecNew(1, n); positionVecNew(2, n) - 1];
positionsAdj(:, 2) = [positionVecNew(1, n); positionVecNew(2, n) + 1];
positionsAdj(:, 3) = [positionVecNew(1, n) - 1; positionVecNew(2, n)];
positionsAdj(:, 4) = [positionVecNew(1, n) + 1; positionVecNew(2, n)];

for i = 1:5
    if flagMotion(i, n) ~= 0
        if i ~= 5
            thisIndex = location2Index(positionsAdj(:, i), SIZE_GRF);
        else
            thisIndex = location2Index(positionVecNew(:, n), SIZE_GRF);
        end
        
        indexesAndThis = union(indexes, thisIndex);
        VAR_Y = COV(thisIndex, thisIndex);
        
        if n ~= 1
            COV_Ya = COV(thisIndex, indexes);
            COV_aa = COV(indexes, indexes);
            COV_aY = COV_Ya';
            
            A = setdiff(1:SIZE_GRF^2, indexesAndThis);
            COV_YA = COV(thisIndex, A);
            COV_AA = COV(A, A);
            COV_AY = COV_YA';
            
            flagMotion(i, n) = (VAR_Y - COV_Ya*COV_aa^-1*COV_aY)/(VAR_Y - COV_YA*(COV_AA + .1*eye(size(COV_AA,1)))^-1*COV_AY);
        else
            A = setdiff(1:SIZE_GRF^2, indexesAndThis);
            COV_YA = COV(thisIndex, A);
            COV_AA = COV(A, A);
            COV_AY = COV_YA';
            
            flagMotion(i, n) = (VAR_Y)/(VAR_Y - COV_YA*(COV_AA + .1*eye(size(COV_AA,1)))^-1*COV_AY);
        end
    end
end

[~, maxFlagIndex] = max(flagMotion(:, n));

% Return new position
switch maxFlagIndex
    case 1
        positionVecNew(:, n) = positionsAdj(:, 1);
    case 2
        positionVecNew(:, n) = positionsAdj(:, 2);
    case 3
        positionVecNew(:, n) = positionsAdj(:, 3);
    case 4
        positionVecNew(:, n) = positionsAdj(:, 4);
    otherwise
        positionVecNew(:, n) = positionVecNew(:, n);
end

indexes = union(indexes, location2Index(positionVecNew(:, n), SIZE_GRF));

end

