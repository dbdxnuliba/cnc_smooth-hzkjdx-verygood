function q = QuiticSplineDer(d1, d2, d3, d4, d5, d6, L, v)
% �þ���Ϊ4�׵��е��ֹ�ʽ���������Bezier�ĵ���

delta = 0.005;
qm1 = QuinticSphericalBezier(d1, d2, d3, d4, d5, d6, L, v - delta * L);
qp1 = QuinticSphericalBezier(d1, d2, d3, d4, d5, d6, L, v + delta * L);
qm2 = QuinticSphericalBezier(d1, d2, d3, d4, d5, d6, L, v - 2 * delta * L);
qp2 = QuinticSphericalBezier(d1, d2, d3, d4, d5, d6, L, v + 2 * delta * L);

q = (-qp2 + 8 * qp1 - 8 * qm1 + qm2) / (12 * delta * L);