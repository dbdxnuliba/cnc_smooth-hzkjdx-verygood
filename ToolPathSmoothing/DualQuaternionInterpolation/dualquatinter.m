function [CQ, U] = dualquatinter(p, P, Q, parameterizationmethod)
% �Զ�ż��Ԫ�����в�ֵ����
% ���������
% p�� ���߽���
% P�� ��ɢ��λ��
% Q�� ��ż��Ԫ�� 
% parameterizationmethod
% ������������1�����ö�ż��Ԫ�����Ĳ�������2�����ö�ż��Ԫ���ҳ���������3����������Ĳ�������4��������ҳ�������
%
% ���������
% CQ ��ż��Ԫ�����Ƶ�
% U ��Ϻ�Ľڵ�ʸ��

pCount = size(P, 1);
n = pCount - 1;
m = n;

%% ���յ����������Ĳ�����
Ub = zeros(1, pCount);

% ���ն�ż��Ԫ���������Ĳ�����
for i = 2:pCount
%     Ub(i) = sqrt(norm(P(i, 1:3) - P(i - 1, 1:3))); % ֻ���ǵ����Ĳ�����
%     Ub(i) = sqrt(norm(P(i, 1:3) - P(i - 1, 1:3))) + 3 * sqrt(acos((dot(P(i, 4:6), P(i - 1, 4:6))) / norm(P(i, 4:6)) / norm(P(i - 1, 4:6))));  % �ۺϿ��ǵ���ʸ���͵����λ�ý��в�����
    if parameterizationmethod == 1
        Ub(i) = sqrt(norm(Q(i, :) - Q(i - 1, :)));
    elseif parameterizationmethod == 2
        Ub(i) = norm(Q(i, :) - Q(i - 1, :));  % ֱ�����ö�ż��Ԫ�����в�����
    elseif parameterizationmethod == 3
        Ub(i) = sqrt(norm(P(i, 1:3) - P(i - 1, 1:3))); % ֻ���ǵ����Ĳ�����
    elseif parameterizationmethod == 4
        Ub(i) = norm(P(i, 1:3) - P(i - 1, 1:3)); % ֻ���ǵ����Ĳ�����
    end
    
    Ub(i) = Ub(i) + Ub(i - 1);
    
end

Ub = Ub / Ub(pCount);

% ���ýڵ�����
U = zeros(1, n + p + 2);
U(1:p + 1) = 0;
U(n + 2:n + p + 2) = 1;
if m == n
    % ���m = n ʹ�þ��Ȼ������õ��ڵ�ʸ��
    for j = 0: n + p + 1
         if j <= p
            U(j + 1) = 0;
        elseif j >= n + 1
            U(j + 1) = 1;
        else
            for i = 1:p
                U(j + 1) = U(j + 1) + Ub(j - i + 1);
            end
            U(j + 1) = U(j + 1) / p;
         end
    end
end

% ����ϵ������
NFul = zeros(pCount, n + 1);

for i = 1:pCount
    for j = 1:n + 1
        NFul(i, j) = GetBaseFunVal(Ub(i), j - 1, p, U);
    end
end
N = NFul(2:pCount - 1, 2:n);    % ��С����ʵ����ֻ�õ����е�һ����

Ri = Q(2 : pCount - 1, :);
for i = 1:pCount - 2
    N0pUbi = GetBaseFunVal(Ub(i + 1), 0, p, U);
    NnpUbi = GetBaseFunVal(Ub(i + 1), n, p, U);
    Ri(i, :) = Ri(i, :) - Q(1, :) * N0pUbi - Q(pCount, :) * NnpUbi;
    Ri(i, :) = Ri(i, :);
end

CQ = zeros(n + 1, 8);
CQ(1, :) = Q(1, :);
CQ(n + 1, :) = Q(pCount, :);

CQ(2:n, :) = (N' * N) \ (N' * Ri);    % ������Է����飬�õ����Ƶ�
