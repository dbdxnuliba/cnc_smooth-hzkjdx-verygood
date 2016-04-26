function FP = SearchDominantPionts(P, curvatureThr, chordThrL, chordThrV, Q)
% ScanFeaturePionts(P) ɨ�����ߣ��õ������㡣
% �����PΪ��ɢ�����ݵ㣬curvatureThrΪ������ֵ��chordThrΪ���ߵ���ֵ QΪλ�ƶ�Ӧ�Ķ�ż��Ԫ�����ڶԵ���ʸ��ѡ��������ʱʹ��
% ɨ��õ�������������ȫ�ֱ��� featurePointsIndex �� featurePointNum ��

global featurePointsIndex;
global featurePointNum;
featurePointsIndex = 0;     % ʹ��ȫ�ֱ���һ��Ҫ��ʼ���������ϴ����еĽ���������
featurePointNum = 1;

PL = P(:, 1:3);                         % �����

pCount = size(P, 1);    % ���ݵ�����

% ����ÿ�ε��ҳ�
chordLenL = zeros(1, pCount - 1);   % ���������ÿ���ҳ�

for i = 1 : pCount - 1
    chordLenL(i) = norm(PL(i + 1, :) - PL(i, :));
end

% ����нǵ�����ֵ
LineCosL = zeros(1, pCount - 2);    % ��������߸��㴦�Ƕ�����ֵ

for i = 1:pCount - 2
    LineCosL(i) = dot(PL(i + 2, :) - PL(i + 1, :),...
        PL(i + 1, :) - PL(i, :)) / (chordLenL(i + 1) * chordLenL(i));
end

% ɨ�����ߣ���¼������
curvatureL = zeros(1, pCount - 2);
for i = 1:pCount - 2
    % ������ɢ����
    curvatureL(i) = 2 * sqrt(1 - LineCosL(i)^2) / norm(PL(i + 2, :) - PL(i, :));
    p1to3V = PL(i + 2, :) - PL(i, :);
    p1to3NV(1) = -p1to3V(2);
    p1to3NV(2) = p1to3V(1);
    p1to3NV(3) = p1to3V(3);
    p1to2dotN = dot(PL(i + 1, :) - PL(i, :), p1to3NV);
    if p1to2dotN >= 0
        curvatureL(i) = -curvatureL(i);
    end
end

% ���ҵ�������ߵ����ʼ�Сֵ��
curvatureMinIndexL = zeros(1, pCount - 3);
curvatureMinIndexL(1) = 1;
curvatureMinNumL = 2;
for i = 2:pCount - 3
    if abs(curvatureL(i)) < abs(curvatureL(i - 1)) && abs(curvatureL(i)) < abs(curvatureL(i + 1))
        curvatureMinIndexL(curvatureMinNumL) = i;
        curvatureMinNumL = curvatureMinNumL + 1;
    end
end

% ���������е����ʼ�ֵ��͹����
extremePIndexL(1) = 1;   % �����������ʼ���ֵ������ʹ���㶼���ڴ�������
extremePNumL = 2;        % ��ʾ���鳤��
isMaxCurvatureL(1) = 1;  % ����extremePIndex�м������ʼ�ֵ�㣬���й���㣬�˱����������֡���������ʼ���ֵ��Ϊ1������Ϊ0
nearMinAbskSearchIndexL = 1;    % ��ʾi����������Сֵ�������
for i = 2:pCount - 3
    if(abs(curvatureL(i) > abs(curvatureL(i - 1)))) && abs(curvatureL(i)) > abs(curvatureL(i + 1))    
        % �ж�Ϊ����ֵ������������������������Сֵ�Ĳ�ֵ
        % ���ҵ�i����������Сֵ������
        while i > curvatureMinIndexL(nearMinAbskSearchIndexL)
            nearMinAbskSearchIndexL = nearMinAbskSearchIndexL + 1;
             if nearMinAbskSearchIndexL > length(nearMinAbskSearchIndexL)
                 nearMinAbskSearchIndexL = length(nearMinAbskSearchIndexL);
                 break;
             end
        end
        
        % �ҵ�i��ǰ��һ����СֵfmincurvatureL
        if nearMinAbskSearchIndexL == 1
            fmincurvatureL = 0;
        else
            fmincurvatureL = abs(curvatureL(curvatureMinIndexL(nearMinAbskSearchIndexL)));
        end
        
        % �ҵ�i���һ����СֵlmincurvatureL
        if nearMinAbskSearchIndexL >= curvatureMinNumL - 1
            lmincurvatureL = 0;
        else
            lmincurvatureL = abs(curvatureL(curvatureMinIndexL(nearMinAbskSearchIndexL + 1)));
        end
                
        % ��������ʼ���ֵ������ֵ����ǰ��ͺ������ʼ�Сֵһ����ֵ����Ϊ����Ч�ļ�ֵ�㣬��������
        if (abs(curvatureL(i)) - fmincurvatureL > curvatureThr) || (abs(curvatureL(i)) - lmincurvatureL > curvatureThr)
            extremePIndexL(extremePNumL) = i;
            isMaxCurvatureL(extremePNumL) = 1;
            extremePNumL = extremePNumL + 1;
        end
    % ���ڲ��Ǽ���ֵ�ĵ��ж��Ƿ�Ϊ����㣬��������жϹ��ߵ��ʱ����Ҫ�õ� 
    elseif (curvatureL(i) * curvatureL(i - 1) < 0 && curvatureL(i) * curvatureL(i + 1) > 0) ...
%             ||...
%             (curvatureL(i) * curvatureL(i - 1) > 0 && curvatureL(i) * curvatureL(i + 1) < 0)
        extremePIndexL(extremePNumL) = i;
        isMaxCurvatureL(extremePNumL) = 0;
        extremePNumL = extremePNumL + 1;
    end
end

extremePIndexL(extremePNumL) = pCount;

for i = 1:extremePNumL - 1
    startIndex = extremePIndexL(i);
    endIndex = extremePIndexL(i + 1);
    
    % �����ж���ʼ�㣬�����ʼ���Ǽ���ֵ�����¼Ϊ������
    if isMaxCurvatureL(i) == 1
        featurePointsIndex(featurePointNum) = extremePIndexL(i);
        featurePointNum = featurePointNum + 1;
    end
    searchChord(startIndex, endIndex, P, Q, chordThrL, chordThrV);
end
featurePointsIndex(featurePointNum) = pCount;
featurePointNum = featurePointNum + 1;
FP = featurePointsIndex;

% ���ȫ�ֱ��������ⱻ�����������
clear featurePointsIndex
clear featurePointNum