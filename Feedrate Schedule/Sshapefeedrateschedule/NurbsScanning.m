function [subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig] = NurbsScanning(constraints, smoothpath, interpolationperiod)
% �����ٶȼ�ֵɨ�裬�õ��ֶ���Ϣ�����ε��ٶ������Сֵ�Լ���Ӧ�ֶε�u��ֵ

Ts = interpolationperiod / 2;			% �岹����

% �����͵���ο���ĳ�ʼ��
p0 = smoothpath.dualquatpath.tip0;



chordErr = constraints.settings.geoconstr;

curvatureNurbsPreLast = 0;	% ���ϴε�����ֵ;
curvatureNurbsLast = 0; 	% �ϴε�����ֵ
curvatureNurbs = 0;			% ����ֵ
lastFiveStepFeed = zeros(1, 4);	% ǰ���Ĳ�ʱ���ٶȣ�����ʹ��5�������ٶȵ�ʸ
 
oneSubSegmentFlag = 0;	% ֻ��һ���Ӷεı�־λ
subSegmentMaxFeed = 0;	% �Ӷ�������ٶȣ�

uNurbs = 0;	% ���߲���

cenAccLimitedCurvature = constraints.settings.dynconstr.maxacce / constraints.settings.dynconstr.maxvelo^2;	% ���ļ��ٶ��趨��������ֵ

jerkLimitedCurvature = sqrt(constraints.settings.dynconstr.maxjerk / constraints.settings.dynconstr.maxvelo^3);	% Ծ���趨������ֵ

% ȡ�������Ƶ���Сֵ;
curvatureLimitMin = min([0.5, cenAccLimitedCurvature, jerkLimitedCurvature]);

subSegmentNum = 2;
stepNumber = 1;

while uNurbs < 1
    if smoothpath.method == 1 || smoothpath.method == 2
        
        % ������ֵ�㼰һ�����׵�ʸ
        DeBoorP = DeBoorCoxNurbsCal(uNurbs, smoothpath.dualquatpath.dualquatspline, 2);
        % ����ֵ��
        knotCor(stepNumber, :) = TransformViaQ(p0, DeBoorP(1, :));    
    elseif smoothpath.method == 3
        % ���������������ֵ����ֻ���㵶���
        DeBoorP = DeBoorCoxNurbsCal(uNurbs, smoothpath.foursplineinterpath.tipspline, 2);
        knotCor(stepNumber, :) = DeBoorP(1, :);
    end
    % ���±��������ֵ;
    curvatureNurbsPreLast = curvatureNurbsLast;
	curvatureNurbsLast = curvatureNurbs;
    
    if smoothpath.method == 1 || smoothpath.method == 2
        % ��ǰ�������
        [der1, der2] = DerCalFromQ(p0, DeBoorP(2, :), DeBoorP(3, :), DeBoorP(1, :));    % ��һ���׵�ʸ
        curvatureNurbs = norm(cross(der1, der2)) / norm(der1)^3;                        % �������ʹ�ʽ������
    elseif smoothpath.method == 3
        curvatureNurbs = norm(cross(DeBoorP(2, :), DeBoorP(3, :))) / norm(DeBoorP(2, :))^3;
    end
    
%     curvetureArr(stepNumber, 1) = uNurbs;
%     curvetureArr(stepNumber, 2) = curvatureNurbs;
    
    curvatureRadiusNurbs = 1 / curvatureNurbs;	% �������ʰ뾶
	
    if constraints.selection.geoconstrsel == 1
        % ����Ts�����ʰ뾶�������������ٶȣ�kcbc���ȼ���Vaf��Vcbf��ȷ��V(ui)
        chordLimitedFeed = 2 / Ts * sqrt(curvatureRadiusNurbs ^ 2 - (curvatureRadiusNurbs - chordErr)^2);
    else
        chordLimitedFeed = constraints.settings.dynconstr.maxvelo;
    end
	
	adaptiveAlgorithmFeed = min([constraints.settings.dynconstr.maxvelo, chordLimitedFeed]);     % Vaf
	curvatureAlgorithmFeed = 1 * constraints.settings.dynconstr.maxvelo / (curvatureNurbs + 1);	% Vcbf
	
    if constraints.selection.dynconstrsel == 1
        maxAccLimitedFeed = sqrt(constraints.settings.dynconstr.maxacce / curvatureNurbs);					% ������ٶ��ٶ�Լ��	
        maxJerkLimitedFeed = (constraints.settings.dynconstr.maxjerk / curvatureNurbs^2)^(1 / 3);	% ����Ծ���ٶ�Լ��
    else
        maxAccLimitedFeed = constraints.settings.dynconstr.maxvelo;
        maxJerkLimitedFeed = constraints.settings.dynconstr.maxvelo;
    end
	
	% �õ�Vaf, Vbf, F �Լ����ٶȡ�Ծ��Լ���µ��ٶ���Сֵ
	currentStepFeed = min([adaptiveAlgorithmFeed, curvatureAlgorithmFeed, constraints.settings.dynconstr.maxvelo, maxAccLimitedFeed, maxJerkLimitedFeed]);
	
    feedLimitArr(stepNumber) = currentStepFeed;
    
	% ����5�������ٶȵ���
	currentStepFeedDer1 = 1 / (12 * Ts) * (3 * lastFiveStepFeed(1) - 16 * lastFiveStepFeed(2) + 36 * lastFiveStepFeed(3) - 48 * lastFiveStepFeed(4) + 25 * currentStepFeed);
	% ���±����ǰ�����ٶ�
	lastFiveStepFeed = [lastFiveStepFeed(2:4), currentStepFeed];
	
	% ȷ����һ�������������浱ǰ����u
	uNurbsLast = uNurbs;
% 	uNurbs = uNurbs + (currentStepFeed * Ts + Ts^2 * currentStepFeedDer1 / 2) / norm(DeBoorP(2, :)) - (currentStepFeed * Ts)^2 * (dot(DeBoorP(2, :), DeBoorP(3, :))) / (2 * (norm(DeBoorP(2, :)))^4);
	uNurbs = uNurbs + 0.0005;
	if (uNurbs > uNurbsLast) && (uNurbs > 0.001)
		if (curvatureNurbsLast > curvatureNurbs) && (curvatureNurbsLast > curvatureNurbsPreLast)
			% �����������������ֵ��������ô��������Ϊһ���Ӷδ���������Ӧ�����ݣ�
			if curvatureNurbsLast >= curvatureLimitMin
				oneSubSegmentFlag = 1;
				subSegmentUPara(subSegmentNum) = uNurbsLast;
				subSegmentFeedPeakBig(subSegmentNum) = subSegmentMaxFeed;
				subSegmentFeedPeakSmall(subSegmentNum) = lastStepFeed;
                splitPoints(subSegmentNum, :) = knotCor(stepNumber, :);     % ����ֶε����꣬����鿴��
				subSegmentNum = subSegmentNum + 1;
				subSegmentMaxFeed = 0;
			end
		end
	end	
	% �����Ӷ�������ٶȣ�
	subSegmentMaxFeed = max(subSegmentMaxFeed, currentStepFeed);
	% ���浱ǰ�ٶ�ֵ��
	lastStepFeed = currentStepFeed;
    
%     uNurbs = uNurbs + 0.001;      % �����ã�������Ԥ�岹��ֱ�ӵȾ��ۼӲ���u
    stepNumber = stepNumber + 1;
end

% figure;
% % ���ƶ�ż��Ԫ����õ���������
% plot(curvetureArr(:, 1), curvetureArr(:, 2));
% % readCurvature = importdata('.\data\inputdata\Curvature.txt');
% % hold on;
% % plot(readCurvature(:, 1), readCurvature(:, 2), 'r');
% set(gca, 'fontsize', 25);
% title('Curvature');
% ylim([0 5]);
% hold on;
% % ������VC������õ���������
% curvatureVs = importdata('Curvature.txt');
% plot(curvatureVs(:, 1), curvatureVs(:, 2), 'r');
% % ������Matlabֱ�ӶԵ�����ֵ��õ���������
% load('interpolateCurvature.mat');
% plot(curvatureArr(:, 1), curvatureArr(:, 2), 'g');


if oneSubSegmentFlag == 1
	% ����Ӷε���ʼ�ٶ�Ϊ0 
	subSegmentFeedPeakSmall(1) = 0;
	% ��ĩ�Ӷε���ֹ�ٶ�Ϊ0
	subSegmentUPara(subSegmentNum) = 1;
	subSegmentFeedPeakSmall(subSegmentNum) = 0;
	subSegmentFeedPeakBig(subSegmentNum) = subSegmentMaxFeed;
else
	% ���û���ٶȹյ㣬��ô��ʼ�ٶȺ���ֹ�ٶȾ�Ϊ0����������ٶ�Ϊ���ε�����ٶ�
	subSegmentFeedPeakSmall(1) = 0;
	subSegmentUPara(subSegmentNum) = 1;
	subSegmentFeedPeakSmall(subSegmentNum) = 0;
	subSegmentFeedPeakBig(2) = subSegmentMaxFeed;
end

% figure;
% plot3(knotCor(:, 1), knotCor(:, 2), knotCor(:, 3));
% hold on;
% plot3(splitPoints(:, 1), splitPoints(:, 2), splitPoints(:, 3), '*r');
% title('split points', 'fontsize', 24);
% set(gca, 'fontsize', 25);