function [d1, d2, d3, d4, d5, d6] = QuinticSplineFitting(qi, qiP1, v0, v1, w0, w1, L0)
% һ�����ߵ���㡢�յ��Լ��������һ���׵�ʸ���Լ���ʼ�Ĵ˶γ�ʼ����

d1 = qi;
d6 = qiP1;

% ����Fleisig���ģ�A3�����d2
temp = L0 * norm(v0) / 5;
d2 = qi * cos(temp) + v0 * sin(temp);
d2 = d2 / norm(d2);

% ���գ�A4�����d5
temp = L0 * norm(v1) / 5;
d5 = qiP1 * cos(temp) - v1 * sin(temp);
d5 = d5 / norm(d5);

% ����ʽ(A8)��d5
sita = acos(dot(d1, d2));
B11dv0 = sita * (d2 - cos(sita) * d1) / sin(sita);
B41dv0 = 4 * B11dv0;

g = (cos(sita) * d2 - d1) / (sin(sita)^2) - B11dv0 / sita^2;
h = sin(sita) / (5 * sita) * (5 * sita^2 * d1 - L0^2 * w0) + g * dot(d2, B41dv0) - cos(sita) * B41dv0;

qb = dot(h, d2) / dot(g, d2) * g - h;
d3 = d2 * cos(norm(qb) / 4) + qb * sin(norm(qb) / 4) / norm(qb);
d3 = d3 / norm(d3);

% ����ʽ��A13����d4
sita = acos(dot(d5, d6));
B16dv1 = sita * (cos(sita) * d6 - d5) / sin(sita);
B46dv1 = 4 * B16dv1;

g = (d6 * cos(sita) - d5) / (sita * sin(sita)) - (d6 - cos(sita) * d5) / sin(sita)^2;
h = sin(sita) / 5 / sita * (L0^2 * w1 + 5 * sita^2 * d6) + g * dot(d5, B46dv1) - cos(sita) * B46dv1;

qb = dot(h, d5) / dot(g, d5) * g - h;
d4 = d5 * cos(norm(qb) / 4) - qb / norm(qb) * sin(norm(qb) / 4);
d4 = d4 / norm(d4);
    

