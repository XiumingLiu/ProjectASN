function [ positionNew, positionIndex ] = utilityMaxMI( n, flagMotion,...
    position, positionNew, positionIndex, COV, SIZE_GRF )
%UTILITYMAXMI Summary of this function goes here
%   Detailed explanation goes here

positionsAdj = zeros(2, 4); % Adjcent positions
positionsAdj(:, 1) = [position(1, n); position(2, n) - 1];
positionsAdj(:, 2) = [position(1, n); position(2, n) + 1];
positionsAdj(:, 3) = [position(1, n) - 1; position(2, n)];
positionsAdj(:, 4) = [position(1, n) + 1; position(2, n)];

% COV = reshape(sum(COV), SIZE_GRF, SIZE_GRF)';

for i = 1:5    
    if flagMotion(i, n) ~= 0
        if i == 5
            positionIndex(n) = (position(1, n) - 1)*SIZE_GRF + position(2, n);
        else
            positionIndex(n) = (positionsAdj(1, i) - 1)*SIZE_GRF + positionsAdj(2, i);
        end
               
        VAR = COV(positionIndex(n), positionIndex(n));
        if n == 1
            SIGMA_nX = COV(positionIndex(n), :);
            SIGMA_nX(positionIndex(n)) = [];
            SIGMA_XX = COV;
            SIGMA_XX(positionIndex(n), :) = [];
            SIGMA_XX(:, positionIndex(n)) = [];
            SIGMA_Xn = SIGMA_nX';
            flagMotion(i, n) = VAR/(VAR - SIGMA_nX*(SIGMA_XX^-1)*SIGMA_Xn);
        else
            SIGMA_nN = zeros(1, n-1);
            SIGMA_NN = zeros(n-1, n-1);
            for col = 1:n-1
                SIGMA_nN(col) = COV(positionIndex(n), positionIndex(col));
                for row = 1:n-1
                    SIGMA_NN(row, col) = COV(positionIndex(row), positionIndex(col));
                end
            end
            SIGMA_Nn = SIGMA_nN';
            
            positionIndexAll = setdiff([1:SIZE_GRF^2], positionIndex(1:n-1));
            SIGMA_nX = zeros(1, SIZE_GRF^2-n);
            SIGMA_XX = zeros(SIZE_GRF^2-n, SIZE_GRF^2-n);
            for col = 1:SIZE_GRF^2-n
                SIGMA_nX(col) = COV(positionIndex(n), positionIndexAll(col));
                for row = 1:SIZE_GRF^2-n
                    SIGMA_XX(row, col) = COV(positionIndexAll(row), positionIndexAll(col));
                end
            end
            SIGMA_Xn = SIGMA_nX';
            
            flagMotion(i, n) = (VAR - SIGMA_nN*(SIGMA_NN^-1)*SIGMA_Nn)/(VAR - SIGMA_nX*(SIGMA_XX^-1)*SIGMA_Xn);
        end
    end
end

[~, maxFlagIndex] = max(flagMotion(:, n));

% Return new position
switch maxFlagIndex
    case 1
        positionNew(:, n) = positionsAdj(:, 1);
    case 2
        positionNew(:, n) = positionsAdj(:, 2);
    case 3
        positionNew(:, n) = positionsAdj(:, 3);
    case 4
        positionNew(:, n) = positionsAdj(:, 4);
    otherwise
        positionNew(:, n) = position(:, n);
end

positionIndex(n) = (positionNew(1, n) - 1)*SIZE_GRF + positionNew(2, n);

end

