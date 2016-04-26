function [Q, U, Ub] = positionFitting(P, p)
%  [Q, U�� Ub] = positionFitting(P, p)�Ե���λ�õ���в�ֵ��������Ƶ�
% PΪ��ɢ�����ݵ㣬pΪҪ��ֵ�Ľ���
% QΪ��������Ŀ��Ƶ㣬UΪ�ڵ�������UbΪ���Ĳ�������õ��Ĳ���ʸ�����ں�����(l,w)��ɢ���ݵ��ʱ����Ҫ�õ�

n = size(P, 1) - 1; 

% ���Ĳ�����
Ub = zeros(1, n);
for i = 2:n + 1
    Ub(i) = sqrt(norm(P(i, 1:3) - P(i - 1, 1:3))) + Ub(i - 1);
end
Ub = Ub / Ub(n + 1);

U = zeros(1, n + p + 2);
U(n + 2: n + p + 2) = 1;

% �þ��Ȼ������õ��ڵ�����
for j = 1:n - p
    for i = j : j + p - 1
        U(j + p + 1) = U(j + p + 1) + Ub(i + 1);
    end
    U(j + p + 1) = U(j + p + 1) / p;
end

% ��ϵ�����󡣴�ǰ�ο�ʩ�������д���д�ĺ���GetBaseFunVal������
N = zeros(n + 1, n + 1);
for i = 0:n
    for j = 0:n
        N(i + 1, j + 1) = oneBasisFun(Ub(i + 1), j, p, U);
    end
end

% ����Ƶ�
Q = N\P(:, 1:3);