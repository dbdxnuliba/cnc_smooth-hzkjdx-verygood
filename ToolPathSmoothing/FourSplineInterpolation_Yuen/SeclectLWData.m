function LW = SeclectLWData(Wb, Ub)
% ѡȡLW���ݵ�(lk, wk)

%% �ȶ�ȫ�ֱ������г�ʼ���������֮ǰ����õ��Ľ��
global simpsonVector;       % ��������������ɭ��ʽ�������������(u, l)ֵ
simpsonVector = zeros(1, 2);

global simpsonVectorIndex;  % �˱���Ϊ�����ݵ������
simpsonVectorIndex = 2;

global iterativeNumber; % ��������
iterativeNumber = 0;

%% ��ʼ���ֲ�����
n = length(Wb);
LW = zeros(n, 2);
LW(:, 2) = Wb';

%% ���зֶμ���lk
for i = 2:n
    startPoint = Ub(i - 1);
    endPoint = Ub(i);
    midPoint = (startPoint + endPoint) / 2;
    
    IterativeCalArcLength( startPoint, midPoint, endPoint);
    LW(i, 1) = sum(simpsonVector(:, 2));
end