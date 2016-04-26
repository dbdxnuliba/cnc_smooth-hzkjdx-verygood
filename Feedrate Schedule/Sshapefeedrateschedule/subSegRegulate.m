function [ReSubSegmentUPara, ReSubSegmentFeedPeakSmall, ReSubSegmentFeedPeakBig, ReArcLengthVector] = subSegRegulate(subSegmentUPara, subSegmentFeedPeakSmall, subSegmentFeedPeakBig, arcLengthVector)
% �Էֶν��е����������ȷǳ�С�Ķκϲ�����

n = length(arcLengthVector) - 1;    % �������һ�α����ŵ�·�ܳ��ȣ����Ҫȥ��

% �趨����ĳ�����ֵ�����С��������������кϲ�
lengthThres = 3;

ReSubSegmentUPara(1:2) = subSegmentUPara(1:2);
ReSubSegmentFeedPeakSmall(1:2) = subSegmentFeedPeakSmall(1:2);
ReSubSegmentFeedPeakBig(1:2) = subSegmentFeedPeakBig(1:2);
ReArcLengthVector(1) = arcLengthVector(1);

lengthSum = 0;				% ����һ�ָ�㵽�˵㴦�����ۻ�����
segMinFeed = 10^10;			% ����һ�ָ�㵽�˵㴦�������ٶ���Сֵ
segMaxFeed = 0;				% ����һ�ָ�㵽�˵㴦�������ٶ����ֵ

splitPointNum = 3;	% �ָ����

i = 2;
while i <= n
	if arcLengthVector(i) + lengthSum < lengthThres && i < n
		% С����ֵ������Ϊһ�Σ����кϲ�
		lengthSum = lengthSum + arcLengthVector(i);	% ���������ۼ�
		
		% ���������С�ٶ�ֵ
		segMaxFeed = max(segMaxFeed, subSegmentFeedPeakBig(i + 1));
		segMinFeed = min(segMinFeed, subSegmentFeedPeakSmall(i + 1));
		
    else
        % �����ۻ����ȴ�����ֵ
        if i < n
            if arcLengthVector(i + 1) < 0.5
                ReArcLengthVector(splitPointNum - 1) = lengthSum + arcLengthVector(i) + arcLengthVector(i + 1);
                ReSubSegmentFeedPeakBig(splitPointNum) = max([segMaxFeed, subSegmentFeedPeakBig(i + 1), subSegmentFeedPeakBig(i + 2)]);
                ReSubSegmentFeedPeakSmall(splitPointNum) = min([segMinFeed, subSegmentFeedPeakSmall(i + 1), subSegmentFeedPeakSmall(i + 2)]);
                ReSubSegmentUPara(splitPointNum) = subSegmentUPara(i + 2);
                i = i + 2;
                
                lengthSum = 0;				% ����һ�ָ�㵽�˵㴦�����ۻ�����
                segMinFeed = 10^10;			% ����һ�ָ�㵽�˵㴦�������ٶ���Сֵ
                segMaxFeed = 0;				% ����һ�ָ�㵽�˵㴦�������ٶ����ֵ
		
                splitPointNum = splitPointNum + 1;
                continue;
            end
        end
		ReArcLengthVector(splitPointNum - 1) = lengthSum + arcLengthVector(i);
		ReSubSegmentFeedPeakBig(splitPointNum) = max(segMaxFeed, subSegmentFeedPeakBig(i + 1));
		ReSubSegmentFeedPeakSmall(splitPointNum) = min(segMinFeed, subSegmentFeedPeakSmall(i + 1));
		ReSubSegmentUPara(splitPointNum) = subSegmentUPara(i + 1);
		
		lengthSum = 0;				% ����һ�ָ�㵽�˵㴦�����ۻ�����
		segMinFeed = 10^10;			% ����һ�ָ�㵽�˵㴦�������ٶ���Сֵ
		segMaxFeed = 0;				% ����һ�ָ�㵽�˵㴦�������ٶ����ֵ
		
		splitPointNum = splitPointNum + 1;
    end
    i = i + 1;
end

ReArcLengthVector(splitPointNum - 1) = arcLengthVector(n + 1);
