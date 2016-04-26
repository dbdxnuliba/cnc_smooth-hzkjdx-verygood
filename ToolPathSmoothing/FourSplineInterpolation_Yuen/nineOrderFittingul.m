function [polyFittingCoeff, startL, Length] = nineOrderFittingul( ulData )
%���þŽ׶���ʽ���U(l)����
%   ����ulDataΪ��һ����������ɭ�����㷨��õ�u(l)��ɢ��
%   ���Ϊ��ϵõ��Ķ���ʽϵ���Ͷ�Ӧ�����

global feedCorrectionFittingErr;    % ����������
feedCorrectionFittingErr = 0.001;

global UL;      % ���еĴ���ϵ�
UL = ulData;

global FeedCorrectionCoff;  % ��ϵõ��Ķ���ʽϵ��
FeedCorrectionCoff = zeros(1, 10);

global FeedCorrectionStartL; % ��϶ε���ʼL
FeedCorrectionStartL = 0;

global FeedCorrectionLength; % ��϶εĳ���S
FeedCorrectionLength = 0;

global FeedCorrectionNum;    % �α��
FeedCorrectionNum = 1;

startIndex = 1;
endIndex = size(ulData, 1);

[alfa, startL, S] = NineOrderFitting(startIndex, endIndex);         % �ȶԴ˶ν������
us = CaculateuWhithl(UL(startIndex:endIndex, 2), alfa, startL, S);  % �������ϵõ��ĵ�
if sum(abs(UL(startIndex:endIndex, 1) - us)) < feedCorrectionFittingErr     % ���������������㾫��Ҫ�����¼�˼�����
    FeedCorrectionCoff(FeedCorrectionNum, :) = alfa;
    FeedCorrectionStartL(FeedCorrectionNum) = startL;
    FeedCorrectionLength(FeedCorrectionNum) = S;
    FeedCorrectionNum = FeedCorrectionNum + 1;
else
    % ������е�������
    IterativeNineOrderFitting(startIndex, endIndex);
end

polyFittingCoeff = FeedCorrectionCoff;
startL = FeedCorrectionStartL;
Length = FeedCorrectionLength;


