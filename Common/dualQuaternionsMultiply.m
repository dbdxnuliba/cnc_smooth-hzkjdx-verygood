function Qo = dualQuaternionsMultiply(Q1, Q2)
% �����ż��Ԫ�����

Qo = zeros(1, 8);
Qo(1:4) = quatmultiply(Q1(1:4), Q2(1:4));
Qo(5:8) = quatmultiply(Q1(1:4), Q2(5:8)) + quatmultiply(Q1(5:8), Q2(1:4));