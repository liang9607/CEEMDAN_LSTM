function SampEnVal = SampEn(data, m, r)
%SAMPEN  計算時間序列data的樣本熵
%        data爲輸入數據序列
%        m爲初始分段，每段的數據長度一般選擇1或2，優先選擇2，一般不取m>2
%        r爲閾值一般選擇r=0.1~0.25*Std(data)
% $Author: lskyp
% $Date:   2010.6.20
% Orig Version: V1.0--------分開計算長度爲m的序列和長度爲m+1的序列
%                           這一版的計算有些問題，需要注意兩個序列總數都要爲N-m
% Modi Version: V1.1--------綜合計算，計算距離時通過矩陣減法完成，避免重循環
% V1.1 Modified date: 2010.6.23
data = data(:)';
N = length(data);
Nkx1 = 0;
Nkx2 = 0;
% 分段計算距離，x1爲長度爲m的序列，x2爲長度爲m+1的序列
for k = N - m:-1:1
    x1(k, :) = data(k:k + m - 1);
    x2(k, :) = data(k:k + m);
end
for k = N - m:-1:1
    % x1序列計算
    % 統計距離，由於每行都要與其他行做減法，因此可以先將該行復製爲N-m的矩陣，然後
    % 與原始x1矩陣做減法，可以避免兩重循環，增加效率
    x1temprow = x1(k, :);
    x1temp    = ones(N - m, 1)*x1temprow;
    % 可以使用repmat函數完成上面的語句，即
    % x1temp = repmat(x1temprow, N - m, 1);
    % 但是效率不如上面的矩陣乘法
    % 計算距離，每一行元素相減的最大值爲距離
    dx1(k, :) = max(abs(x1temp - x1), [], 2)';
    % 模板匹配數
    Nkx1 = Nkx1 + (sum(dx1(k, :) < r) - 1)/(N - m - 1);
    
    % x2序列計算，和x1同樣方法
    x2temprow = x2(k, :);
    x2temp    = ones(N - m, 1)*x2temprow;
    dx2(k, :) = max(abs(x2temp - x2), [], 2)';
    Nkx2      = Nkx2 + (sum(dx2(k, :) < r) - 1)/(N - m - 1);
end
% 平均值
Bmx1 = Nkx1/(N - m);
Bmx2 = Nkx2/(N - m);
% 樣本熵
SampEnVal = -log(Bmx2/Bmx1);