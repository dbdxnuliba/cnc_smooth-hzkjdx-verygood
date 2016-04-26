function sshapefeedrate = sshapefeedratescheduling(constraints, smoothpath, interpolationperiod)
% �Թ�˳��ĵ�·����S���ٶȹ滮
% ���������
% constraints���涨��Լ��������һ���ṹ�壬���������³�Ա��
%   selection �� ������ѡ���Լ�����������
%                   dynconstrsel �� ����ѧԼ����
%                   geoconstrsel �� ����Լ����
%                   oriconstrsel �� ����ת��Լ����
%                   driconstrsel �� ��������Լ����
%                   forconstrsel : ������Լ��
%   settings : ����������������ֵ�������� dynconstr ��geoconstr ��oriconstr �� driconstr
%   ��forconstr ����
% interpolationperiod �岹����

global KnotVector;  % �ڵ�����
global CP;      % ���Ƶ�
global curveDegree; % ���߽���
global p0;
global V0;

global maxJerk;	% ȫ�ֱ��������Ծ��
global maxAcc;		% ȫ�ֱ����������ٶ�
maxJerk = constraints.settings.dynconstr.maxjerk;
maxAcc = constraints.settings.dynconstr.maxacce;

global interpolationFrequence;
global interpolationPeriod;
interpolationPeriod = interpolationperiod;
interpolationFrequence = 1 / interpolationperiod;


if smoothpath.method == 1 || smoothpath.method == 2
    % ���ݲ�ͬ�ĸ�ʽ������Щȫ�ֱ������г�ʼ��
    KnotVector = smoothpath.dualquatpath.dualquatspline.knotvector;
    CP = smoothpath.dualquatpath.dualquatspline.controlp;
    curveDegree = smoothpath.dualquatpath.dualquatspline.splineorder;
    p0 = smoothpath.dualquatpath.tip0;
    V0 = smoothpath.dualquatpath.vector0;
elseif smoothpath.method == 3
    KnotVector = smoothpath.foursplineinterpath.tipspline.knotvector;
    CP = smoothpath.foursplineinterpath.tipspline.controlp;
    curveDegree = smoothpath.foursplineinterpath.tipspline.splineorder;
end

% �����ٶ�ɨ�衣
[subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = NurbsScanning(constraints, smoothpath, interpolationperiod);

% ����������ɭ��ʽ���ֵ�������λ���
arcLengthVector = NurbsSubSegArcLenCal(subSegmentUPara);

% �Գ����ر�С�Ķν��кϲ�����
% [subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, arcLengthVector] = subSegRegulate(subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, arcLengthVector);

% ����˫��ɨ��
[subSegmentFeedPeakSmall] = NurbsBiDirectionScanning(subSegmentUPara, subSegmentFeedPeakSmall, arcLengthVector);

% ��Nurbs���߽���ǰհ����
[subSegmentAccAccTime, subSegmentDecDecTime, subSegmentContVTime, subSegmentSType, subSegmentFinishTime, subSegmentFeedPeakSmall, subSegmentFeedPeakBig] =...
    NurbsLookAhead(subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, arcLengthVector);

% ��������
sshapefeedrate.subSegmentUPara = subSegmentUPara;
sshapefeedrate.subSegmentFeedPeakSmall = subSegmentFeedPeakSmall;
sshapefeedrate.subSegmentFeedPeakBig = subSegmentFeedPeakBig;
sshapefeedrate.arcLengthVector = arcLengthVector;

sshapefeedrate.subSegmentAccAccTime = subSegmentAccAccTime;
sshapefeedrate.subSegmentDecDecTime = subSegmentDecDecTime;
sshapefeedrate.subSegmentContVTime = subSegmentContVTime;
sshapefeedrate.subSegmentSType = subSegmentSType;
sshapefeedrate.subSegmentFinishTime = subSegmentFinishTime;

% ���ȫ�ֱ���
clear KnotVector
clear CP
clear curveDegree
clear p0
clear V0

clear maxJerk
clear maxAcc
clear interpolationFrequence
clear interpolationPeriod