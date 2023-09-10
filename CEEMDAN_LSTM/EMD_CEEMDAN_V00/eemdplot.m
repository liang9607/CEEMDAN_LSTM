clc;clear;

load a.mat;
load modes.mat;

figure;

[x b]=size(modes);
t=1:length(a);
% subplot(x+1,1,1);
% plot(t,a);% the ECG signal is in the first row of the subplot
% ylabel('ECG')
% set(gca,'xtick',[])
% axis tight;

for i=2:x+1
    subplot(x,1,i-1);
%     set (gca,'position',[0.1,0.1,0.9,0.9] );
    set(findall(gcf,'type','hggroup'),'FontSize',8);  %%���������α꣨��ߣ��������С
    set(findall(gcf,'type','line'),'linewidth',1);%%����ȫ���߿�Ϊ2��Ĭ��Ϊ0.5
    set(gca,'FontName','Times New Roman','FontSize',8,'LineWidth',1.0);%��������������壬�����С���߿�
    set(gca,'FontSize',8); %���������������СΪ20
    set(legend,'FontSize',8);   %����legend�������С
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 length(a)])
end


