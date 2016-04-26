function [biScannedFeed] = NurbsBiDirectionScanning(subSegmentUPara, subSegmentFeedPeakSmall, arcLengthVector)
% ��Nurbs���߽���˫��ɨ��

global maxJerk;	% ȫ�ֱ��������Ծ��
global maxAcc;		% ȫ�ֱ����������ٶ�

n = length(arcLengthVector);

% ���ٶȼ�ֵ��ʼ��
biScannedFeed = zeros(1, n);

% �Ƚ��з���ɨ��
for i = n - 1 : -1 : 2
	if i == n - 1
		% ��������һ�Σ���ֱ�Ӽ�����ٶȼ�ֵ
		feedrateConstr = (arcLengthVector(i)^2 * maxJerk) ^ (1 / 3);
	else
		% ������е�������
		iteratNow = biScannedFeed(i + 1);
		iteratLast = 0;
		k1 = 4 * iteratNow;
		k2 = k1 * iteratNow;
		k3 = arcLengthVector(i)^2 * maxJerk;
		
		while abs(iteratLast - iteratNow) > 10^(-6)
			iteratLast = iteratNow;
			iteratNow = iteratLast - (iteratLast^3 + k1 * iteratLast^2 + k2 * iteratLast - k3) /...
			(3 * iteratLast^2 + 2 * k1 * iteratLast + k2);
		end
		
		feedrateConstr = iteratNow + biScannedFeed(i + 1);
	end
	
	% ����subSegmentFeedPeakSmall�е��ٶ��ǿ����˹����������ٶȼ�Ծ��Լ�����õ��ģ�����ֱ��ȡ��Сֵ����
	biScannedFeed(i) = min([feedrateConstr, subSegmentFeedPeakSmall(i), maxAcc^2 / maxJerk + biScannedFeed(i + 1)]);
end

%% ����ɨ��
biScannedFeed(1) = 0;
for i = 2:n - 1
	% ���ڵ�һ�Σ�ֱ����⣬�������
	if i == 2
		feedrateConstr = (arcLengthVector(i - 1)^2 * maxJerk) ^ (1 / 3);
	else
		iteratNow = biScannedFeed(i - 1);
		iteratLast = 0;
		k1 = 4 * iteratNow;
		k2 = k1 * iteratNow;
		k3 = arcLengthVector(i - 1)^2 * maxJerk;
		
		while abs(iteratLast - iteratNow) > 10^(-6)
			iteratLast = iteratNow;
			iteratNow = iteratLast - (iteratLast^3 + k1 * iteratLast^2 + k2 * iteratLast - k3) /...
			(3 * iteratLast^2 + 2 * k1 * iteratLast + k2);
		end
		feedrateConstr = iteratNow + biScannedFeed(i - 1);
	end
	biScannedFeed(i) = min(feedrateConstr, subSegmentFeedPeakSmall(i));
end