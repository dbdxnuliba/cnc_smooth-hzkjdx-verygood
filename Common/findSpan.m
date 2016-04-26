function index = findSpan(n, p, u, U)

% ���ö��ַ��õ�u���ڽڵ������������
% ����n,p,u,U����������������±�
% n = m - p - 1��mΪ�ڵ�����-1
% pΪҪ��Ļ���������
% uΪ����
% UΪ�ڵ�����

if u == U(n + 2)
    index = n;
    return;
end

low = p + 1;
high = n + 2;
mid = floor((low + high) / 2);
 
i = 1;
if u < 0
    while U(i) == 0
        i = i + 1;
    end
    index = i - 2;
    return;
end

if u >= 1
    while U(i) < 1
        i = i + 1;
    end
    index = i - 2;
    return;
end


 while u < U(mid) || u >= U(mid + 1)
     if u < U(mid)
         high = mid;
     else
         low = mid;
     end
     mid = floor((low + high) / 2);
 end
 index = mid - 1;