function searchVectorChord(startIndex, endIndex, Q, errLimA)
% �԰��յ����켣��������������������㵶��ʸ���������
% Q Ϊ����ʸ����Ӧ����Ԫ����errLimA Ϊ�ǶȾ���ƫ�����ֵ����������ֵ�����������
% ������Ϻ���ӵ�����������featurePointsIndex ��

global featurePointsIndex;
global featurePointNum;

maxDis = 0;
maxDisIndex = startIndex;

for i = startIndex + 1 : endIndex - 1
    % ���������յ����Ԫ��
    ts = Q(startIndex, 1:4);
	te = Q(endIndex, 1:4);
	
	sita = acos(dot(ts, te));		% �������յ�ĽǶȾ���
    
	ti = Q(i, 1:4);
	
	% ���㴦��Ӧ��u��ֵ�������Ƶ������������ᵶ·������ѡ�� ��Ԫ����ʾ����ʸ����
	u = 1 / sita * atan((dot(ti, te) - dot(ti, ts) * cos(sita)) / (dot(ti, ts) * sin(sita)));
	
	% ����
	tit = sin(sita - u * sita) / sin(sita) * ts + sin(u * sita) / sin(sita) * te;
	
	% ��ǶȾ���
    dis(i - startIndex) = acos(dot(ti, tit)) * 180 / pi;
    
    if dis(i - startIndex) > errLimA
        if dis(i - startIndex) > maxDis
            maxDis = dis(i - startIndex);       % ��¼��󹭸����
            maxDisIndex = i;    % ������󹭸ߵ���±�ֵ
        end
    end
end

% �����벻����0��˵������һЩ��Ĺ��������������
if maxDis ~= 0
    searchPRChord(startIndex, maxDisIndex, Q, errLimA); 
    featurePointsIndex(featurePointNum) = maxDisIndex;
    featurePointNum = featurePointNum + 1;  
    searchPRChord(maxDisIndex, endIndex, Q, errLimA);
end
