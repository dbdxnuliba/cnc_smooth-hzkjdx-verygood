function arcLengthVector = NurbsSubSegArcLenCal(subSegmentUPara)
% ��������ɭ��ʽ+���ֵ�����ÿ�λ���
% �����arcLengthVector ��ǰ��Ϊÿ�Ӷεĳ��ȣ����һ������Ϊ��·�ܳ�

% ����ȫ�ֱ��������������Ӷλ���ʱ��
global arcLength;
arcLength = 0;

arcLengthWhole = 0;

% �Ӷ���
subSegmentNum = length(subSegmentUPara) - 1;

% ��ʼ��
arcLengthVector = zeros(1, subSegmentNum + 1);

for tempLoopIndex = 1:subSegmentNum
    
    %% ������
    if tempLoopIndex == subSegmentNum
        a = 0;
    end
    %%
    
	% ��ʼ�����ֶγ��ȼ������õ���ֵ
    startPoint = subSegmentUPara(tempLoopIndex);
    endPoint = subSegmentUPara(tempLoopIndex + 1);
	
	arcLength = 0;	% �ܳ������㣬�Խ�����һ�ε���
    
    IterativeCalArcLength2(startPoint, endPoint);	% ���������Ӷλ���
	
	arcLengthVector(tempLoopIndex) = arcLength;		% �����Ӷλ���
	
	arcLengthWhole = arcLengthWhole + arcLength;	% �ۼ��ܳ���
end

arcLengthVector(subSegmentNum + 1) = arcLengthWhole;

clear arcLength