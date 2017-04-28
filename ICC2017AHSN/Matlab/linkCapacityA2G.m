function [ CMbs ] = linkCapacityA2G( distTran, a2gParVec )
%LINKCAPACITY Calculate the capacity for A2G links
%   C = B*log_2(1 + SINR) (in bit/s)
%   SINR = P_rx / (P_i + P_N) (in linear ration)
%   P_rx = P_tx + G_rx - PL(dsitLink) - Lm (in dB)

B = a2gParVec(1); Ptx = a2gParVec(2); Grx = a2gParVec(3);
Pi = a2gParVec(4); Pn = a2gParVec(5); Lf = a2gParVec(6);

Pl = pathLossA2G(distTran);

Prx = Ptx + Grx - Pl - Lf; % in dBm
SINRdb = Prx - (Pi + Pn); % in dB
SINR = db2mag(SINRdb);

C = B*log2(1 + SINR);
CMbs = C/10^6;

end

