function [ positionVec ] = initPositionVec( SIZE_ASN, NUM_BS, RES_SPATIAL, ...
    locationBS, a2gParVec)
%INITPOSITIONVEC Intitialize the positions of ASN in the cell coverage
%   Detailed explanation goes here

positionVec = zeros(2, SIZE_ASN);
range = 6;

switch NUM_BS
    case 1
        for n = 1:SIZE_ASN
            if n > 1
                positionVec(1, n) = floor((locationBS(1) - range) + 2*range*rand);
                positionVec(2, n) = floor((locationBS(2) - range) + 2*range*rand);
                while ((linkCapacityA2G(pdist([positionVec(:, n)'; locationBS'])*RES_SPATIAL, a2gParVec) < 1) || ...
                        (ismember(positionVec(:, n)', positionVec(:, 1:n-1)', 'rows')))
                    positionVec(1, n) = floor((locationBS(1) - range) + 2*range*rand);
                    positionVec(2, n) = floor((locationBS(2) - range) + 2*range*rand);
                    % disp('Initializing ... ');
                end
                % disp(['Sensor ', num2str(n), ' is successfully initialized!']);
            else 
                positionVec(1, n) = floor((locationBS(1) - range) + 2*range*rand);
                positionVec(2, n) = floor((locationBS(2) - range) + 2*range*rand);
                while ((linkCapacityA2G(pdist([positionVec(:, n)'; locationBS'])*RES_SPATIAL, a2gParVec) < 1))
                    positionVec(1, n) = floor((locationBS(1) - range) + 2*range*rand);
                    positionVec(2, n) = floor((locationBS(2) - range) + 2*range*rand);
                    % disp('Initializing ... ');
                end
                % disp(['Sensor ', num2str(n), ' is successfully initialized!']);
            end
        end
    case 4
        for n = 1:SIZE_ASN
            if n > 1
                thisBS = randi(4, 1);
                positionVec(1, n) = floor((locationBS(1, thisBS) - 3) + 6*rand);
                positionVec(2, n) = floor((locationBS(2, thisBS) - 3) + 6*rand);
                while ((linkCapacityA2G(pdist([positionVec(:, n)'; locationBS(:, thisBS)'])*RES_SPATIAL, a2gParVec) < 1) || ...
                        (ismember(positionVec(:, n)', positionVec(:, 1:n-1)', 'rows')))
                    thisBS = randi(4, 1);
                    positionVec(1, n) = floor((locationBS(1, thisBS) - 3) + 6*rand);
                    positionVec(2, n) = floor((locationBS(2, thisBS) - 3) + 6*rand);
                    % disp('Initializing ... ');
                end
                % disp(['Sensor ', num2str(n), ' is successfully initialized!']);
            else 
                thisBS = randi(4, 1);
                positionVec(1, n) = floor((locationBS(1, thisBS) - 3) + 6*rand);
                positionVec(2, n) = floor((locationBS(2, thisBS) - 3) + 6*rand);
                while ((linkCapacityA2G(pdist([positionVec(:, n)'; locationBS(:, thisBS)'])*RES_SPATIAL, a2gParVec) < 1))
                    thisBS = randi(4, 1);
                    positionVec(1, n) = floor((locationBS(thisBS, 1) - 3) + 6*rand);
                    positionVec(2, n) = floor((locationBS(thisBS, 2) - 3) + 6*rand);
                    % disp('Initializing ... ');
                end
                % disp(['Sensor ', num2str(n), ' is successfully initialized!']);
            end
        end
    otherwise
        error('Invalid NUM_BS!');
end

end

