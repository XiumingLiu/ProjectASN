function [ positionNew ] = utilityMaxEntropy( SIZE_GRF, flagMotion,...
    position, COV, positionNew )
%UTILITYMAXMI Summary of this function goes here
%   Detailed explanation goes here

positionsAdj = zeros(2, 4); % Adjcent positions
positionsAdj(:, 1) = [position(1); position(2) - 1]; % left
positionsAdj(:, 2) = [position(1); position(2) + 1]; % right   
positionsAdj(:, 3) = [position(1) - 1; position(2)]; % up   
positionsAdj(:, 4) = [position(1) + 1; position(2)]; % down   

COV = reshape(diag(COV), SIZE_GRF, SIZE_GRF)';

for i = 1:4
    if flagMotion(i) ~= 0
        flagMotion(i) = COV(positionsAdj(1, i), positionsAdj(2, i));
    end
end
if flagMotion(5) ~= 0
    flagMotion(5) = COV(position(1), position(2));
end

[~, maxFlagIndex] = max(flagMotion);

% Return new position
switch maxFlagIndex
    case 1
        positionNew(:) = positionsAdj(:, 1);
    case 2
        positionNew(:) = positionsAdj(:, 2);
    case 3
        positionNew(:) = positionsAdj(:, 3);
    case 4
        positionNew(:) = positionsAdj(:, 4);
    otherwise
        positionNew(:) = position(:);
end

end

