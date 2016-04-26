function Y = OrientationObjectiveFunction(Q)

% ȫ�ֱ�������ʾ��N��������Ҫ�������

global Q1;
global Q2;
global Q3;
global Q4;
global Q5;
global Q6;
global wk_1;
global wk;

global LWData;
N = size(LWData, 1) - 1;

Y = 0;
% ��Ҫ��ÿ�����
for k = 1:N
    Q1 = Q((k - 1) * 6 + 1);
    Q2 = Q((k - 1) * 6 + 2);
    Q3 = Q((k - 1) * 6 + 3);
    Q4 = Q((k - 1) * 6 + 4);
    Q5 = Q((k - 1) * 6 + 5);
    Q6 = Q((k - 1) * 6 + 6);

    wk_1 = LWData(k, 2);
    wk = LWData(k + 1, 2);
    
    lk_1 = LWData(k, 1);
    lk = LWData(k + 1, 1);
    
   temp = integral(@wDer3Square, 0, 1);
   
   dlk = (lk - lk_1)^6;
    temp = temp / dlk;
    
    Y = Y + temp;
end