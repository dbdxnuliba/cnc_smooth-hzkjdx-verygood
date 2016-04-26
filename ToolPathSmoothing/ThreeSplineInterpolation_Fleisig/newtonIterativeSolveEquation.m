function L = newtonIterativeSolveEquation(C, L0)
% ����ţ�ٵ����������Ĵη��̣�����CΪϵ����L0Ϊ��ʼֵ

L1 = L0 - FourthOrderPolynomial(C, L0) / FourthOrderPolynomialDer(C, L0);
if abs(L1 - L0) < 0.00001
    L = L1;
else
    L = newtonIterativeSolveEquation(C, L1);
end
