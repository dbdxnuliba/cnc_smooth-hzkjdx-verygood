function [ DeBoorP ] = DeBoorCoxNurbsCal(u, bslpine, derorder)
%����²�����
%   derorder = 0���򲻼��㵼ʸ��derorder = 1����������һ�׵�ʸ, derorder = 2���������Ͷ��׵�ʸ�� derorder = 3�������������׵�ʸ

% ����Ҫ�õ���ȫ�ֱ�����ʹ��ȫ�ֱ����������ݴ��ݴ���
global KnotVector;  % �ڵ�����
global CP;          % ���Ƶ�
global curveDegree; % ����
KnotVector = bslpine.knotvector;
CP = bslpine.controlp;
curveDegree = bslpine.splineorder;


n = size(CP, 1);
weightVector = ones(n, 1);  % ���ڱ�ʵ��ʹ�õ���B������Ȩ�ض�Ϊ1��ǰ�ڲο���ʦ��NURBS����д�ģ�����Ϊ��ͳһ����Ϊ�Ժ�����չ���˲��ֱ���

uIndex = findSpan(n, curveDegree, u, KnotVector);

% ϵ������
alfaMatrix = zeros(curveDegree, curveDegree);
alfaMatrixDer1 = zeros(curveDegree, curveDegree);
alfaMatrixDer2 = zeros(curveDegree, curveDegree);
alfaMatrixDer3 = zeros(curveDegree, curveDegree);

%% ������ֵ���ϵ������
for tempData = 0 : curveDegree - 1
    for tempData2 = 0 : tempData
        utemp =  (KnotVector(uIndex + tempData2 + 2) - KnotVector(uIndex - tempData + tempData2 + 1));
        
        if utemp == 0
            alfaMatrix(tempData2 + 1, tempData + 1) = 0;
        else
            alfaMatrix(tempData2 + 1, tempData + 1) = (u - KnotVector(uIndex - tempData + tempData2 + 1)) / utemp;
        end
    end
end

deBoorAu = DeBoorCoxCal(alfaMatrix, CP, uIndex);            % ������ֵ��
deBoorBu = DeBoorCoxCal(alfaMatrix, weightVector, uIndex);

if deBoorBu == 0
    KnotBoor = [0 0 0];
else
    KnotBoor = deBoorAu / deBoorBu;
end
DeBoorP(1, :) = KnotBoor;


if derorder >= 1
   % ����һ�׵�ʸ��Ҫ�õ���ϵ������
    for tempData = curveDegree - 1 : -1 : 1
        for tempData2 = tempData: - 1 : 1
            utemp = (KnotVector(uIndex + tempData2 + 1) - KnotVector(uIndex - tempData + tempData2 + 1));
            if utemp == 0
                alfaMatrixDer1(tempData2 + 1, tempData + 1) = 0;
            else
                alfaMatrixDer1(tempData2 + 1, tempData + 1) = (u - KnotVector(uIndex - tempData + tempData2 + 1)) / utemp;
            end
        end
    end
    deBoorDer1 = DeBoorCoxDer1Cal(alfaMatrixDer1, CP, uIndex);
    deBoorDer1Bu = DeBoorCoxDer1Cal(alfaMatrixDer1, weightVector, uIndex);
    
    if deBoorBu == 0
        KnotCoorDer1 = [0 0 0];
    else
        KnotCoorDer1 = (deBoorDer1 - deBoorDer1Bu * KnotBoor) / deBoorBu;
    end
    DeBoorP(2, :) = KnotCoorDer1;
  
    if derorder >= 2
        % ������׵�ʸ��Ҫ�õ���ϵ������
        for tempData = curveDegree - 1: -1 : 2
            for tempData2 = tempData : -1 : 2
                utemp = (KnotVector(uIndex + tempData2) - KnotVector(uIndex - tempData + tempData2 + 1));
                if utemp == 0
                    alfaMatrixDer2(tempData + 1, tempData + 1) = 0;
                else
                    alfaMatrixDer2(tempData + 1, tempData + 1) = (u - KnotVector(uIndex - tempData + tempData2 + 1)) / utemp;
                end
            end
        end

        deBoorDer2 = DeBoorCox2Cal(alfaMatrixDer2, CP, uIndex);
        deBoorDer2Bu = DeBoorCox2Cal(alfaMatrixDer2, weightVector, uIndex);

        if deBoorBu == 0
            KnotCoorDer2 = [0 0 0];
        else
            KnotCoorDer2 = (deBoorDer2 - 2 *deBoorDer1Bu * KnotCoorDer1 - deBoorDer2Bu * KnotBoor) / deBoorBu;
        end
        DeBoorP(3, :) = KnotCoorDer2;
        
        if derorder >= 3
            % ���������׵�ʸ��Ҫ�õ���ϵ������
            for tempData = curveDegree - 1: -1 : 3
                for tempData2 = tempData: -1 : 3
                    utemp = (KnotVector(uIndex + tempData2 - 1) - KnotVector(uIndex - tempData + tempData2 + 1));
                    if utemp == 0
                        alfaMatrixDer3(tempData + 1, tempData2 + 1) = 0;
                    else
                        alfaMatrixDer3(tempData + 1, tempData2 + 1) = (u - KnotVector(uIndex - tempData + tempData2 + 1)) / utemp;            
                    end
                end
            end
            
            deBoorDer3 = DeBoorCox3Cal(alfaMatrixDer3, CP, uIndex);
            deBoorDer3Bu = DeBoorCox3Cal(alfaMatrixDer3, weightVector, uIndex);

            DeBoorP(4, :) = deBoorDer3;
        end
    end
end

clear KnotVector  % �ڵ�����
clear CP          % ���Ƶ�
clear curveDegree % ����

