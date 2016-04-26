function [L, C, V, D, u, h] = threesplineinterp(pathData)

% ���е���λ�õ���׶���ʽ���
[L, C] = positionQuinticSplineFitting(pathData);

% ���е���ʸ����׶���ʽ���
[V, D] = orientationSplineFitting(pathData);

% ���²�����
[u, h] = OrientationReparameterization(D, L);