function [CQ, U, tip0, vector0] = dualquaternioninterpolation(data, splineorder, parameterizationmethod)
% ����B������ż��Ԫ����ֵ���ᵶ·
% �������
% data: ��ɢ��·����
% splineorder ���߽���
% parameterizationmethod
% ������������1�����ö�ż��Ԫ�����Ĳ�������2�����ö�ż��Ԫ���ҳ���������3����������Ĳ�������4��������ҳ�������
%
% �������
% CQ ��ż��Ԫ�����Ƶ�
% U ��Ϻ�Ľڵ�ʸ��
% tip0 ��ż��Ԫ����Ҫ�õ��ĳ�ʼ��
% vector0 ��ż��Ԫ����Ҫ�õ��ĳ�ʼ����

% ���ż��Ԫ����Ҫ�õ��ĳ�ʼ��
global p0;
p0 = [0 0 0];
tip0 = p0;

% ���ż��Ԫ����Ҫ�õ��ĳ�ʼ������
global V1;
V1 = [0 0 1];
% V1 = [sqrt(3)/3 sqrt(3)/3 sqrt(3)/3];
vector0 = V1;

% �����ϴ���Qʱ��ת��������������������ж����������ķ���
global lastEigVector;
lastEigVector = [0, 0, 0];

% ��������������ʱ����ŵı�־
global EigVectorSign;
EigVectorSign = 0;

pCount = size(data, 1);     % ��ȡ���ݵ�����

Q = zeros(pCount, 8);

% ���ż��Ԫ��
for i = 1:pCount
    Q(i, :) = getQi2(data(i, :), i);
end

% �����߽������
[CQ, U] = dualquatinter(splineorder, data, Q, parameterizationmethod);

% ���ȫ�ֱ����������������������޵���
clear p0
clear V1
clear lastEigVector
clear EigVectorSign