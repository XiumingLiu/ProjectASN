function [ indexVec ] = location2Index( locationVec, SIZE_GRF )
%LOCATION2INDEX Convert a vector of locations to a vector of corresponding
%indexes in GRF. 
%   locations = [location1, location2, ..., locationN]
%   locationn = [locationn1; locationn2]
%   indexes = [index1, index2, ..., indexN]
%   indexn = (locationn1-1)*SIZE_GRF + locationn2

lenLocationVec = size(locationVec, 2);
indexVec = zeros(1, lenLocationVec);

for l = 1:lenLocationVec
    indexVec(l) = (locationVec(1, l)-1)*SIZE_GRF + locationVec(2, l);
end

end

