function searchPRChord(startIndex, endIndex, PR, errLim)
% searchChord(lowIndex, hightIndex, segmentLines)
% �������ߵ㳬�����ĵ���Ϊ�����㡣
% ���룺lowIndex, hightIndex�ֱ��ʾ����������,SegmentLinesΪС�߶�, errLimΪ�����
% ����������������ĵ����ȫ�ֱ���

global featurePointsIndex;
global featurePointNum;

maxDis = 0;
maxDisIndex = startIndex;

for i = startIndex + 1 : endIndex - 1
    
    x1 = PR(startIndex, 1);
    y1 = PR(startIndex, 2);
    z1 = PR(startIndex, 3);

    dx = PR(endIndex, 1) - PR(startIndex, 1);
    dy = PR(endIndex, 2) - PR(startIndex, 2);
    dz = PR(endIndex, 3) - PR(startIndex, 3);

    xi = PR(i, 1);
    yi = PR(i, 2);
    zi = PR(i, 3);
    
  %  dis(i - startIndex) = abs(dy * xi + (y1 * dx - x1 * dy) - yi * dx) / sqrt(dy^2 + dx^2);
    dis(i - startIndex) = norm(cross([dx, dy, dz], [xi, yi, zi] - [x1, y1, z1])) / norm([dx, dy, dz]);
    
    if dis(i - startIndex) > errLim
        if dis(i - startIndex) > maxDis
            maxDis = dis(i - startIndex);       % ��¼��󹭸����
            maxDisIndex = i;    % ������󹭸ߵ���±�ֵ
        end
    end
end

% �����벻����0��˵������һЩ��Ĺ��������������
if maxDis ~= 0
    searchPRChord(startIndex, maxDisIndex, PR, errLim); 
    featurePointsIndex(featurePointNum) = maxDisIndex;
    featurePointNum = featurePointNum + 1;  
    searchPRChord(maxDisIndex, endIndex, PR, errLim);
end



