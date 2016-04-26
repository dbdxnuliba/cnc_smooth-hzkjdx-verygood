function [Q, U, polycoef, startpiont, sublength, B, W, LW, WQ] = foursplineinterp(data)

curveDegree = 5;

[Q, U, Ub] = positionFitting(data, curveDegree);           % ��ֵ����ÿ��Ƶ�

ParaLenP = nurbsBlockLengthCal(U, curveDegree, Q);      % ������ɭ��ʽ��(u,l)��ɢ��

[polycoef, startpiont, sublength] = nineOrderFittingul( ParaLenP ); % ���þŽ׶���ʽ���(u,l)��

[B, W, Wb] = OrientationFitting(data, curveDegree);        % �Ե���ʸ�����в�ֵ

LW = SeclectLWData(Wb, Ub);     % ��ȡ��ɢ��(lk, wk)���ݵ�

WQ = OrientationReparamterization(LW);

clear KnotVector
clear CP
clear curveDegree