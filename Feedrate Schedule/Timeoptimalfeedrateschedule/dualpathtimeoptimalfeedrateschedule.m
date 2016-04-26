function dualpathtimeoptimalfeedrate = dualpathtimeoptimalfeedrateschedule(constraints, dualquatpaht, interpolationperiod, machinetype)
% ����ICIRA�����е�ʱ�����ŷ����滮�ٶ�
% ���룺constraints����Լ��ֵ��dualquatpaht��ż��Ԫ����·��interpolationperiod�岹���ڣ�machinetype�������͡�

% feedratespline �滮�õ�����Ϻ���ٶ�����
% velolimitline �ٶȼ�ֵ����

Ts = interpolationperiod;				% �岹����

chorderror = constraints.settings.geoconstr;	% �������

% ������ٶȣ����ٶȺ�Ծ��Լ��
F = constraints.settings.dynconstr.maxvelo;
At = constraints.settings.dynconstr.maxacce;
Jt = constraints.settings.dynconstr.maxjerk;

% �����ٶȣ����ٶȺ�Ծ��Լ��
Av = constraints.settings.driconstr.A.maxvelo;
Aa = constraints.settings.driconstr.A.maxacce;
Aj = constraints.settings.driconstr.A.maxjerk;

Cv = constraints.settings.driconstr.C.maxvelo;
Ca = constraints.settings.driconstr.C.maxacce;
Cj = constraints.settings.driconstr.C.maxjerk;

Xv = constraints.settings.driconstr.X.maxvelo;
Xa = constraints.settings.driconstr.X.maxacce;
Xj = constraints.settings.driconstr.X.maxjerk;

Yv = constraints.settings.driconstr.Y.maxvelo;
Ya = constraints.settings.driconstr.Y.maxacce;
Yj = constraints.settings.driconstr.Y.maxjerk;

Zv = constraints.settings.driconstr.Z.maxvelo;
Za = constraints.settings.driconstr.Z.maxacce;
Zj = constraints.settings.driconstr.Z.maxjerk;

pointnum = 1200;		% �����������
du = 1 / pointnum;  	% �������
samplenum = 1;

% ��ȡ0λ
tip0 = dualquatpaht.tip0;
vector0 = dualquatpaht.vector0;

pathdeboorarr = zeros(4, 6, length(0:du:1));  % ����������㴦��·�ϵĵ��Լ�һ���׵�ʸ
interpcor = zeros(length(0:du:1), 6);

for u = 0:du:1
	% ���㵶��������һ���׵�ʸ
    deboordualquat = DeBoorCoxNurbsCal(u, dualquatpaht.dualquatspline, 3);
	pathders = DerCalFromQ(tip0, vector0, deboordualquat, 3);
	
	pathdeboorarr(:, :, samplenum) = pathders;
	
    interpcor(samplenum, :) = pathdeboorarr(1, :, samplenum);
    
    % ���ݻ�������ѡ��ͬ�����˶�ѧ����
    if machinetype == 1
        % ˫ת̨
        mcr = machinecoordinatecaltabletilting(pathders, 3, samplenum);
    elseif machinetype == 2
        % ˫��ͷ
        mcr = machinecoordinatecal(pathders, 3, samplenum);
    end
    
	A(samplenum) = mcr(1, 1); C(samplenum) = mcr(1, 2); X(samplenum) = mcr(1, 3); Y(samplenum) = mcr(1, 4); Z(samplenum) = mcr(1, 5);
	Au(samplenum) = mcr(2, 1); Cu(samplenum) = mcr(2, 2); Xu(samplenum) = mcr(2, 3); Yu(samplenum) = mcr(2, 4); Zu(samplenum) = mcr(2, 5);
	Auu(samplenum) = mcr(3, 1); Cuu(samplenum) = mcr(3, 2); Xuu(samplenum) = mcr(3, 3); Yuu(samplenum) = mcr(3, 4); Zuu(samplenum) = mcr(3, 5);
    Auuu(samplenum) = mcr(4, 1); Cuuu(samplenum) = mcr(4, 2); Xuuu(samplenum) = mcr(4, 3); Yuuu(samplenum) = mcr(4, 4); Zuuu(samplenum) = mcr(4, 5);
    
	% ������
	curvature = (norm(pathders(2, 1:3))) ^ 3 / norm(cross(pathders(2, 1:3), pathders(3, 1:3)));
	
	vcf(samplenum) = 2 * sqrt(2 * curvature * chorderror) / Ts;	% ���������ٶȵ�Լ��
	vpf(samplenum) = F;										% ������ٶ�Լ��
	vtfA(samplenum) = norm(pathders(2, 1:3)) * Av / abs(Au(samplenum));	% A������ٶ�Լ�����ƵĽ����ٶ�
	vtfC(samplenum) = norm(pathders(2, 1:3)) * Cv / abs(Cu(samplenum));	% C������ٶ�Լ�����ƵĽ����ٶ�
    vtfX(samplenum) = norm(pathders(2, 1:3)) * Xv / abs(Xu(samplenum));	% X������ٶ�Լ�����ƵĽ����ٶ�
    vtfY(samplenum) = norm(pathders(2, 1:3)) * Yv / abs(Yu(samplenum));	% Y������ٶ�Լ�����ƵĽ����ٶ�
    vtfZ(samplenum) = norm(pathders(2, 1:3)) * Zv / abs(Zu(samplenum));	% Z������ٶ�Լ�����ƵĽ����ٶ�

	% ����Сֵ
	vub(samplenum) = min([vcf(samplenum), vpf(samplenum), vtfA(samplenum), vtfC(samplenum), vtfX(samplenum), vtfY(samplenum), vtfZ(samplenum)]);
	
    % ���ٶȼ�ֵ���߱����������ڲ鿴�����ʹ�á�
    velolimtline(samplenum, 1) = u;
    velolimtline(samplenum, 2) = vub(samplenum);
    
	samplenum = samplenum + 1;
end

constrnum = 26;
Amat = zeros(constrnum * (samplenum - 4) + 28, samplenum - 3);  % ����ʽԼ�� Ax < b
b = zeros(constrnum * (samplenum - 4) + 28, 1);
c = -ones(samplenum - 3, 1);    % Ŀ�꺯�� c1 * x1 + c2 * x2 + ... + cn * xn;

axisacclimit = [Aa, Ca, Xa, Ya, Za]';

for i = 2:samplenum - 3
    pudotpuu = dot(pathdeboorarr(2, 1:3, i), pathdeboorarr(3, 1:3, i));
    pu2 = (norm(pathdeboorarr(2, 1:3, i)))^2;
    
    % �����������ٶ�Լ��
	Amat(constrnum * (i - 2) + 1, i - 1 : i) = [-1, 1];
	Amat(constrnum * (i - 2) + 2, i - 1 : i) = [1, -1];
	b(constrnum * (i - 2) + 1 : constrnum * (i - 2) + 2) = 2 * At * norm(pathdeboorarr(2, 1:3, i)) ^ 2 * du;
	
    % �ٶ��ۺ�Լ��
	Amat(constrnum * (i - 2) + 3, i - 1) = 1;
	b(constrnum * (i - 2) + 3) = (vub(i))^2;
	
	Qu = [Au(i), Cu(i), Xu(i), Yu(i), Zu(i)]';
	Quu = [Auu(i), Cuu(i), Xuu(i), Yuu(i), Zuu(i)]';

	
	Amat(constrnum * (i - 2) + 4 : constrnum * (i - 2) + 8, i - 1 : i) = [(2 * Quu * du - Qu * (2 * pudotpuu * du / pu2 + 1)), Qu];
	Amat(constrnum * (i - 2) + 9 : constrnum * (i - 2) + 13, i - 1 : i) = -[(2 * Quu * du - Qu * (2 * pudotpuu * du / pu2 + 1)), Qu];
	b(constrnum * (i - 2) + 4 : constrnum * (i - 2) + 8) = 2 * axisacclimit * pu2 * du;
	b(constrnum * (i - 2) + 9 : constrnum * (i - 2) + 13) = 2 * axisacclimit * pu2 * du;
    
    % �ٶ�ƽ���Ǹ�Լ��
    Amat(constrnum * (i - 2) + 14, i) = -1;
    b(constrnum * (i - 2) + 14) = 0;
    
    if constrnum > 14
        Quuu = [Auuu(i), Cuuu(i), Xuuu(i), Yuuu(i), Zuuu(i)]';
        du3ds = -((norm(pathdeboorarr(3, 1:3, i)) ^ 2 + dot(pathdeboorarr(2, 1:3, i), pathdeboorarr(4, 1:3, i))) * norm(pathdeboorarr(2, 1:3, i))...
                - 4 * pudotpuu ^ 2) / (norm(pathdeboorarr(2, 1:3, i)))^7;

        k1 = Quuu / norm(pathdeboorarr(2, 1:3, i)) ^ 3 - 3 * Quu * pudotpuu / norm(pathdeboorarr(2, 1:3, i)) ^ 5 + Qu * du3ds;
        k2 = (Quu / pu2 - Qu * pudotpuu / pu2 ^ 2) * 3 / 2 / norm(pathdeboorarr(2, 1:3, i)) / du;
        k3 = Qu / 2 / pu2 / du ^ 2;

        axisjerklimit = [Aj, Cj, Xj, Yj, Zj]';

        c1 = (k1 - k2 - k3 * (1 / norm(pathdeboorarr(2, 1:3, i)) + 1 / norm(pathdeboorarr(2, 1:3, i - 1))));
        c2 = (k2 + k3 / norm(pathdeboorarr(2, 1:3, i)));

        if i == 2
            % �ڶ��㴦����Ծ��Լ��
            Amat(constrnum * (i - 2) + 15 : constrnum * (i - 2) + 19, i - 1 : i) = [c1, c2];
            Amat(constrnum * (i - 2) + 20 : constrnum * (i - 2) + 24, i - 1 : i) = -[c1, c2];
            % �ڶ��㴦�����Ծ��Լ��
            Amat(constrnum * (i - 2) + 25, i - 1 : i ) = [1 / norm(pathdeboorarr(2, 1:3, i - 1)), -(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i)))];
            Amat(constrnum * (i - 2) + 26, i - 1 : i) = -[1 / norm(pathdeboorarr(2, 1:3, i - 1)), -(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i)))];
        elseif i == samplenum - 3
            % �����ڶ��㴦����Ծ��Լ��
            Amat(constrnum * (i - 2) + 15 : constrnum * (i - 2) + 19, end - 1 : end) = [k3 / norm(pathdeboorarr(2, 1:3, i - 1)), c1];
            Amat(constrnum * (i - 2) + 20 : constrnum * (i - 2) + 24, end - 1 : end) = -[k3 / norm(pathdeboorarr(2, 1:3, i - 1)), c1];
            % �����ڶ��㴦�����Ծ��Լ��
            Amat(constrnum * (i - 2) + 25, end - 1 : end) = [-(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))), 1 / norm(pathdeboorarr(2, 1:3, i))];
            Amat(constrnum * (i - 2) + 26, end - 1 : end) = -[-(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))), 1 / norm(pathdeboorarr(2, 1:3, i))];
        else
            Amat(constrnum * (i - 2) + 15 : constrnum * (i - 2) + 19, i - 2 : i) = [k3 / norm(pathdeboorarr(2, 1:3, i - 1)), c1, c2];
            Amat(constrnum * (i - 2) + 20 : constrnum * (i - 2) + 24, i - 2 : i) = -[k3 / norm(pathdeboorarr(2, 1:3, i - 1)), c1, c2];

            Amat(constrnum * (i - 2) + 25, i - 2 : i) = [1 / norm(pathdeboorarr(2, 1:3, i - 1)), -(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))), 1 / norm(pathdeboorarr(2, 1:3, i))];
            Amat(constrnum * (i - 2) + 26, i - 2 : i) = -[1 / norm(pathdeboorarr(2, 1:3, i - 1)), -(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))), 1 / norm(pathdeboorarr(2, 1:3, i))];
        end
        b(constrnum * (i - 2) + 15 : constrnum * (i - 2) + 19) = axisjerklimit / vub(i);
        b(constrnum * (i - 2) + 20 : constrnum * (i - 2) + 24) = axisjerklimit / vub(i);
        b(constrnum * (i - 2) + 25 : constrnum * (i - 2) + 26) = 2 * Jt * norm(pathdeboorarr(2, 1:3, i)) * du ^2 / vub(i);
    end
end

% ��������Ե�һ�㼴 u = 0������v = 0,��������ﵥ����Լ������
Amat(constrnum * (i - 1) + 1, 1) = -1;
Amat(constrnum * (i - 1) + 2, 1) = 1;
b(constrnum * (i - 1) + 1:constrnum * (i - 1) + 2) = 2 * At * norm(pathdeboorarr( 2, 1:3, 1)) ^ 2 * du;

Amat(constrnum * (i - 1) + 3, 1) = 1;
b(constrnum * (i - 1) + 3) = (vub(1))^2;

Qu = [Au(1), Cu(1), Xu(1), Yu(1), Zu(1)]';

Amat(constrnum * (i - 1) + 4 : constrnum * (i - 1) + 8, 1) = Qu;
Amat(constrnum * (i - 1) + 9 : constrnum * (i - 1) + 13, 1) = -Qu;
b(constrnum * (i - 1) + 4 : constrnum * (i - 1) + 8) = 2 * axisacclimit * norm(pathdeboorarr( 2, 1:3, 1)) ^ 2 * du;
b(constrnum * (i - 1) + 9 : constrnum * (i - 1) + 13) = 2 * axisacclimit * norm(pathdeboorarr( 2, 1:3, 1)) ^ 2 * du;
	
Amat(constrnum * (i - 1) + 14, 1) = -1;
b(constrnum * (i - 1) + 14) = 0;

% ���һ���Լ������

pudotpuu = dot(pathdeboorarr(2, 1:3, i + 1), pathdeboorarr(3, 1:3, i + 1));
pu2 = (norm(pathdeboorarr(2, 1:3, i + 1)))^2;

Amat(constrnum * (i - 1) + 15, end) = 1;
Amat(constrnum * (i - 1) + 16, end) = -1;
b(constrnum * (i - 1) + 15 : constrnum * (i - 1) + 16) = 2 * At * norm(pathdeboorarr(2, 1:3, end - 1)) ^ 2 * du;

Amat(constrnum * (i - 1) + 17, end) = 1;
b(constrnum * (i - 1) + 17) = (vub(end - 1))^2;

Qu = [Au(end), Cu(end), Xu(end), Yu(end), Zu(end)]';
Quu = [Auu(end), Cuu(end), Xuu(end), Yuu(end), Zuu(end)]';

Amat(constrnum * (i - 1) + 18 : constrnum * (i - 1) + 22, end) = (2 * Quu * du - Qu * (2 * pudotpuu * du / pu2 + 1));
Amat(constrnum * (i - 1) + 23 : constrnum * (i - 1) + 27, end) = -(2 * Quu * du - Qu * (2 * pudotpuu * du / pu2 + 1));
b(constrnum * (i - 1) + 18 : constrnum * (i - 1) + 22) = 2 * axisacclimit * norm(pathdeboorarr( 2, 1:3, 1)) ^ 2 * du;
b(constrnum * (i - 1) + 23 : constrnum * (i - 1) + 27) = 2 * axisacclimit * norm(pathdeboorarr( 2, 1:3, 1)) ^ 2 * du;

Amat(constrnum * (i - 1) + 28, end) = -1;
b(constrnum * (i - 1) + 28) = 0;

vsq = linprog(c, Amat, b);  % �����Ż����
vsq = abs(vsq);
vsq1 = zeros(length(vsq) + 2, 1);
vsq1(2:end - 1) = vsq;

[feedratecontrolp, feedrateknotvector] = feedratesmooth2(sqrt(vsq1), 0:du:1,3, 80); % �Թ滮�õ�����ɢ��������
% ������Ͻ��
bsplinefeedrate.controlp = feedratecontrolp;
bsplinefeedrate.knotvector = feedrateknotvector;
bsplinefeedrate.splineorder = 3;

% Ԥ�����ڴ棬��������������ٶ�
VA = zeros(samplenum - 1, 1);
VC = zeros(samplenum - 1, 1);
VX = zeros(samplenum - 1, 1);
VY = zeros(samplenum - 1, 1);
VZ = zeros(samplenum - 1, 1);

tipA = zeros(samplenum - 2, 1);
AA = zeros(samplenum - 2, 1);
CA = zeros(samplenum - 2, 1);
XA = zeros(samplenum - 2, 1);
YA = zeros(samplenum - 2, 1);
ZA = zeros(samplenum - 2, 1);

tipJ = zeros(samplenum - 3, 1);
JA = zeros(samplenum - 3, 1);
JC = zeros(samplenum - 3, 1);
JX = zeros(samplenum - 3, 1);
JY = zeros(samplenum - 3, 1);
JZ = zeros(samplenum - 3, 1);



% ��ɢ����滮�ļ��ٶȡ�Ծ�ȵ�ֵ��
for i = 1:samplenum - 1

    punorm = norm(pathdeboorarr(2, 1:3, i));
    pudotpuu = dot(pathdeboorarr(2, 1:3, i), pathdeboorarr(3, 1:3, i));
    pu2 = (norm(pathdeboorarr(2, 1:3, i)))^2;

    Qu = [Au(i), Cu(i), Xu(i), Yu(i), Zu(i)]';
    Quu = [Auu(i), Cuu(i), Xuu(i), Yuu(i), Zuu(i)]';

    VA(i) = Au(i) * sqrt(vsq1(i)) / punorm;
    VC(i) = Cu(i) * sqrt(vsq1(i)) / punorm;
    VX(i) = Xu(i) * sqrt(vsq1(i)) / punorm;
    VY(i) = Yu(i) * sqrt(vsq1(i)) / punorm;
    VZ(i) = Zu(i) * sqrt(vsq1(i)) / punorm;

    if i < samplenum - 1
        tipA(i) = (vsq1(i + 1) - vsq1(i)) / (2 * norm(pathdeboorarr(2, 1:3, i)) * du);
        AA(i) = Au(i) * vsq1(i + 1) / (2 * pu2 * du) + (Auu(i) / pu2 - Au(i) * (pudotpuu / pu2 + 1 / 2 / du) / pu2) * vsq1(i);
        CA(i) = Cu(i) * vsq1(i + 1) / (2 * pu2 * du) + (Cuu(i) / pu2 - Cu(i) * (pudotpuu / pu2 + 1 / 2 / du) / pu2) * vsq1(i);
        XA(i) = Xu(i) * vsq1(i + 1) / (2 * pu2 * du) + (Xuu(i) / pu2 - Xu(i) * (pudotpuu / pu2 + 1 / 2 / du) / pu2) * vsq1(i);
        YA(i) = Yu(i) * vsq1(i + 1) / (2 * pu2 * du) + (Yuu(i) / pu2 - Yu(i) * (pudotpuu / pu2 + 1 / 2 / du) / pu2) * vsq1(i);
        ZA(i) = Zu(i) * vsq1(i + 1) / (2 * pu2 * du) + (Zuu(i) / pu2 - Zu(i) * (pudotpuu / pu2 + 1 / 2 / du) / pu2) * vsq1(i);

        if i > 1

%             tipJ(i - 1) = [-(1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))), 1 / norm(pathdeboorarr(2, 1:3, i))].* [vsq1(i - 1), vsq1(i), vsq1(i + 1)] * sqrt(vsq1(i)) / 2 / norm(pathdeboorarr(2, 1:3, i)) / du ^2;
            tipJ(i - 1) = (vsq1(i - 1) / norm(pathdeboorarr(2, 1:3, i - 1)) - vsq1(i) * (1 / norm(pathdeboorarr(2, 1:3, i - 1)) + 1 / norm(pathdeboorarr(2, 1:3, i))) + vsq1(i + 1) / norm(pathdeboorarr(2, 1:3, i))) * sqrt(vsq1(i)) / 2 / norm(pathdeboorarr(2, 1:3, i)) / du ^2;
            Quuu = [Auuu(i), Cuuu(i), Xuuu(i), Yuuu(i), Zuuu(i)]';
            du3ds = -((norm(pathdeboorarr(3, 1:3, i)) ^ 2 + dot(pathdeboorarr(2, 1:3, i), pathdeboorarr(4, 1:3, i))) * norm(pathdeboorarr(2, 1:3, i))...
                    - 4 * pudotpuu ^ 2) / (norm(pathdeboorarr(2, 1:3, i)))^7;

            k1 = Quuu / norm(pathdeboorarr(2, 1:3, i)) ^ 3 - 3 * Quu * pudotpuu / norm(pathdeboorarr(2, 1:3, i)) ^ 5 + Qu * du3ds;
            k2 = (Quu / pu2 - Qu * pudotpuu / pu2 ^ 2) * 3 / 2 / norm(pathdeboorarr(2, 1:3, i)) / du;
            k3 = Qu / 2 / pu2 / du ^ 2;

            c1 = (k1 - k2 - k3 * (1 / norm(pathdeboorarr(2, 1:3, i)) + 1 / norm(pathdeboorarr(2, 1:3, i - 1))));
            c2 = (k2 + k3 / norm(pathdeboorarr(2, 1:3, i)));

            Jaxis = (vsq1(i - 1) * k3 / norm(pathdeboorarr(2, 1:3, i - 1)) + c1 * vsq1(i) + c2 * vsq1(i + 1)) * sqrt(vsq1(i));
            JA(i - 1) = Jaxis(1);
            JC(i - 1) = Jaxis(2);
            JX(i - 1) = Jaxis(3);
            JY(i - 1) = Jaxis(4);
            JZ(i - 1) = Jaxis(5);
        end
    end
end
    
% ���浽Ҫ����Ľ����
dualpathtimeoptimalfeedrate.feedratespline = bsplinefeedrate;
dualpathtimeoptimalfeedrate.scheduledresult.u = velolimtline(:, 1);
dualpathtimeoptimalfeedrate.scheduledresult.velolimtline = velolimtline(:, 2);

dualpathtimeoptimalfeedrate.scheduledresult.VA = VA;
dualpathtimeoptimalfeedrate.scheduledresult.VC = VC;
dualpathtimeoptimalfeedrate.scheduledresult.VX = VX;
dualpathtimeoptimalfeedrate.scheduledresult.VY = VY;
dualpathtimeoptimalfeedrate.scheduledresult.VZ = VZ;

dualpathtimeoptimalfeedrate.scheduledresult.tipA = tipA;
dualpathtimeoptimalfeedrate.scheduledresult.AA = AA;
dualpathtimeoptimalfeedrate.scheduledresult.AC = CA;
dualpathtimeoptimalfeedrate.scheduledresult.AX = XA;
dualpathtimeoptimalfeedrate.scheduledresult.AY = YA;
dualpathtimeoptimalfeedrate.scheduledresult.AZ = ZA;

dualpathtimeoptimalfeedrate.scheduledresult.tipJ = tipJ;
dualpathtimeoptimalfeedrate.scheduledresult.JA = JA;
dualpathtimeoptimalfeedrate.scheduledresult.JC = JC;
dualpathtimeoptimalfeedrate.scheduledresult.JX = JX;
dualpathtimeoptimalfeedrate.scheduledresult.JY = JY;
dualpathtimeoptimalfeedrate.scheduledresult.JZ = JZ;

%% ���ƹ滮���
drawflag = 0;   % �Ƿ����ͼ��
if drawflag == 1
    % ������Щֻ������Ҫ����ͼ��ʱ�ż��㣬�Լӿ�����Ч��
    feedindex = 1;
    for u = 0:0.1*du:1
        feedp(feedindex) = DeBoorCoxNurbsCal(u, bsplinefeedrate, 0);

        feedindex = feedindex + 1;
    end

    vschedule = sqrt(vsq1);
    uvector = 0:du:1;

    uvector = uvector';
    vub = vub';


    drawtogether = 1;   % ������һ��ͼ�ϻ��Ƿֿ�����



    scrsz = get(0,'ScreenSize');
    % 
    fontsize = 15;
    fontsizelabel = fontsize;

    x = 50;
    y = 50;
    width = 720;
    height= 400;

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        figure('Position',[scrsz(3)/4 scrsz(4)/4 3 * scrsz(3)/5 2 * scrsz(3)/6]);
        subplot(2, 2, 1);     
    end
    plot3(interpcor(:, 1), interpcor(:, 2), interpcor(:, 3));
    rfp = interpcor(:, 1:3) + 30 * interpcor(:, 4:6);
    hold on;
    plot3(rfp(:, 1), rfp(:, 2), rfp(:, 3));
    for i = 1:size(interpcor, 1)
        if mod(i, 10) == 1
            plot3([interpcor(i, 1), rfp(i, 1)], [interpcor(i, 2), rfp(i, 2)], [interpcor(i, 3), rfp(i, 3)]);
        end
    end
    plot3([interpcor(end, 1), rfp(end, 1)], [interpcor(end, 2), rfp(end, 2)], [interpcor(end, 3), rfp(end, 3)]);
    set(gca, 'fontsize', fontsize);
    xlim([-50 120]);
    ylim([-150 40]);
    zlim([-50 50]);
    title('a', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(2, 2, 2);     
    end
    plot(0:0.1*du:1, feedp);hold on;
    plot(0:du:1, vub, 'r')
    % plot(vub, 'r');
    h1 = legend('Final feedrate curve', 'Vc');
    set(h1,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Velocity(mm/s)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
    ylim([0, max(feedp) * 1.3]);
    set(gca, 'ygrid', 'on', 'ytick', F);
    title('b', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(2, 2, 3);     
    end
    plot(0:du:1 - du, tipA);
    set(gca, 'fontsize', fontsize);
    ylabel('Acceleration(mm/s^2)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
    ylim([-At * 1.2, At * 1.5]);
    set(gca, 'ygrid', 'on', 'ytick', [-At, At]);
    title('c', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(2, 2, 4);     
    end
    plot(du:du:1 - du, tipJ);
    set(gca, 'fontsize', fontsize);
    ylabel('Jerk(mm/s^3)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
    ylim([-Jt * 1.2, Jt * 1.5]);
    set(gca, 'ygrid', 'on', 'ytick', [-Jt, Jt]);
    title('d', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        figure('Position',[scrsz(3)/4 scrsz(4)/9 3 * scrsz(3)/5 3 * scrsz(3)/6]);
        subplot(3, 2, 1);     
    end
    plot(0:du:1, VA); 
    hold on
    plot(0:du:1, VC, 'r');
    % title('AC���ٶ�');
    h2 = legend('A axis', 'C axis');
    set(h2,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Velocity(rad/s)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Vra * 1.2, Vra * 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Vra,Vra]);
    title('e', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(3, 2, 2);      
    end
    plot(0:du:1, VX);
    hold on;
    plot(0:du:1, VY, 'r');
    plot(0:du:1, VZ, 'g');
    h3 = legend('X axis', 'Y axis', 'Z axis');
    set(h3,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Velocity(mm/s)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Vta * 1.2, Vta* 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Vta, Vta]);
    title('f', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(3, 2, 3);      
    end
    plot(0:du:1 - du, AA); 
    hold on
    plot(0:du:1 - du, CA, 'r');
    % title('AC����ٶ�');
    h4 = legend('A axis', 'C axis');
    set(h4,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Velocity(rad/s^2)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Ara * 1.2, Ara * 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Ara, Ara]);
    title('g', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(3, 2, 4);      
    end
    plot(0:du:1 - du, XA);
    hold on;
    plot(0:du:1 - du, YA, 'r');
    plot(0:du:1 - du, ZA, 'g');
    % title('XYZ����ٶ�');
    h5 = legend('X axis', 'Y axis', 'Z axis');
    set(h5,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Velocity(mm/s^2)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Ata * 1.2, Ata * 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Ata, Ata]);
    title('h', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(3, 2, 5);      
    end
    plot((1:length(JA)) * du, JA, 'b');
    hold on;
    plot((1:length(JC)) * du, JC, 'r');
    h4 = legend('A axis', 'C axis');
    set(gca, 'fontsize', fontsize);
    set(h4,'Orientation','horizon', 'box', 'off');
    ylabel('Jerk(rad/s^3)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Jra * 1.2, Jra * 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Jra, Jra]);
    title('i', 'fontsize', fontsizelabel)

    if drawtogether == 0
        figure('Position',[x, y, width, height]);
    else
        subplot(3, 2, 6);      
    end
    plot((1:length(JX)) * du, JX, 'b');
    hold on;
    plot((1:length(JY)) * du, JY, 'r');
    plot((1:length(JZ)) * du, JZ, 'g');
    h5 = legend('X axis', 'Y axis', 'Z axis');
    set(h5,'Orientation','horizon', 'box', 'off');
    set(gca, 'fontsize', fontsize);
    ylabel('Jerk(rad/s^3)', 'fontsize', fontsizelabel);
    xlabel('Parameter u', 'fontsize', fontsizelabel);
    xlim([0, 1]);
%     ylim([-Jta * 1.2, Jta * 1.6]);
%     set(gca, 'ygrid', 'on', 'ytick', [-Jta, Jta]);
    title('j', 'fontsize', fontsizelabel)
end