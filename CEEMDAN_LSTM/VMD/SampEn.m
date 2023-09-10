function SampEnVal = SampEn(data, m, r)
%SAMPEN  Ӌ��r�g����data�Ęӱ���
%        data��ݔ�딵������
%        m����ʼ�ֶΣ�ÿ�εĔ����L��һ���x��1��2�������x��2��һ�㲻ȡm>2
%        r���ֵһ���x��r=0.1~0.25*Std(data)
% $Author: lskyp
% $Date:   2010.6.20
% Orig Version: V1.0--------���_Ӌ���L�Ƞ�m�����к��L�Ƞ�m+1������
%                           �@һ���Ӌ����Щ���}����Ҫע��ɂ����п�����Ҫ��N-m
% Modi Version: V1.1--------�C��Ӌ�㣬Ӌ����x�rͨ�^��ꇜp����ɣ�������ѭ�h
% V1.1 Modified date: 2010.6.23
data = data(:)';
N = length(data);
Nkx1 = 0;
Nkx2 = 0;
% �ֶ�Ӌ����x��x1���L�Ƞ�m�����У�x2���L�Ƞ�m+1������
for k = N - m:-1:1
    x1(k, :) = data(k:k + m - 1);
    x2(k, :) = data(k:k + m);
end
for k = N - m:-1:1
    % x1����Ӌ��
    % �yӋ���x�����ÿ�ж�Ҫ�c���������p������˿����Ȍ�ԓ�Џ��u��N-m�ľ�ꇣ�Ȼ��
    % �cԭʼx1������p�������Ա������ѭ�h������Ч��
    x1temprow = x1(k, :);
    x1temp    = ones(N - m, 1)*x1temprow;
    % ����ʹ��repmat�������������Z�䣬��
    % x1temp = repmat(x1temprow, N - m, 1);
    % ����Ч�ʲ�������ľ�ꇳ˷�
    % Ӌ����x��ÿһ��Ԫ�����p�����ֵ�����x
    dx1(k, :) = max(abs(x1temp - x1), [], 2)';
    % ģ��ƥ�䔵
    Nkx1 = Nkx1 + (sum(dx1(k, :) < r) - 1)/(N - m - 1);
    
    % x2����Ӌ�㣬��x1ͬ�ӷ���
    x2temprow = x2(k, :);
    x2temp    = ones(N - m, 1)*x2temprow;
    dx2(k, :) = max(abs(x2temp - x2), [], 2)';
    Nkx2      = Nkx2 + (sum(dx2(k, :) < r) - 1)/(N - m - 1);
end
% ƽ��ֵ
Bmx1 = Nkx1/(N - m);
Bmx2 = Nkx2/(N - m);
% �ӱ���
SampEnVal = -log(Bmx2/Bmx1);