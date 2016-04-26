function [L, C] = positionQuinticSplineFitting( P )
%�Ե����λ�����߽�����׶���ʽ���
%   ����PΪ��·��ɢ���ݵ㣬���lΪ�ֶκ�ÿ�γ��ȣ�CΪϵ������

pCount = size(P, 1);    % ������
n = pCount - 1;         % ��Ӧ�����е�����±�ֵ

% �����ҳ�����Ϊ��ʼֵ������������������
chordLength = zeros(1, pCount - 1);
for i = 1:pCount - 1
    chordLength(i) = norm(P(i + 1, 1:3) - P(i, 1:3));
end

L = zeros(1, pCount - 1);
iterErr = 0.1;
iteNum = 0;
while abs(sum(L) - sum(chordLength)) > iterErr

    if iteNum > 0
        chordLength = L;
    end
    % ��������������ʱ�õ���ϵ������
    N = zeros(n + 1, n + 1);    
    for i = 2:n
        N(i, i - 1) = chordLength(i - 1) / 6;
        N(i, i) = (chordLength(i - 1) + chordLength(i)) / 3;
        N(i, i + 1) = chordLength(i) / 6;
    end
    N(1, 1) = chordLength(1) / 3;
    N(1, 2) = chordLength(1) / 6;
    N(n + 1, n) = chordLength(n) / 6;
    N(n + 1, n + 1) = chordLength(n) / 3;

    % ��Ⱥ��ұ�
    t1 = 4*P(2, 1:3) - P(3, 1:3) - 3*P(1, 1:3);
    p1u = t1 / norm(t1);

    tnp1 = 3*P(n + 1, 1:3) + P(n - 1, 1:3) - 4*P(n, 1:3);
    pnp1u = tnp1 / norm(tnp1);

    b = zeros(n + 1, 3);
    b(1, :) = (P(2, 1:3) - P(1, 1:3)) / chordLength(1) - p1u;
    b(n + 1, :) = pnp1u - (P(n + 1, 1:3) - P(n, 1:3)) / chordLength(n);
    for i = 2:n
        b(i, :) = (P(i + 1, 1:3) - P(i, 1:3)) / chordLength(i)...
                    - (P(i, 1:3) - P(i - 1, 1:3)) / chordLength(i - 1);
    end

    puu = N \ b;    % ���õ����������ʸ

    cubicCoeff = zeros(4, 3, n);
    for i = 1:n
        cubicCoeff(1, :, i) = (puu(i + 1, :) - puu(i, :)) / (6 * chordLength(i));
        cubicCoeff(2, :, i) = puu(i, :) / 2;
        cubicCoeff(3, :, i) = (P(i + 1, 1:3) - P(i, 1:3)) / chordLength(i) - chordLength(i) *( puu(i + 1, :) + 2*puu(i, :)) / 6;
        cubicCoeff(4, :, i) = P(i, 1:3);
    end

    % ��ó�ʼ��p, pu, puu
    for i = 1:n
        pi(i, :) = P(i, 1:3);
        pui(i, :) = cubicCoeff(3, :, i) / norm(cubicCoeff(3, :, i));
        puui(i, :) = 2 * cubicCoeff(2, :, i);
    end
    pi(n + 1, :) = P(n + 1, 1:3);

    putemp = 3 * cubicCoeff(1, :, n) * chordLength(i)^2 + 2 * cubicCoeff(2, :, n) * chordLength(i) + cubicCoeff(3, :, n);
    puutemp = 6 * cubicCoeff(1, :, n) * chordLength(i) + 2 * cubicCoeff(2, :, n);

    % ����Feisig�����з����Ľ�
    pui(n + 1, :) = putemp / norm(putemp);
    puui(n + 1, :) = (dot(putemp,  putemp) * puutemp - dot(putemp, puutemp) * putemp) / dot(putemp, putemp)^2;

    % ��ζ���ʽ���Li����Ҫ�õ���ϵ��
    EquationCoef = zeros(n, 5);
    L = zeros(1, n);    % ÿ�γ��ȣ�������ţ�ٵ�����������
    C = zeros(6, 3, n);
    for i = 1:n
        c1 = pi(i + 1, :) - pi(i, :);
        c2 = pui(i + 1, :) + pui(i, :);
        c3 = puui(i + 1, :) - puui(i, :);

        % ����F-C Wang�����е�ʽ(20)���ϵ��
        EquationCoef(i, 1) = dot(c3, c3);
        EquationCoef(i, 2) = -28 * dot(c3, c2);
        EquationCoef(i, 3) = 196 * dot(c2, c2) + 120 * dot(c1, c3) - 1024;
        EquationCoef(i, 4) = -1680 * dot(c1, c2);
        EquationCoef(i, 5) = 3600 * dot(c1, c1);

        % ���ҳ�Ϊ��ʼֵ������ţ�ٵ��������Li����Wang�����е�ʽ��16��
        L(i) = newtonIterativeSolveEquation(EquationCoef(i, :), chordLength(i));
        
        C(1, :, i) = pi(i, :);
        C(2, :, i) = pui(i, :);
        C(3, :, i) = puui(i, :) / 2;
        C(4, :, i) = 10 * (pi(i + 1, :) - pi(i, :)) / L(i)^3 - 2 * (2 * pui(i + 1, :) + 3 * pui(i, :)) / L(i)^2 + (puui(i + 1, :) - 3*puui(i, :)) / (2 * L(i));
        C(5, :, i) = -15 * (pi(i + 1, :) - pi(i, :)) / L(i)^4 + (7 * pui(i + 1, :) + 8 * pui(i, :)) / L(i)^3 - (2*puui(i + 1, :) - 3*puui(i, :)) / (2 * L(i)^2);
        C(6, :, i) = 6 * (pi(i + 1, :) - pi(i, :)) / L(i)^5 - 3 * c2 / L(i)^4 + c3 / (2 * L(i) ^ 3);
    end
    iteNum = iteNum + 1;
end

% for i = 1:n
%     C(1, :, i) = pi(i, :);
%     C(2, :, i) = pui(i, :);
%     C(3, :, i) = puui(i, :) / 2;
%     C(4, :, i) = 10 * (pi(i + 1, :) - pi(i, :)) / L(i)^3 - 2 * (2 * pui(i + 1, :) + 3 * pui(i, :)) / L(i)^2 + (puui(i + 1, :) - 3*puui(i, :)) / (2 * L(i));
%     C(5, :, i) = -15 * (pi(i + 1, :) - pi(i, :)) / L(i)^4 + (7 * pui(i + 1, :) + 8 * pui(i, :)) / L(i)^3 - (2*puui(i + 1, :) - 3*puui(i, :)) / (2 * L(i)^2);
%     C(6, :, i) = 6 * (pi(i + 1, :) - pi(i, :)) / L(i)^5 - 3 * c2 / L(i)^4 + c3 / (2 * L(i) ^ 3);
% end

% %% ***********************  ����Ϊ������  *****************************%% 
% pNum = 1;
% quiNum = 1;
% for i = 1:n
% %     for u = 0:0.01:chordLength(i)
% %         cubicSplineP(pNum, :) = cubicCoeff(1, :, i) * u^3 + cubicCoeff(2, :, i) * u^2 + cubicCoeff(3, :, i) * u + cubicCoeff(4, :, i);
% % %         cubicSplinePu(pNum, :) = 3 * cubicCoeff(1, :, i) * u^2 + 2 * cubicCoeff(2, :, i) * u + cubicCoeff(3, :, i);
% % %         cubicSplinePuu(pNum, :) = 6 * cubicCoeff(1, :, i) * u + 2 * cubicCoeff(2, :, i);
% %         pNum = pNum + 1;
% %     end
%     
%     for u = 0:0.01:L(i)
%         quinticSplineP(quiNum, :) = C(1, :, i) + C(2, :, i) * u + C(3, :, i) * u^2 + C(4, :, i) * u^3 + C(5, :, i) * u^4 + C(6, :, i) * u^5;
%         quiNum = quiNum + 1;
%     end
% end
% 
% 
% figure(1);
% % plot3(cubicSplineP(:, 1), cubicSplineP(:, 2), cubicSplineP(:, 3), 'r');
% 
% plot3(P(:, 1), P(:, 2), P(:, 3), '*');
% hold on;
% plot3(quinticSplineP(:, 1), quinticSplineP(:, 2), quinticSplineP(:, 3), 'b');



