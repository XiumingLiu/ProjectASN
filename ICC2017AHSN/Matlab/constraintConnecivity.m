function [ flagMotion ] = constraintConnecivity( n, flagMotion, positionVec,...
    linkVec, NUM_BS, locationBS, SIZE_ASN, RES_SPATIAL, a2gParVec, a2aParVec )
%CONSTRAINTENERGY Summary of this function goes here
%   Detailed explanation goes here

positionsAdj = zeros(2, 4); % Adjcent positions
positionsAdj(:, 1) = [positionVec(1, n); positionVec(2, n) - 1];
positionsAdj(:, 2) = [positionVec(1, n); positionVec(2, n) + 1];
positionsAdj(:, 3) = [positionVec(1, n) - 1; positionVec(2, n)];
positionsAdj(:, 4) = [positionVec(1, n) + 1; positionVec(2, n)];

if sum(linkVec(SIZE_ASN+1:end)) > 0 && sum(linkVec(1:SIZE_ASN)) == 0
    % this node is directly connected to an BS
    connectToBSid = [1:NUM_BS]*linkVec(SIZE_ASN+1:end)';
    if (linkCapacityA2G(pdist([positionsAdj(:, 1)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(1) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 2)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(2) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 3)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(3) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 4)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(4) = 0;
    end
elseif sum(linkVec(SIZE_ASN+1:end)) > 0 && sum(linkVec(1:SIZE_ASN)) > 0
    % this node is a relay node
    % must maintain connecitivity with BS
    connectToBSid = [1:NUM_BS]*linkVec(SIZE_ASN+1:end)';
    if (linkCapacityA2G(pdist([positionsAdj(:, 1)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(1) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 2)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(2) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 3)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(3) = 0;
    end
    if (linkCapacityA2G(pdist([positionsAdj(:, 4)'; locationBS(:, connectToBSid)'])*RES_SPATIAL, a2gParVec) < 1 )
        flagMotion(4) = 0;
    end
    % must maintain connecitvity with peer nodes
    peers = find(linkVec(1:SIZE_ASN));
    numPeers = length(peers);
    capPeers = zeros(4, numPeers);
    for row = 1:4
        for col = 1:numPeers
            capPeers(row, col) = linkCapacityA2A(pdist([positionsAdj(:, row)'; positionVec(:, peers(col))'])*RES_SPATIAL, a2aParVec);
        end
        if min(capPeers(row, :)) < 1
            flagMotion(row) = 0;
        end
    end   
else
    % this node is connected to a relay node
    ConnectToRelayid = [1:SIZE_ASN]*linkVec(1:SIZE_ASN)';
    if (linkCapacityA2A(pdist([positionsAdj(:, 1)'; positionVec(:, ConnectToRelayid)'])*RES_SPATIAL, a2aParVec) < 1 )
        flagMotion(1) = 0;
    end
    if (linkCapacityA2A(pdist([positionsAdj(:, 2)'; positionVec(:, ConnectToRelayid)'])*RES_SPATIAL, a2aParVec) < 1 )
        flagMotion(2) = 0;
    end
    if (linkCapacityA2A(pdist([positionsAdj(:, 3)'; positionVec(:, ConnectToRelayid)'])*RES_SPATIAL, a2aParVec) < 1 )
        flagMotion(3) = 0;
    end
    if (linkCapacityA2A(pdist([positionsAdj(:, 4)'; positionVec(:, ConnectToRelayid)'])*RES_SPATIAL, a2aParVec) < 1 )
        flagMotion(4) = 0;
    end
end

end

