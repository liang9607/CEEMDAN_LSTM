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
    set(findall(gcf,'type','hggroup'),'FontSize',8);  %%设置数据游标（标尺）的字体大小
    set(findall(gcf,'type','line'),'linewidth',1);%%设置全部线宽为2，默认为0.5
    set(gca,'FontName','Times New Roman','FontSize',8,'LineWidth',1.0);%设置坐标轴的字体，字体大小，线宽
    set(gca,'FontSize',8); %设置坐标轴字体大小为20
    set(legend,'FontSize',8);   %设置legend的字体大小
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 length(a)])
end


