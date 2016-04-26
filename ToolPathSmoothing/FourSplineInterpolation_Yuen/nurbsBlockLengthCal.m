function ParaLenP = nurbsBlockLengthCal( U, p, P)
%ParaLenP = nurbsBlockLengthCal( U, p, P) ��������ͻ���������ϵ���ݵ�
%   �˺�����������ɭ��ʽ�������м��㣬���յõ�һϵ�в���u�ͻ���l��Ӧ����ɢ��

global simpsonErr;
simpsonErr = 10^(-4);  % ���������ɭ��ʽ�������㾫��

global simpsonVector;       % ��������������ɭ��ʽ�������������(u, l)ֵ
simpsonVector = zeros(1, 2);

global simpsonVectorIndex;  % �˱���Ϊ�����ݵ������
simpsonVectorIndex = 2;

global KnotVector;  % �ڵ�����
KnotVector = U;    

global CP;      % ���Ƶ�
CP = P;

global curveDegree; % ���߽���
curveDegree = p;   

global iterativeNumber; % ��������
iterativeNumber = 0;

startPoint = 0;                         % ��ʼ��
endPoint = 1;                           % �յ�
midPoint = (startPoint + endPoint) / 2; % �м��

% ���˶����߷ֳ����ν��м��㲢��һ�μ���õ��Ļ������бȽ�
arcLengthUpperHalf = ArcLengthSimpson(startPoint, midPoint);
arcLengthLowerHalf = ArcLengthSimpson(midPoint, endPoint);
arcLengthTotal = ArcLengthSimpson(startPoint, endPoint);

% �����ּ����һ�μ���������Χ�ڣ���˵��������Խ��ܣ�������Ϊ������
if abs(arcLengthUpperHalf + arcLengthLowerHalf - arcLengthTotal) < simpsonErr
    simpsonVector(simpsonVectorIndex, 1) = 1;
    simpsonVector(simpsonVectorIndex, 2) = arcLengthTotal;
    simpsonVectorIndex = simpsonVectorIndex + 1;
else
    % ������е�������
    iterativeNumber = iterativeNumber + 1;
    IterativeCalArcLength(startPoint, midPoint, endPoint);
end

% �����Ӷγ��Ƚ����ۼ�
for i = 1:simpsonVectorIndex - 1
    if i > 1
        simpsonVector(i, 2) = simpsonVector(i, 2) + simpsonVector(i - 1, 2);
    end
end

ParaLenP = simpsonVector;

end

