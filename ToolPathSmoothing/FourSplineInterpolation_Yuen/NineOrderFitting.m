function [polyFittingCoeff, startL, Length] = NineOrderFitting(startIndex, endIndex)
% �Ե��ν��оŽ׶���ʽ���

global UL;      % ���еĴ���ϵ�


startL = UL(startIndex, 2);
Length = UL(endIndex, 2) - UL(startIndex, 2);
ulData = UL(startIndex : endIndex, :);

ulNorm(:, 1) = ulData(:, 1);
ulNorm(:, 2) = (ulData(:, 2) - startL) / Length;

% ��ϵ�����󣬼���
basisFunMat = zeros(endIndex - startIndex + 1, 10);
for col = 1:10
    basisFunMat(:, col) = ulNorm(:, 2).^ (10 - col);
end

% �߽�������ϵ������ ��
omega = [0 0 0 0 0 0 0 0 0 1;
         0 0 0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 2 0 0;
         0 0 0 0 0 0 6 0 0 0;
         1 1 1 1 1 1 1 1 1 1;
         9 8 7 6 5 4 3 2 1 0;
         72 56 42 30 20 12 6 2 0 0;
         504 336 210 120 60 24 6 0 0 0];

% �߽����� ��
eta = zeros(8, 1);
eta(1) = UL(startIndex, 1);     % ���ڷֶ���ϣ��˴�Ӧ���Ƕ�Ӧ��ʼ�㴦��u
eta(2:4) = CaculateuDerls(UL(startIndex, 1));   % ���ul(ustart),ull(ustart),ulll(ustart)
eta(2) = eta(2) * Length;
eta(3) = eta(3) * Length^2;
eta(4) = eta(4) * Length^3;
eta(5) = UL(endIndex, 1);       % ����յ㴦��uEnd
eta(6:8) = CaculateuDerls(UL(endIndex, 1));   % ���ul(uEnd),ull(uEnd),ulll(uEnd)

eta(6) = eta(6) * Length;
eta(7) = eta(7) * Length^2;
eta(8) = eta(8) * Length^3;

b = zeros(18, 1);

b(1:10) = basisFunMat' * ulData(:, 1);  % ��'u* 
b(11:18) = eta; % ��

A = zeros(18, 18);

A(1:10, 1:10) = basisFunMat' * basisFunMat; % ��'��
A(1:10, 11:18) = omega';    %  ����
A(11:18, 1:10) = omega;     %  ��

X = A \ b;

polyFittingCoeff = X(1:10)';