function derSqrtSumSqrt = ArcLengthDerivative(u)
% �������ڼ��㻡���������߲���u�ĵ�ʸֵ�ĺ������༴ds/du=��(x'^2+y'^2+z'^2)

global KnotVector;  % �ڵ�����
global CP;      % ���Ƶ�
global curveDegree; % ���߽���
global p0;

bspline.controlp = CP;
bspline.knotvector = KnotVector;
bspline.splineorder = curveDegree;

DeBoorP= DeBoorCoxNurbsCal( u, bspline, 2); % ����u������ֵ�㡢һ�׶������׵�ʸ

m = size(CP, 2);

if m == 3
    % ˵������ά�ռ��е���������
    derSqrtSumSqrt = norm(DeBoorP(2, :));    % ����ʸ����
elseif m == 8
    % ˵���Ƕ�ż��Ԫ����ʽ������
    [der1, der2] = DerCalFromQ(p0, DeBoorP(2, :), DeBoorP(3, :), DeBoorP(1, :));
    derSqrtSumSqrt = norm(der1);
end

