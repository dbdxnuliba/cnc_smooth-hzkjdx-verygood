function IterativeCalArcLength2(startPoint, endPoint)
% ���������Ӷλ���

global arcLength;

simpsonErr = 10^(-4);

% ��������ɭ���ֵ����ϰ��
midPoint = (startPoint + endPoint) / 2;
subStartPoint = startPoint;
subEndPoint = midPoint;
subMidPoint = (subStartPoint + subEndPoint) / 2;

subArcLengthUpHalf = ArcLengthSimpson(subStartPoint, subMidPoint);
subArcLengthLowerHalf = ArcLengthSimpson(subMidPoint, subEndPoint);
subArcToltal = ArcLengthSimpson(subStartPoint, subEndPoint);

if (abs(subArcLengthUpHalf + subArcLengthLowerHalf - subArcToltal) < simpsonErr)
	arcLength = arcLength + subArcToltal;	% �������Ҫ�����ۼ����γ���
else
	IterativeCalArcLength2(subStartPoint, subEndPoint);	%������������Ҫ����������ֽ��е���
end

% ��������ɭ���ֵ����°��
subStartPoint = midPoint;
subEndPoint = endPoint;
subMidPoint = (midPoint + endPoint) / 2;

subArcLengthUpHalf = ArcLengthSimpson(subStartPoint, subMidPoint);
subArcLengthLowerHalf = ArcLengthSimpson(subMidPoint, subEndPoint);
subArcToltal = ArcLengthSimpson(subStartPoint, subEndPoint);

if (abs(subArcLengthUpHalf + subArcLengthLowerHalf - subArcToltal) < simpsonErr)
	arcLength = arcLength + subArcToltal;	% �������Ҫ�����ۼ����γ���
else
	IterativeCalArcLength2(subStartPoint, subEndPoint);	%������������Ҫ����������ֽ��е���
end