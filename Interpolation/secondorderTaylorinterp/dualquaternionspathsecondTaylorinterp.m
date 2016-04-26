function interpresult = dualquaternionspathsecondTaylorinterp(dualpathtimeoptimalfeedrate, dualquatpaht, interpolationperiod, machinetype)
% ����ϵõ��Ķ�ż��Ԫ����ʽ�ĵ���·������̩�ն��׽��Ʋ岹����
% ���룺
%   dualpathtimeoptimalfeedrate������ʱ�������ٶȹ滮�����õ����ٶȹ滮���ߣ�B������ʽ
%   dualquatpaht����ϵõ��Ķ�ż��Ԫ����ʽ��·
%   interpolationperiod���岹����
%   machinetype����������
%
% �����interpresult�岹���

global interpolationPeriod;
interpolationPeriod = interpolationperiod;
Ts = interpolationperiod;
u = 0.0001;	% ��һ����u

lastf = 0;	% ��һ�ٶȞ�
lastf2 = 0;
lastA = 0;

% ����ż��Ԫ����·�е����ݶ�ȡ��ȥ������ʹ��
tip0 = dualquatpaht.tip0;
vector0 = dualquatpaht.vector0;
controlp = dualquatpaht.dualquatspline.controlp;
knotvector = dualquatpaht.dualquatspline.knotvector;
splineorder = dualquatpaht.dualquatspline.splineorder;

% �ȶ�ȡ��һ�����Ƶ�
deboordualq = dualquatpaht.dualquatspline.controlp(1, :);


lastp = DerCalFromQ(tip0, vector0, deboordualq, 0);

lastmcr2 = machinecoordinatecaltabletilting(lastp, 0, 1);
lastmcr = lastmcr2;

interpcor(1, :) = lastp;

stepnum = 1;


while u < 1
	f = DeBoorCoxNurbsCal(u, dualpathtimeoptimalfeedrate, 0);	% ���㵱ǰ��滮??f
	interpresult.schedulf(stepnum) = f;    % ����滮��fֵ
    
	deboordualq = DeBoorCoxNurbsCal(u, dualquatpaht.dualquatspline, 2);	% ���㵽����
	pathdeboor = DerCalFromQ(tip0, vector0, deboordualq, 2);
	
	if machinetype == 1
		mcr = machinecoordinatecaltabletilting(pathdeboor, 2, stepnum); % �����������
	elseif machinetype == 2
		mcr = machinecoordinatecal(pathdeboor, 2, stepnum); % �����������
    end
    % ����������Ϣ
	curvature(stepnum) = (norm(pathdeboor(2, 1:3))) ^ 3 / norm(cross(pathdeboor(2, 1:3), pathdeboor(3, 1:3)));
    
    mcrarr(stepnum, :) = mcr(1, :);             % ����λ��
    
    punorm = norm(pathdeboor(2, 1:3));
    pudotpuu = dot(pathdeboor(2, 1:3), pathdeboor(3, 1:3));
    pu2 = (norm(pathdeboor(2, 1:3)))^2;
    
    if stepnum > 1
        % ��ּ���滮���ٶ�
        lastA = (f - lastf) / Ts ;	
        schedulMA(stepnum, :) = (lastmcr(3, :) / pu2 - lastmcr(2, :)* dot(pathdeboor(2, 1:3), pathdeboor(3, 1:3)) / pu2^2) * f^2  + lastmcr(2, :) / punorm * lastA;
        
		% ����滮�ٶ�
        schedulMV(stepnum, :) = mcr(2, :) * f / norm(pathdeboor(2, 1:3));

        actualf(stepnum) = norm(pathdeboor(1, 1:3) - lastp) / Ts;	% ��ּ���ʵ���ٶ�
        actualMV(stepnum, :) = (mcr(1, :) - lastmcr(1, :)) / Ts;	% ��ּ������ʵ���ٶ�

        % ����ʵ�ʼ��ٶ�
		actualMA(stepnum - 1, :) = (actualMV(stepnum, :) - actualMV(stepnum - 1, :)) / Ts;
		actualA(stepnum - 1) = (actualf(stepnum) - actualf(stepnum - 1)) / Ts;
	
        % ����ʵ��Ծ��
        if stepnum > 2
            actualMJ(stepnum - 2, :) = (actualMA(stepnum - 1, :) - actualMA(stepnum - 2, :)) / Ts;
            actualJ(stepnum - 2) = (actualA(stepnum - 1) - actualA(stepnum - 2)) / Ts;
        end

		% ����岹����Ϣ
        interpcor(stepnum, 1:6) = pathdeboor(1, :);

        interpV(stepnum) = f;
        interpA(stepnum) = lastA;
    end
    
	lastf2 = lastf;
	lastf = f;	
	lastp = pathdeboor(1, 1:3);
    lastmcr2 = lastmcr;
    lastmcr = mcr;
    
	interpcor(stepnum, 9) = u;
    
    if u >=0.99965 
		break;
    end
	
	u = SecondTalorForInterp(u, f, lastA, pathdeboor, stepnum);	% ����̩�ն���չ��������һ������
	
	stepnum = stepnum + 1;	
end

interpresult.interpcor = interpcor;
interpresult.curvature = curvature;
interpresult.actualf = actualf;
interpresult.actualMV = actualMV;
interpresult.schedulMV = schedulMV;
interpresult.mcrarr = mcrarr;


% interpresult = 0;

clear interpolationPeriod