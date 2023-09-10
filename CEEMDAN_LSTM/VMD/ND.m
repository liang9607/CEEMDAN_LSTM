clear;clc;
load a.mat;

x=length(a);
[u, u_hat, omega] = VMD(a(1:x), 2049,1,6, 0,1, 1e-7);
u=u';
d=sum(u,2);
c=a-d;
e=norm(c);
f=norm(a);
g=norm(d);
result=e/(f+g);

