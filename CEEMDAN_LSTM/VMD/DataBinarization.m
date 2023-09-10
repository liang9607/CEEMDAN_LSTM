function BinaryData = DataBinarization( data )
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    DataBinarization:     数据二值化处理
 
%    AUTHOR : Andy Wu
 
%    DATE:     2010/05/01
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
MeanData = median(data);                         
 
[l,c] = size(data);
BinaryData(1:l,1:c) = '0';
 
for i=1:c
   Tno =  data(:,i) > MeanData(i) ;
   BinaryData(Tno,i) = '1';
end
 
return;
 
 
function [lzc]=ComplexityCompute(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  计算一维信号的复杂度
%  x:  the signal is vector
%  lzc:  the complexity of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%模式初始值
c = 1;                                                                  
 
%S Q SQ初始化
S = x(1);Q = [];SQ = [];                                     
 
for i=2:length(x)
   Q = strcat(Q,x(i));
   SQ = strcat(S,Q);
   SQv = SQ(1:length(SQ)-1);
   if isempty(findstr(SQv,Q))   %如果Q不是SQv中的子串，说明Q是新出现的模式，执行c 加1操作      
       S = SQ;
       Q = [];
       c = c+1;    
   end
end
 
b = length(x)/log2(length(x));
lzc = c/b;
 
return;