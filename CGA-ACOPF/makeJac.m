function J = makeJac(Ym,t,Vm,delta,mpc)
% modifed to fit my project. It original write by H. Saadat  
ns = 0; ng = 0;
nbus = length(mpc.bus(:,1));  
kb = mpc.bus(:,2);
nbr = length(mpc.branch(:,1)); nr = mpc.branch(:,2);
nl = mpc.branch(:,1);
for k=1:nbus 
if kb(k) == 3, ns = ns+1; else, end 
if kb(k) == 2, ng = ng+1; else, end 
ngs(k) = ng; 
nss(k) = ns; 
end 


for n=1:nbus 
nn=n-nss(n); 
lm=nbus+n-ngs(n)-nss(n)-ns; 
J11=0; J22=0; J33=0; J44=0; 
   for i=1:nbr 
     if nl(i) == n || nr(i) == n 
        if nl(i) == n,  l = nr(i); end 
        if nr(i) == n,  l = nl(i); end 
        J11=J11+ Vm(n)*Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l)); 
        J33=J33+ Vm(n)*Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l)); 
        if kb(n)~=3 
        J22=J22+ Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l)); 
        J44=J44+ Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l)); 
        else, end 
        if kb(n) ~= 3  && kb(l) ~=3 
        lk = nbus+l-ngs(l)-nss(l)-ns; 
        ll = l -nss(l); 
      % off diagonalelements of J1 
        J(nn, ll) =-Vm(n)*Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l)); 
              if kb(l) == 1  % off diagonal elements of J2 
              J(nn, lk) =Vm(n)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l));end 
              if kb(n) == 1  % off diagonal elements of J3 
              J(lm, ll) =-Vm(n)*Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n)+delta(l)); end 
              if kb(n) == 1 && kb(l) == 1  % off diagonal elements of  J4 
              J(lm, lk) =-Vm(n)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l));end 
        else end 
     else , end 
   end 
   if kb(n) ~= 3 
     J(nn,nn) = J11;  %diagonal elements of J1 
   end 
   if kb(n) == 1 
     J(nn,lm) = 2*Vm(n)*Ym(n,n)*cos(t(n,n))+J22;  %diagonal elements of J2 
     J(lm,nn)= J33;        %diagonal elements of J3 
     J(lm,lm) =-2*Vm(n)*Ym(n,n)*sin(t(n,n))-J44;  %diagonal of elements of J4 
   end 
end 
end

