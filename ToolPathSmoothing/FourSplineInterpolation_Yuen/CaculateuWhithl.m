function u = CaculateuWhithl( l, X, startL, S)
%������XΪϵ���ľŽ׶���ʽl��Ӧ��uֵ

l = (l - startL) / S;   % �ȱ任��[0, 1]������
u = X(1) * (l.^9) + X(2)*(l.^8) + X(3)* (l.^7) + X(4)*(l.^6) + X(5)*(l.^5) + X(6)*(l.^4) + X(7)* (l.^3) + X(8)*(l.^2) + X(9)*l + X(10)*ones(length(l), 1 );

end

