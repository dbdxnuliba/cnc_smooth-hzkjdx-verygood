function IterativeNineOrderFitting(startIndex, endIndex)

global feedCorrectionFittingErr;    % ����������

global UL;      % ���еĴ���ϵ�

global FeedCorrectionCoff;  % ��ϵõ��Ķ���ʽϵ��

global FeedCorrectionStartL; % ��϶ε���ʼL

global FeedCorrectionLength; % ��϶εĳ���S

global FeedCorrectionNum;    % �α��

%% ��ǰ��ν������
subStartIndex = startIndex;
subEndIndex = round((startIndex + endIndex) / 2);

[polyFittingCoeff, startL, Length] = NineOrderFitting(subStartIndex, subEndIndex);  % ��ǰ��ν������

us = CaculateuWhithl(UL(subStartIndex:subEndIndex, 2), polyFittingCoeff, startL, Length);  % �������ϵõ��ĵ�

% ���зֳ����ν�����ϣ�������㾫��Ҫ�󣬻��ߵ������ڵ���9���˳�����������Ͻ��
if sum(abs(UL(subStartIndex:subEndIndex, 1) - us)) < feedCorrectionFittingErr || subEndIndex - subStartIndex <= 19
    FeedCorrectionCoff(FeedCorrectionNum, :) = polyFittingCoeff;
    FeedCorrectionStartL(FeedCorrectionNum) = startL;
    FeedCorrectionLength(FeedCorrectionNum) = Length;
    FeedCorrectionNum = FeedCorrectionNum + 1;
else
    % ��������㾫��Ҫ�����ٴν��е���
    IterativeNineOrderFitting(subStartIndex, subEndIndex);
end

%% �Ժ��ν������
subStartIndex = subEndIndex;
subEndIndex = endIndex;

[polyFittingCoeff, startL, Length] = NineOrderFitting(subStartIndex, subEndIndex);  % �Ժ��ν������

us = CaculateuWhithl(UL(subStartIndex:subEndIndex, 2), polyFittingCoeff, startL, Length);  % �������ϵõ��ĵ�

% ������㾫��Ҫ�󣬻��ߵ������ڵ���9���˳�����������Ͻ��
if sum(abs(UL(subStartIndex:subEndIndex, 1) - us)) < feedCorrectionFittingErr || subEndIndex - subStartIndex <= 19
    FeedCorrectionCoff(FeedCorrectionNum, :) = polyFittingCoeff;
    FeedCorrectionStartL(FeedCorrectionNum) = startL;
    FeedCorrectionLength(FeedCorrectionNum) = Length;
    FeedCorrectionNum = FeedCorrectionNum + 1;
else
    IterativeNineOrderFitting(subStartIndex, subEndIndex);
end
