function scheduleresult = calscheduleresult(sshapefeedrate, smoothpath, interpolationperiod)
% ���滮�õ���·���������ٶȼ�ֵ���ߡ��滮���ߡ����ٶ����ߵ�

global KnotVector;  % �ڵ�����
global CP;      % ���Ƶ�
global curveDegree; % ���߽���
global p0;
global V0;
global interpolationPeriod;
global interpolationFrequence;

interpolationPeriod = interpolationperiod;
interpolationFrequence = 1 / interpolationPeriod;

% ���ݲ�ͬ�ĸ�ʽ������Щȫ�ֱ������г�ʼ��
if smoothpath.method == 1 || smoothpath.method == 2

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

subSegmentFeedPeakSmall = sshapefeedrate.subSegmentFeedPeakSmall;
subSegmentFeedPeakBig = sshapefeedrate.subSegmentFeedPeakBig;

subSegmentAccAccTime = sshapefeedrate.subSegmentAccAccTime;
subSegmentDecDecTime = sshapefeedrate.subSegmentDecDecTime;
subSegmentContVTime = sshapefeedrate.subSegmentContVTime;
subSegmentFinishTime = sshapefeedrate.subSegmentFinishTime;

% ���в岹���㣬�õ����
scheduleresult = NurbsInterpProcess(subSegmentFeedPeakSmall, subSegmentFeedPeakBig, subSegmentAccAccTime, subSegmentDecDecTime, subSegmentContVTime, subSegmentFinishTime, smoothpath);

clear KnotVector
clear C
clear curveDegree
clear p0
clear V0
clear interpolationPeriod
clear interpolationFrequence