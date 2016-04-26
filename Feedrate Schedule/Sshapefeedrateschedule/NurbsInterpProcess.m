function scheduleresult = NurbsInterpProcess(feedSmall, feedBig, accT, decT, contT, finT, smoothpath)
% �岹����

global interpolationFrequence;

global maxJerk;

global CP;

global p0;

maxJerkmode2 = maxJerk / 2;

subNum = length(accT);
tempLoopIndex = 0;
subSegmentInterpIndex = 1;

deBoorP = zeros(4, 3);
deBoorPLast = zeros(4, 3);
deBoorPLast(1, :) = p0; 

lastStepFeed = 0;
lastStepAcc = 0;
uNurbs = 0;

%% �������
splitPointFlag = 1;
splitPNum = 1;


%% �岹
while tempLoopIndex <= round(finT(subNum))
    if tempLoopIndex == 0
        uNurbs = 0;
        uNurbsLast = 0;
        Vstr = feedSmall(subSegmentInterpIndex);
        Vend = feedSmall(subSegmentInterpIndex + 1);
        
        % ��ȡ�����׶�ʱ��
        subAccT = accT(subSegmentInterpIndex) / interpolationFrequence;
        subDecT = decT(subSegmentInterpIndex) / interpolationFrequence;
        subConT = contT(subSegmentInterpIndex) / interpolationFrequence;
        
        % ��ȡʱ����
        subAccTNum = accT(subSegmentInterpIndex);
        subDecTNum = decT(subSegmentInterpIndex);
        subConTNum = contT(subSegmentInterpIndex);
        
        Vmax = Vstr + maxJerk * subAccT^2;
        type1VelDeltaCv = Vstr;
        type2VelDeltaCv = Vstr - maxJerk * subAccT^2;
        type4VelDeltaCv = Vstr + maxJerk * subAccT^2;
        type5VelDeltaCv = Vend;
		
        maxJerkMulAccTimeMul2 = 2 * maxJerk * subAccT;
        accAndCvTimeSum = 2 * subAccT + subConT;
        segTimeSum = accAndCvTimeSum + 2 * subDecT;
    end
    
    while tempLoopIndex > round(finT(subSegmentInterpIndex))
        subSegmentInterpIndex = subSegmentInterpIndex + 1;
		
		Vstr = feedSmall(subSegmentInterpIndex);
        Vend = feedSmall(subSegmentInterpIndex + 1);
		Vmax = feedBig(subSegmentInterpIndex + 1);
		
		% ��ȡ�����׶�ʱ��
        subAccT = accT(subSegmentInterpIndex) / interpolationFrequence;
        subDecT = decT(subSegmentInterpIndex) / interpolationFrequence;
        subConT = contT(subSegmentInterpIndex) / interpolationFrequence;
        
        % ��ȡʱ����
        subAccTNum = accT(subSegmentInterpIndex);
        subDecTNum = decT(subSegmentInterpIndex);
        subConTNum = contT(subSegmentInterpIndex);
        
        type1VelDeltaCv = Vstr;
        type2VelDeltaCv = Vstr - maxJerk * subAccT^2;
        type4VelDeltaCv = Vstr + maxJerk * subAccT^2;
        type5VelDeltaCv = Vend;
		
        maxJerkMulAccTimeMul2 = 2 * maxJerk * subAccT;
        accAndCvTimeSum = 2 * subAccT + subConT;
        segTimeSum = accAndCvTimeSum + 2 * subDecT;
        
        splitPointFlag = 1;
    end
	
	if subSegmentInterpIndex == 1
		addTemp = 0;	
	else
		addTemp = finT(subSegmentInterpIndex - 1);
	end

	deltaSubSegmentTime = (tempLoopIndex - addTemp) / interpolationFrequence;

	if tempLoopIndex <= subAccTNum + addTemp
		% ˵�����ڼӼ��ٽ׶�
		currentStepFeed = type1VelDeltaCv + maxJerkmode2 * deltaSubSegmentTime^2;
		currentStepAcc = maxJerk * deltaSubSegmentTime;
        sJerkPlan(tempLoopIndex + 1) = maxJerk;
	elseif tempLoopIndex <= 2 * subAccTNum + addTemp			%�ж��Ƿ񵽴�Ӽ���ʱ��ĩβ
		% ���û�е�����ڼӼ��ٽ׶�
        
		currentStepFeed = type2VelDeltaCv - maxJerkmode2 * deltaSubSegmentTime^2 + maxJerkMulAccTimeMul2 * deltaSubSegmentTime;
		currentStepAcc = maxJerkMulAccTimeMul2 - maxJerk * deltaSubSegmentTime;
        
        sJerkPlan(tempLoopIndex + 1) = -maxJerk;
	elseif tempLoopIndex <= 2 * subAccTNum + subConTNum + addTemp		%�ж��Ƿ�ﵽ����ʱ��ĩβ

		% ���û�дﵽ������������
		currentStepFeed = Vmax;
		currentStepAcc = 0;
        sJerkPlan(tempLoopIndex + 1) = 0;
        
	elseif tempLoopIndex <= 2 * subAccTNum + subConTNum + subDecTNum + addTemp		% �ж��Ƿ񵽴����������ʱ��ĩβ
		% ���û�е�������������
		currentStepFeed = type4VelDeltaCv - maxJerkmode2 * (deltaSubSegmentTime - accAndCvTimeSum)^2;
		currentStepAcc = maxJerk * (accAndCvTimeSum - deltaSubSegmentTime);
        sJerkPlan(tempLoopIndex + 1) = -maxJerk;
	else
		currentStepFeed = type5VelDeltaCv + maxJerkmode2 * (segTimeSum - deltaSubSegmentTime)^2;
		currentStepAcc = maxJerk * (deltaSubSegmentTime - segTimeSum);
        sJerkPlan(tempLoopIndex + 1) = maxJerk;
	end

	sVelProfilePlan(tempLoopIndex + 1) = currentStepFeed;
    sAccPlan(tempLoopIndex + 1) = currentStepAcc;
    
    if splitPointFlag == 1
        splitPoints(splitPNum, 1) = tempLoopIndex / interpolationFrequence;
        splitPoints(splitPNum, 2) = currentStepFeed;
        splitPNum = splitPNum + 1;
        splitPointFlag = 0;
    end
    
    % ������ֵ�㼰һ�����׵�ʸ
	DeBoorQ = DeBoorCoxNurbsCal(uNurbs, smoothpath.dualquatpath.dualquatspline, 2);
    % ����ֵ��
    knotCor = TransformViaQ(p0, DeBoorQ(1, :));
    % ��ǰ�������
    [der1, der2] = DerCalFromQ(p0, DeBoorQ(2, :), DeBoorQ(3, :), DeBoorQ(1, :));    % ��һ���׵�ʸ
    
    deBoorP(1, :) = knotCor;
    deBoorP(2, :) = der1;
    deBoorP(3, :) = der2;
    
    % ����岹�㴦�����ʼ��������
    [interpStepCurvature(tempLoopIndex + 1), interpStepChordErr(tempLoopIndex + 1)] = CurrentStepCurvature(currentStepFeed, deBoorP);
	% �����ٶ�Լ��ֵ
	feedLimit(tempLoopIndex + 1) = FeedLimitCal(interpStepCurvature(tempLoopIndex + 1));
%     % �����ٶȲ���ֵ
%     [actlFeedrate(tempLoopIndex + 1), actlFeedrateFluctuateErr(tempLoopIndex + 1), actlFeedrateFluctuateErrZhu(tempLoopIndex + 1)] = ...
%         FeedFluctuationActlAndPredicted(currentStepFeed, lastStepFeed, interpStepCurvature(tempLoopIndex + 1), deBoorP, deBoorPLast);
    
    % ������μ��������
    lastStepFeed = currentStepFeed;
    lastStepAcc = currentStepAcc;
    lastStepCurvature = interpStepCurvature(tempLoopIndex + 1);
    
    deBoorPLast = deBoorP;
    
    interpCor(tempLoopIndex + 1, :) = deBoorP(1, :);
    
    uParaVector(tempLoopIndex + 1) = uNurbs;
    
    tempLoopIndex = tempLoopIndex + 1;	
	% ����̩�ն���չ������һ������u
    uNurbs = SecondTalorForInterp(uNurbs, lastStepFeed, lastStepAcc, deBoorP, tempLoopIndex);
	
	if uNurbs > 1
		break;
    end
end

scheduleresult.sVelProfilePlan = sVelProfilePlan;
scheduleresult.sAccPlan = sAccPlan;
scheduleresult.sJerkPlan = sJerkPlan;
scheduleresult.feedLimit = feedLimit;
scheduleresult.t = 0:1/interpolationFrequence:(length(sVelProfilePlan) - 1)/interpolationFrequence;

scheduleresult.interpCor = interpCor;
scheduleresult.uParaVector = uParaVector;

% fontsize = 25;
% figure('units','normalized','position',[0.1,0.1,0.5,0.5]);
% t = 0:1/interpolationFrequence:(length(sVelProfilePlan) - 2)/interpolationFrequence;
% plot(t, sVelProfilePlan(1:length(sVelProfilePlan) - 1));
% 
% xlabel('Time (sec)','fontsize',fontsize) % �����������˵��
% % y��ı�ǩ
% ylabel('Feedrate ( mm/s )','fontsize',fontsize) % �����������˵����
% h = gca; % ��ȡ��ǰ��ͼ�����ָ��
% % �趨�����С
% set(h,'FontSize',fontsize); % �������ִ�С��ͬʱӰ���������ע��ͼ��������ȡ�
% axis([0 length(sVelProfilePlan)/interpolationFrequence 0 110])
% 
% figure;
% plot(t, sVelProfilePlan(1:length(sVelProfilePlan) - 1));
% hold on;
% 
% if length(t) > length(feedLimit)
%     plot(t(1:length(feedLimit)), feedLimit, 'g');   
% else
%     plot(t, feedLimit(1:length(t)), 'g');
% end
% 
% plot(splitPoints(:, 1), splitPoints(:, 2), '*')
% 
% wrfile = fopen('.\data\outputdata\scheduling profile.txt', 'w');
% for i = 1:length(sVelProfilePlan)-1
%     fprintf(wrfile, '%f %f\n', t(i), sVelProfilePlan(i));
% end
% fclose(wrfile);
% plot(actlFeedrate, 'r');
% 
% figure;
% plot3(interpCor(:, 1), interpCor(:, 2), interpCor(:, 3), '*');


