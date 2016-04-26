function [AccT, DecT, ContT, SType] = SprofilePlanType2(Vstr, Vend, Vmax, Len)
% ���ٹ滮

global maxAcc;
global maxJerk;
global interpolationFrequence;

T1 = maxAcc / maxJerk;
T2 = 0;

% ţ�ٷ����
while abs(T1 - T2) > 10^(-6)
    T2 = T1;
    T1 = T2 - (maxJerk * T2^3 + 2 * Vstr * T2 - Len) / (3 * maxJerk * T2^2 + 2 * Vstr);
end

AccT = T1 * interpolationFrequence;
DecT = 0;
ContT = 0;
SType = 2;

