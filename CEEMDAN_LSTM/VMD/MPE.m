function E=MPE(iSig,m,s)
% iSig: input signal; m : Embedded dimension; % s: scale number
for i=1:1:s %i : scale index
    oSig=CoarseGrain(iSig,i); E(i)=PE(oSig,m);
end
%Coarse Grain Procedure. See Equation (11) % iSig: input signal ; s : scale numbers ; oSig: output
function oSig=CoarseGrain(iSig,s)
    N=length(iSig); %length of input signal
for i=1:1:N/s
    oSig(i)=mean(iSig((i-1)*s+1:i*s));
end
% function to calculate permutation entropy % signal: input signal; m: embedded dimension
function E=PE(sig,m)
N=length(sig); %length of signal
v=[1:m]; % m=3, v=[1 2 3]; m=5, v=[1 2 3 4 5]
all_pemu=perms(v); % generate all possible permutations
perm_num=factorial(m); % calculate m! to obtain the number of all possible permutations
for i=1:1:perm_num
    key(i)=genkey(all_pemu(i,:)); %transform a vector into an integer; ex: [4 3 1 2] ==> 4321
end
pdf=zeros(1,perm_num); %initialize frequency array
for i=1:1:N-m+1
    pattern=sig(i:i+m-1); % obtain pattern vector from signal. 
    [Y,order]=sort(pattern); % sort the pattern vector; order represents the permutation order.
    pkey=genkey(order); %transform the order vector into an integer. 
    id=find(key==pkey); pdf(id)=pdf(id)+1; 
end
pdf=pdf/(N-m+1); % normalize the frequency array to obtain probability density function.
%calculate the entropy
E=0;
for i=1:1:perm_num
    if (pdf(i)~=0)
        E=E-pdf(i)*log(pdf(i)); %calculate entropy. 
    end
end
perm_num = min(perm_num, N-m+1);
E=E/log(perm_num); %normalize entropy. 
%function to transform a vector into an integer; ex: [2 1 3]==> 213, [4 3 1 2] ==> 4321
function key=genkey(x)
key=0;
for i=1:1:length(x)
   key=key*10+x(i);
end