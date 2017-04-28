function [ linkCap, linkMat ] = linkConnectMultiHop( SIZE_ASN, NUM_BS,...
    RES_SPATIAL, a2gParVec, a2aParVec, positionVec, locationBS )
%LINKCONNECT_RELAY Summary of this function goes here
%   Detailed explanation goes here

closetRBid = zeros(SIZE_ASN, 1)'; 
linkA2GCap = zeros(SIZE_ASN, 1)';
capMeasure = zeros(SIZE_ASN, SIZE_ASN + NUM_BS);
linkMat = zeros(SIZE_ASN, SIZE_ASN + NUM_BS);
linkCap = zeros(SIZE_ASN, 1)';

%% Measure the capacity to BS
for n = 1:SIZE_ASN
    for r = 1:NUM_BS
        distTran = pdist([positionVec(:, n)'; locationBS(:, r)'])*RES_SPATIAL;
        capMeasure(n, SIZE_ASN + r) = linkCapacityA2G(distTran, a2gParVec);
    end 
    [linkA2GCap(n), closetRBid(n)] = max(capMeasure(n, (SIZE_ASN+1):end));
    linkMat(n, SIZE_ASN + closetRBid(n)) = 1;
end

%% Measure the capacity to peer
for n = 1:SIZE_ASN
    for r = 1:SIZE_ASN
        if r == n
            capMeasure(n, r) = -1;
        else
            distTran = pdist([positionVec(:, n)'; positionVec(:, r)'])*RES_SPATIAL;
            capMeasure(n, r) = min(linkCapacityA2A(distTran, a2aParVec), linkA2GCap(r));
        end
    end
end

%% Sort the linkA2G 
[linkA2GCapSorted, sensorId] = sort(linkA2GCap, 'ascend');

%% From sensorId(1) to SensorId(numSesnor), check if can be relayed
for n = 1:SIZE_ASN
    this_sensorId = sensorId(n);
    if sum(linkMat(this_sensorId, :)) > 1
        linkCap(this_sensorId) = linkA2GCapSorted(n);
    else
        [this_linkA2ACapMax, peerId] = max(capMeasure(this_sensorId, 1:SIZE_ASN));
        if linkA2GCap(this_sensorId) < min(this_linkA2ACapMax, linkA2GCap(peerId))
            linkMat(this_sensorId, :) = 0;
            linkMat(this_sensorId, peerId) = 1;
            linkMat(peerId, this_sensorId) = 1;
            linkCap(this_sensorId) = min(this_linkA2ACapMax, linkA2GCap(peerId));
        else
            linkCap(this_sensorId) = linkA2GCapSorted(n);
        end
    end   
end

end

