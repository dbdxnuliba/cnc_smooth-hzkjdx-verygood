function N = basisFuns(i, u, p, U)
% ����õ������B������������ֵ
% ����iΪҪ�����Ni,p�е�����ֵ��һ����findSpan�������
% uΪ����
% pΪ����
% UΪ�ڵ�����
% ���NΪһ�����������а������еķ���ֵ
N = zeros(1, p + 1);
right = zeros(1, p + 1);
left = zeros(1, p + 1);
N(1) = 1;

for j = 1: p
    left(j + 1) = u - U(i + 1 - j + 1);
    right(j + 1) = U(i + j + 1) - u;
    saved = 0;
    for r = 0:j - 1
        temp = N(r + 1) / (right(r + 2) + left(j - r + 1));
        N(r + 1) = saved + right(r + 2) * temp;
        saved = left(j - r + 1) * temp;
    end
    N(j + 1) = saved;
end
