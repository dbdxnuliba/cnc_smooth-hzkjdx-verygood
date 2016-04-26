function [u, hIterat] = OrientationReparameterization(Lambda, L)
% ����ʸ���ز�����
n = length(L);
u(1) = 0;

ErrLimt = 0.0001;

for i = 1:n + 1
    % ���㼸���м����
    
    if i > 1
        if i < n + 1
            a(i) = 1 / Lambda(i);
            b(i) = Lambda(i - 1) / L(i - 1)^2 + Lambda(i) / L(i)^2;
            c(i) = 1 / L(i - 1) + 1 / L(i);
        end
        
        u(i) = u(i - 1) + Lambda(i - 1);
    end
    
    % �����ʼhi
    if i == 1
        h(i, 1) = (Lambda(1) * L(2) * (L(1) + L(2) + 1) - Lambda(2) * L(1)) / (L(1) * L(2) * (L(1) + L(2)));
    elseif i == n + 1
        h(i, 1) = (Lambda(n) * L(n - 1) * (L(n) + L(n - 1) + 1) - Lambda(n - 1) * L(n)) / (L(n) * L(n - 1) * (L(n) + L(n - 1)));
    else
        h(i, 1) = sqrt(b(i) / (a(i - 1) + a(i)));
    end    
end

% ���е�����h
j = 2;
while 1
    h(1, j) = h(1, j - 1);
    h(n + 1, j) = h(n + 1, j - 1);
    maxErr = 0;
    for i = 2:n
        % ����ʽ��36�����е���
%         h(i, j) = sqrt(c(i) - a(i - 1) * h(i - 1, j - 1) + [(c(i) - a(i - 1) * h(i - 1, j) - a(i) * h(i + 1, j - 1))^2 + 4 * (a(i - 1) + a(i)) * b(i)]) / (2 * (a(i - 1) + a(i)));
        h(i, j) = (c(i) - a(i - 1) * h(i - 1, j) - a(i) * h(i + 1, j - 1) + sqrt((c(i) - a(i - 1) * h(i - 1, j) - a(i) * h(i + 1, j - 1))^2 + 4 * (a(i - 1) + a(i)) * b(i))) / (2 * (a(i - 1) + a(i)));
        dhw = abs(h(i, j - 1) - h(i, j));

        maxErr = max(dhw, maxErr);

    end
    
    % ������ֹ�����ж�
    if maxErr < ErrLimt
        break;
    end
    j = j + 1;
end

hIterat = h(:, j);

% % �����ز���������
% for i = 1:n + 1
%     
% end