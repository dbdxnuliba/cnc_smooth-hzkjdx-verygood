function IterativeCalArcLength( startPoint, midPoint, endPoint)
% �������ڵ������㻡���ĺ���
% startPoint, midPoint, endPoint�ֱ�ΪҪ���е�������㡢�е���յ㡣
% �������Ľ��������ȫ�ֱ���simpsonVector�С�

global simpsonErr;
global simpsonVector;       % ��������������ɭ��ʽ�������������(u, l)ֵ
global simpsonVectorIndex;  % �˱���Ϊ�����ݵ������
global iterativeNumber;     % ��������

%% �ȼ���ǰһ�������
subStartPoint = startPoint;
subMidPoint = (startPoint + midPoint) / 2;
subEndPoint = midPoint;

subArcLengthUpperHalf = ArcLengthSimpson(subStartPoint, subMidPoint);
subArcLengthLowerHalf = ArcLengthSimpson(subMidPoint, subEndPoint);
totalArcLength = ArcLengthSimpson(subStartPoint, subEndPoint);

iterativeNumber = iterativeNumber + 1;

if abs(subArcLengthUpperHalf + subArcLengthLowerHalf - totalArcLength) < simpsonErr
    simpsonVector(simpsonVectorIndex, 1) = subEndPoint;
    simpsonVector(simpsonVectorIndex, 2) = totalArcLength;
    simpsonVectorIndex = simpsonVectorIndex + 1;
else
    IterativeCalArcLength(subStartPoint, subMidPoint, subEndPoint);
end

%% �����������
subStartPoint = midPoint;
subMidPoint = (endPoint + midPoint) / 2;
subEndPoint = endPoint;

subArcLengthUpperHalf = ArcLengthSimpson(subStartPoint, subMidPoint);
subArcLengthLowerHalf = ArcLengthSimpson(subMidPoint, subEndPoint);
totalArcLength = ArcLengthSimpson(subStartPoint, subEndPoint);

if abs(subArcLengthUpperHalf + subArcLengthLowerHalf - totalArcLength) < simpsonErr
    simpsonVector(simpsonVectorIndex, 1) = subEndPoint;
    simpsonVector(simpsonVectorIndex, 2) = totalArcLength;
    simpsonVectorIndex = simpsonVectorIndex + 1;
else
    IterativeCalArcLength(subStartPoint, subMidPoint, subEndPoint);
end

end

