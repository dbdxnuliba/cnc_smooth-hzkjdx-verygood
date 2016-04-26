function [QIterat, ErrV, U3, dominantPAf, NFul] = iterativeFitRealPart(Q, U, Ub, DQ, p, P, dominantPIndex, IteratErrLimit, NFul)
% ���ݵ���ʸ��������϶�ż��Ԫ����ʵ��
% Q���ǰ�Ŀ��ƶ�ż��Ԫ��
% U���ǰ�Ľڵ�ʸ��
% Ub �������õ��Ĳ�������
% p���߽���
% Pԭ������ɢ���ݵ�
% dominantPIndex �����㣨��Ӧ����ţ�
% IteratErrLimit ���е���ʱ�����
% NFul �����ʱ����õ���ϵ�������ڴ˿���ֱ��ʹ�ã����ټ���

global wkDominant; % ������Ȩ��ϵ��

% Q = Q(:, 1:4);  % ֻȡʵ�����ɣ����ټ���
% DQ = DQ(:, 1:4);
global V1;
vector1 = [0, V1 / norm(V1)];   % ����һ����ĵ���ʸ��дΪ��Ԫ����ʽ���������������

dominantPi = 1;  % ��ǰ������������ĶΣ���i��[dominantPIndex(dominantPi), dominantPIndex(dominantPi + 1))��
dominantNum = 1; % ��ǰ����������
maxErr = 0;     % ����������������
maxErrIndex = dominantPIndex(dominantPi); % ����������Ӧ������ֵ
ChangedFlag = 0;    % ������ı��־���˱�־Ϊ0���ʾ������û���޸ģ��������¼��㣬Ϊ1���ʾҪ�������¼���

pCount = size(P, 1);

ErrV = zeros(1, pCount);   % ����ʸ�����

% ������������λ������ϳ��������ߵ����
for i = 1:pCount
    % ���ҵ���ǰ�������������, i��[dominantPIndex(dominantPi), dominantPIndex(dominantPi + 1))

    % �������
    Qtemp = NFul(i, :) * Q;     % ֱ������ϵ��������˵õ���ֵ�㣬���ټ�����
    vectorTemp = quatmultiply(quatmultiply(Qtemp(1:4), vector1), quatconj(Qtemp(1:4))) / quatnorm(Qtemp(1:4));   % ������ϵõ��ĵ���ʸ��
    
    % ��������ɢ�㴦��������ֱ��������
    ErrV(i) = abs(acos(dot(vectorTemp(2:4) / norm(vectorTemp(2:4)), P(i, 4:6) / norm(P(i, 4:6))))) * 180 / pi;
	%ErrV(i) = acos(dot((p2Fit - pFit) / norm((p2Fit - pFit)), P(i, 4:6) / norm(P(i, 4:6)))) * 180 / pi;	% ���㵶��ʸ���ĽǶ�ƫ��
    
    % �ҵ���������޵��������Ӧ�ĵ�
    if ErrV(i) > maxErr && ErrV(i) > IteratErrLimit && i ~= dominantPIndex(dominantPi) && i~= dominantPIndex(dominantPi + 1)
        maxErr = ErrV(i);
        maxErrIndex = i;
    end
    
    % ˵���˶��Ѿ��������
    if i == dominantPIndex(dominantPi + 1)
        % �������
        dominantP(dominantNum) = dominantPIndex(dominantPi);
        dominantNum = dominantNum + 1;
        % ��������������ޣ��򽫴�����ֵ��������
        if maxErr ~= 0 && maxErrIndex ~= dominantPIndex(dominantPi)
            ChangedFlag = 1;
            dominantP(dominantNum) = maxErrIndex;
            dominantNum = dominantNum + 1;
        end
        
        dominantPi = dominantPi + 1;
        maxErr = 0;
        maxErrIndex = dominantPIndex(dominantPi);
    end
end
dominantP(dominantNum) = dominantPIndex(dominantPi);    % ��������һ��������

if ChangedFlag ~= 0

    % ��������㷢���仯����Ҫ�����������
    n = length(dominantP) - 1;
  %  m = size(P, 1) - 1;
    m = n;
    Ubb = Ub(dominantP);
    
    % ��ڵ�����
    U2 = zeros(1, n + p + 2);  
    if m == n
        for j = 0 : n + p + 1
            if j <= p
                U2(j + 1) = 0;
            elseif j >= n + 1
                U2(j + 1) = 1;
            else
                for i = 1:p
                    U2(j + 1) = U2(j + 1) + Ubb(j - i + 1);
                end
                U2(j + 1) = U2(j + 1) / p;
            end
        end
    else
        for j = 1:n - p
            c = (m + 1) / (n - p + 1);
            i = round(j * c - 0.5);
            alfa = j * c - i;
            U2(j + p + 1) = (1 - alfa) * Ub(i) + alfa * Ub(i + 1);
        end
    end
    
%     % ��ϵ������
%     for i = 1 : pCount - 2
%         for j = 1 : n - 1
%             N(i, j) = GetBaseFunVal(Ub(i + 1), j, p, U2);
%         end
%     end
    
    % ����ϵ������
    NFul = zeros(pCount, n + 1);

    for i = 1:pCount
        for j = 1:n + 1
            NFul(i, j) = GetBaseFunVal(Ub(i), j - 1, p, U2);
        end
    end
    N = NFul(2:pCount - 1, 2:n);    % ��С����ʵ����ֻ�õ����е�һ����

    
    wk = ones(1, pCount);
    wk(dominantP) = wkDominant;
    
    Ri = DQ(2 : pCount - 1, :);
    for i = 1:pCount - 2
        N0pUbi = GetBaseFunVal(Ub(i + 1), 0, p, U2);
        NnpUbi = GetBaseFunVal(Ub(i + 1), n, p, U2);
        Ri(i, :) = Ri(i, :) - DQ(1, :) * N0pUbi - DQ(pCount, :) * NnpUbi;
        Ri(i, :) = Ri(i, :) * wk(i + 1);
    end
    
    wkN = N;
    for i = 1:pCount - 2
        wkN(i, :) = wk(i + 1) * N(i, :);
    end
    
    Q1 = (N'*wkN)\(N'*Ri);

%     Q1 = SolveLeastSquaresLinearFunctions(N, Ri);
    Q(1, :) = DQ(1, :);
    Q(2:n, :) = Q1;
    Q(n + 1, :) = DQ(pCount, :);
        
    % ���е�������
    [QIterat, ErrV, U3, dominantPAf, NFul] = iterativeFitRealPart(Q, U2, Ub, DQ, p, P, dominantP, IteratErrLimit, NFul);

else 
    % ����������Ҫ����ԭ�����������;
    QIterat = Q;
    U3 = U;
    dominantPAf = dominantP;
end