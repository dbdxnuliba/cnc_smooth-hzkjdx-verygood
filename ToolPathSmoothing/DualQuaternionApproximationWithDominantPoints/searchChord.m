function searchChord(startIndex, endIndex, segmentLines, Q, TLErrLimit, vectLimit)
% searchChord(lowIndex, hightIndex, segmentLines)
% �������ߵ㳬�����ĵ���Ϊ�����㡣
% ���룺lowIndex, hightIndex�ֱ��ʾ����������,SegmentLinesΪС�߶�, errLimΪ�����
% ����������������ĵ����ȫ�ֱ���

global featurePointsIndex;
global featurePointNum;

maxDis = 0;
maxDisIndex = startIndex;

PL = segmentLines(:, 1:3);
% PR = segmentLines(:, 1:3) + toolLen * segmentLines(:, 4:6);

QR = Q(:, 1:4); % ȡ��ż��Ԫ��ʵ��������ѡ����ʸ���Ĺ��ߵ���

for i = startIndex + 1 : endIndex - 1
    
    x1 = PL(startIndex, 1);
    y1 = PL(startIndex, 2);
    z1 = PL(startIndex, 3);

    dx = PL(endIndex, 1) - PL(startIndex, 1);
    dy = PL(endIndex, 2) - PL(startIndex, 2);
    dz = PL(endIndex, 3) - PL(startIndex, 3);

    xi = PL(i, 1);
    yi = PL(i, 2);
    zi = PL(i, 3);
    
  %  dis(i - startIndex) = abs(dy * xi + (y1 * dx - x1 * dy) - yi * dx) / sqrt(dy^2 + dx^2);
    dis(i - startIndex) = norm(cross([dx, dy, dz], [xi, yi, zi] - [x1, y1, z1])) / norm([dx, dy, dz]);
    
    if dis(i - startIndex) > TLErrLimit
        if dis(i - startIndex) > maxDis
            maxDis = dis(i - startIndex);       % ��¼��󹭸����
            maxDisIndex = i;    % ������󹭸ߵ���±�ֵ
        end
    end
end

% �����벻����0��˵������һЩ��Ĺ��������������
if maxDis ~= 0
    searchChord(startIndex, maxDisIndex, segmentLines, Q, TLErrLimit, vectLimit); 
    featurePointsIndex(featurePointNum) = maxDisIndex;
    featurePointNum = featurePointNum + 1;  
    searchChord(maxDisIndex, endIndex, segmentLines, Q, TLErrLimit, vectLimit);
% ���������������㹭�����Ҫ������е����ϲο������߹�������
elseif maxDis == 0
    searchVectorChord(startIndex, maxDisIndex, QR, vectLimit)
    searchVectorChord(maxDisIndex, endIndex, QR, vectLimit);
end



