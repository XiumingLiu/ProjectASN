function [ linkCap, linkMat ] = linkConnectOneHop( SIZE_ASN, NUM_BS, ...
    RES_SPATIAL, a2gParVec, positionVec, locationBS )
%LINKCONNECT One-Hop ASN Connection
%   Detailed explanation goes here

closetRBid = zeros(SIZE_ASN, 1)'; 
linkCap = zeros(SIZE_ASN, 1)';
capMeasure = zeros(SIZE_ASN, NUM_BS);
linkMat = zeros(SIZE_ASN, SIZE_ASN + NUM_BS);

%% Find the closet RB for each sensor and connect it
for n = 1:SIZE_ASN
    for r = 1:NUM_BS
        distTran = pdist([positionVec(:, n)'; locationBS(:, r)'])*RES_SPATIAL;
        capMeasure(n, r) = linkCapacityA2G(distTran, a2gParVec);
    end 
    [linkCap(n), closetRBid(n)] = max(capMeasure(n, :));
    linkMat(n, SIZE_ASN + closetRBid(n)) = 1;
end

end

