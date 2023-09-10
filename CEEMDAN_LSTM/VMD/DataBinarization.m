function BinaryData = DataBinarization( data )
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    DataBinarization:     ���ݶ�ֵ������
 
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
%  ����һά�źŵĸ��Ӷ�
%  x:  the signal is vector
%  lzc:  the complexity of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ģʽ��ʼֵ
c = 1;                                                                  
 
%S Q SQ��ʼ��
S = x(1);Q = [];SQ = [];                                     
 
for i=2:length(x)
   Q = strcat(Q,x(i));
   SQ = strcat(S,Q);
   SQv = SQ(1:length(SQ)-1);
   if isempty(findstr(SQv,Q))   %���Q����SQv�е��Ӵ���˵��Q���³��ֵ�ģʽ��ִ��c ��1����      
       S = SQ;
       Q = [];
       c = c+1;    
   end
end
 
b = length(x)/log2(length(x));
lzc = c/b;
 
return;