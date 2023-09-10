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

        z=hilbert(testdata');                   % ϣ�����ر任

        a=abs(z);                               % ������

        fnor=instfreq(z);                       % ˲ʱƵ��

        resf(i)=mean(fnor);     

    end

    subplot(3,3,st)

    plot(resf,'k');title(['����Ϊ',num2str(st)]);grid on;

end