function [AccT, DecT, ContT, SType, finishT, subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = NurbsLookAhead(subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, arcLengthVector)
% �����ٶ�ǰհ�����Ӽ���S�͹滮
% ���������Ϊ�Ӽ��ٶ�ʱ�䡢�������ٶ�ʱ�䡢����ʱ���Լ�S����������

global maxAcc;
global maxJerk;

% �岹Ƶ�ʣ����岹����Ts = 0.5ms
global interpolationFrequence;
global interpolationPeriod;

subSegmentNum = length(subSegmentUPara) - 1;	% �Ӷ���

maxAccVel = maxAcc^2 / maxJerk;

% �׶δ���
if (sqrt(subSegmentFeedPeakSmall(2) / maxJerk) * subSegmentFeedPeakSmall(2) > arcLengthVector(1))
	% ���������������˵����0�ټӵ�ĩ�٣����Ӿ��볬���������ȣ��ٶȲ��ɴ���Сĩ�˵��ٶȴ�С
	subSegmentFeedPeakSmall(2) = (arcLengthVector(1)^2 * maxJerk)^(1 / 3);
	subSegmentFeedPeakBig(2) = subSegmentFeedPeakSmall(2);
end

% ĩ�˴���
if sqrt(subSegmentFeedPeakSmall(subSegmentNum) / maxJerk) * subSegmentFeedPeakSmall(subSegmentNum) > arcLengthVector(subSegmentNum)
	% ����������˵�����ٳ��Ȳ��������޸�ĩ�ε���ʼ�ٶ�
	subSegmentFeedPeakSmall(subSegmentNum) = (arcLengthVector(subSegmentNum)^2 * maxJerk)^(1 / 3);
	subSegmentFeedPeakBig(subSegmentNum + 1) = subSegmentFeedPeakSmall(subSegmentNum);
end

% ѭ���жϸ��Ӷε�����ٶ��Ƿ������˶�ѧԼ��
for i = 1:subSegmentNum
	if (subSegmentFeedPeakBig(i + 1) > subSegmentFeedPeakSmall(i) + maxAccVel) 
		% ��������㣬��˵���Ӷ�����ٶ���Ծ�����޵�Լ���²��ɴﵽ����Ҫ��������ٶ�
		subSegmentFeedPeakBig(i + 1) = min(subSegmentFeedPeakSmall(i), subSegmentFeedPeakSmall(i + 1)) + maxAccVel;
	end
end

% ѭ����ÿ�ν��мӼ��ٹ滮
for i = 1:subSegmentNum
	% �Ա��Ӷε���ֹ���ٶȡ�����ٶȡ�������ֵ
	Vstr = subSegmentFeedPeakSmall(i);
	Vend = subSegmentFeedPeakSmall(i + 1);
	Vmax = subSegmentFeedPeakBig(i + 1);
	Len = arcLengthVector(i);
	
	if Vstr == Vend
		if Vstr == Vmax
			% ���������������Ϊ���ٶΣ�Type1
			[AccT(i), DecT(i), ContT(i), SType(i)] = SprofilePlanType1(Vstr, Vend, Vmax, Len);
		else
			[AccT(i), DecT(i), ContT(i), SType(i), subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = AccDecProfilePlan(Vstr, Vend, Vmax, Len, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, i);
        end 
    elseif Vstr > Vend
        % �жϳ�ʼ�ٶȺ�����ٶ�֮��Ĺ�ϵ
        if Vstr == Vmax
            Lr4 = (Vstr + Vend) * sqrt((Vstr - Vend) / maxJerk);
            if abs(Lr4 - Len) < 10^(-6)
                % ���������������˵����ֱ�Ӽ��ٵ���������ռ��ٹ滮
                [AccT(i), DecT(i), ContT(i), SType(i)] = SprofilePlanType6(Vstr, Vend, Vmax, Len);
            else
                % ���� + ����
                [AccT(i), DecT(i), ContT(i), SType(i)] = SprofilePlanType7(Vstr, Vend, Vmax, Len, Lr4);
            end
        else
            % ��������Ӷλ�������
            [AccT(i), DecT(i), ContT(i), SType(i), subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = AccDecProfilePlan(Vstr, Vend, Vmax, Len, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, i);
        end
    else
        if Vend == Vmax
            Lr4 = (Vstr + Vend) * sqrt((Vend - Vstr) / maxJerk);
            if abs(Lr4 - Len) < 10^(-6)
                % ���������������˵����ֱ�Ӽ��ٵ���������ռ��ٹ滮
                [AccT(i), DecT(i), ContT(i), SType(i)] = SprofilePlanType2(Vstr, Vend, Vmax, Len);
            else
                % ���� + ����
                [AccT(i), DecT(i), ContT(i), SType(i)] = SprofilePlanType3(Vstr, Vend, Vmax, Len, Lr4);
            end
        else
            % ��������Ӷλ�������
            [AccT(i), DecT(i), ContT(i), SType(i), subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = AccDecProfilePlan(Vstr, Vend, Vmax, Len, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, i);
        end
	end
end

sumT = 0;
for i = 1:subSegmentNum
    finishT(i) = 2 * AccT(i) + 2 * DecT(i) + ContT(i) + sumT;
    sumT = finishT(i);
end
