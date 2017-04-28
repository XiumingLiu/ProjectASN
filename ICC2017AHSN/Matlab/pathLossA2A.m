function [ a2aPl ] = pathLossA2A( distTran )
%PATHLOSSA2A Calculate the path loss for A2A links
%   Detailed explanation goes here

a2aPl = 108.5 + 40*log(distTran + 0.15);  % in dB

end

