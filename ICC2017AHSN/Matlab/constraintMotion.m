function [ flagMotion ] = constraintMotion(n, flagMotion, position, SIZE_GRF )
%CONSTRAINTMOTION Constraint: ASN must be in the service area
%   Detailed explanation goes here

% positionsAdj = zeros(2, 4); % Adjcent positions
% positionsAdj(:, 1) = [position(1); position(2) - 1];
% positionsAdj(:, 2) = [position(1); position(2) + 1];
% positionsAdj(:, 3) = [position(1) - 1; position(2)];
% positionsAdj(:, 4) = [position(1) + 1; position(2)];

if (position(2, n) - 1 < 1)
    flagMotion(1, n) = -Inf;
end

if (position(2, n) + 1 > SIZE_GRF)
    flagMotion(2, n) = -Inf;
end

if (position(1, n) - 1 < 1)
    flagMotion(3, n) = -Inf;
end

if (position(1, n) + 1 > SIZE_GRF)
    flagMotion(4, n) = -Inf;
end

end

