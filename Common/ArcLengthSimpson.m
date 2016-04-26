function L = ArcLengthSimpson(startPoint, endPoint)
% ��������ɭ��ʽ���㵥�����߻���

midPoint = (startPoint + endPoint) / 2;
segmentLength = endPoint - startPoint;

% ����������㡢�е㡢�յ㴦��ʸ����f(u)
simpsonSum1 = ArcLengthDerivative(startPoint);
simpsonSum2 = ArcLengthDerivative(midPoint);
simpsonSum3 = ArcLengthDerivative(endPoint);

% ��������ɭ��ʽ�����
L = ((segmentLength / 6) * (simpsonSum1 + 4 * simpsonSum2 + simpsonSum3));
