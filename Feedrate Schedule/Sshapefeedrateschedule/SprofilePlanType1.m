function [subSegmentAccAccTime, subSegmentDecDecTime, subSegmentContVTime, subSegmentSType] = SprofilePlanType1(subSegmentVstr, subSegmentVend, subSegmentVmax, subSegmentLength)
% ���ٶ��ٶȹ滮

global interpolationFrequence;

subSegmentAccAccTime = 0;
subSegmentDecDecTime = 0;
subSegmentContVTime = subSegmentLength / subSegmentVstr * interpolationFrequence;
subSegmentSType = 1;