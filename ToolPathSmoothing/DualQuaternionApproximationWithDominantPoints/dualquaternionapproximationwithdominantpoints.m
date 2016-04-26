function [CQ, U, errtip, errorie, tip0, vector0] = dualquaternionapproximationwithdominantpoints(data, splineorder, curvaturethr, tipchord, orientationchord, tipiterativeaccu, orientationiterativeaccu, parameterizationmethod)
% ����������ѡ��Ķ�ż��Ԫ���ƽ��㷨
% ���������
% data: ��ɢ��·����
% splineorder ���߽���
% curvaturethr ������ѡ��ʱ������ֵ
% tipchord ������ѡ��ʱ������Ҹ���ֵ
% orientationchord ������ѡ��ʱ����ʸ���Ҹ���ֵ
% tipiterativeaccu �������ʱ������������
% orientationiterativeaccu �������ʱ����ʸ���������
% parameterizationmethod
% ������������1�����ö�ż��Ԫ�����Ĳ�������2�����ö�ż��Ԫ���ҳ���������3����������Ĳ�������4��������ҳ�������
%
% ���������
% CQ ��ż��Ԫ�����Ƶ�
% U ��Ϻ�Ľڵ�ʸ��
% errtip �����������
% errorie ����ʸ��������
% tip0 ��ż��Ԫ����Ҫ�õ��ĳ�ʼ��
% vector0 ��ż��Ԫ����Ҫ�õ��ĳ�ʼ����

global wkDominant; % ������Ȩ��ϵ��
wkDominant = 4;

% �����ϴ���Qʱ��ת��������������������ж����������ķ���
global lastEigVector;
lastEigVector = [0, 0, 0];

% ��������������ʱ����ŵı�־
global EigVectorSign;
EigVectorSign = 0;

global p0;
p0 = [0 0 0];
tip0 = p0;

global V1;
V1 = [ 0 0 1];
% V1 = [sqrt(3)/3 sqrt(3)/3 sqrt(3)/3];
vector0 = V1;

pCount = size(data, 1);     % ��ȡ���ݵ�����

Q = zeros(pCount, 8);

for i = 1:pCount
    Q(i, :) = getQi2(data(i, :), i);
end

% ����ɸѡ������
dominantPIndex = SearchDominantPionts(data, curvaturethr, tipchord, orientationchord, Q);

% �����߽������
[CQ, U, Ub, NFul] = BSplineMotionFitting(splineorder, data, dominantPIndex, Q, parameterizationmethod);

[QIterat, ErrV, U2, dominantPAf, NFul] = iterativeFitRealPart(CQ, U, Ub, Q, splineorder, data, dominantPIndex, orientationiterativeaccu, NFul);
[QIterat, ErrCL, ErrRL, U2, dominantPAf, NFul] = iterativeFitting(QIterat, U2, Ub, Q, splineorder, data, dominantPAf, tipiterativeaccu, NFul);

CQ = QIterat;
U = U2;

errtip = ErrCL;
vector1 = [0 V1];

for i = 1:pCount
    % ���ҵ���ǰ�������������, i��[dominantPIndex(dominantPi), dominantPIndex(dominantPi + 1))

    % �������
    Qtemp = NFul(i, :) * CQ;     % ֱ������ϵ��������˵õ���ֵ�㣬���ټ�����
    vectorTemp = quatmultiply(quatmultiply(Qtemp(1:4), vector1), quatconj(Qtemp(1:4))) / quatnorm(Qtemp(1:4));   % ������ϵõ��ĵ���ʸ��
    
    % ��������ɢ�㴦��������ֱ��������
    ErrV(i) = abs(acos(dot(vectorTemp(2:4) / norm(vectorTemp(2:4)), data(i, 4:6) / norm(data(i, 4:6))))) * 180 / pi;
	%ErrV(i) = acos(dot((p2Fit - pFit) / norm((p2Fit - pFit)), P(i, 4:6) / norm(P(i, 4:6)))) * 180 / pi;	% ���㵶��ʸ���ĽǶ�ƫ��
end
errorie = ErrV;

% ���ȫ�ֱ���
clear wkDominant
clear lastEigVector
clear EigVectorSign
clear p0
clear V1