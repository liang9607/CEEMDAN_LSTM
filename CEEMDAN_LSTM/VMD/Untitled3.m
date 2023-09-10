clear;clc;
load a.mat
data=a;
for st=1:9

    K=st+1;

    [u, u_hat, omega] = VMD(data, 1000, 0.2, K, 0, 1, 1e-5);

    u=flipud(u);

    resf=zeros(1,K);

    for i=1:K

        testdata=u(i,:);

        hilbert(testdata'); 

        z=hilbert(testdata');                   % 希尔伯特变换

        a=abs(z);                               % 包络线

        fnor=instfreq(z);                       % 瞬时频率

        resf(i)=mean(fnor);     

    end

    subplot(3,3,st)

    plot(resf,'k');title(['个数为',num2str(st)]);grid on;

end