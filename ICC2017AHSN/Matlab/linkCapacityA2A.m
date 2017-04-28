function [ CMbs ] = linkCapacityA2A( distTran, a2aParVec )
%LINKCAPACITY Calculate the capacity for A2G links
%   C = B*log_2(1 + SINR) (in bit/s)
%   SINR = P_rx / (P_i + P_N) (in linear ration)
%   P_rx = P_tx + G_rx - PL(dsitLink) - Lm (in dB)

B = a2aParVec(1); Ptx = a2aParVec(2); Grx = a2aParVec(3);
Pi = a2aParVec(4); Pn = a2aParVec(5); Lf = a2aParVec(6);

Pl = pathLossA2A(distTran);

Prx = Ptx + Grx - Pl - Lf; % in dBm
SINRdb = Prx - (Pi + Pn); % in dB
SINR = db2mag(SINRdb);

C = B*log2(1 + SINR);
CMbs = C/10^6;

end

