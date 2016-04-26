function uls = CaculateuDerls(u)
% ����߽�����

global KnotVector;  % �ڵ�����
global CP;      % ���Ƶ�
global curveDegree; % ���߽���

bspline.controlp = CP;
bspline.knotvector = KnotVector;
bspline.splineorder = curveDegree;

CDerus= DeBoorCoxNurbsCal( u, bspline, 3); % ����u������ֵ�㡢һ�׶������׵�ʸ

% plot(u, norm(CDerus(4, :)), '*');

fu = norm(CDerus(2, :));
fu1 = dot(CDerus(2, :), CDerus(3, :)) / fu;
fu2 = (dot(CDerus(3, :), CDerus(3, :)) + dot(CDerus(2, :), CDerus(4, :)) - fu1^2) / fu;

ul = 1/fu;
ul2 = -fu1 / fu^3;
ul3 = (3*fu1^2 - fu2*fu) / fu^5;

uls = [ul ul2 ul3]';

