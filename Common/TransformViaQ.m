function pi = TransformViaQ(p, Qi)
% pi = TransformViaQ(p, Qi)����p�㾭����ż��Ԫ��Qi�任��õ��ĵ�pi
% pΪ�任֮ǰ�ĵ㣬��ʽΪ(x,y,z)��QiΪ�任�Ķ�ż��Ԫ��

% ������ֵת��Ϊ��ż��Ԫ������ʽ
pq = zeros(1, 8);
pq(1) = 1;
pq(2:4) = 0;
pq(6:8) = p(1:3);
pq(5) = 0;

Qib = Qi;
Qib(5:8) = -Qi(5:8);

Qis = Qi;
Qis(2:4) = -Qi(2:4);
Qis(6:8) = -Qi(6:8);

ptemp = dualQuaternionsMultiply(dualQuaternionsMultiply(Qib, pq), Qis) / dot(Qib(1:4), Qis(1:4));

pi = ptemp(6:8) / ptemp(1);