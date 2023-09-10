clc;clear;
load ('a.mat');

Nstd = 0.2;
NR = 500;
MaxIter = 5000;


[modes its]=ceemdan(a,0.2,200,5000);
t=1:length(a);

[x b]=size(modes);

figure;
subplot(x+1,1,1);
plot(t,a);% the ECG signal is in the first row of the subplot
ylabel('ECG')
set(gca,'xtick',[])
axis tight;

for i=2:x
    subplot(x+1,1,i);
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 length(a)])
end;

subplot(x+1,1,x+1)
plot(t,modes(x,:))
ylabel(['IMF ' num2str(x)])
xlim([1 length(a)])

figure;
boxplot(its);