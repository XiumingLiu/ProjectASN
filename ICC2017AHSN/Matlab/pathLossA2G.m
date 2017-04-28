function [ a2gPl ] = pathLossA2G( distTran )
%PATHLOSSA2G Calculate the path loss for A2G links
%   Detailed explanation goes here

a2gPl = 122.4 + 40*log(distTran + 0.15); % in dB

end

