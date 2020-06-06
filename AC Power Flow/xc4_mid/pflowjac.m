function [dSdd,dSdv]=pflowjac(Yb,Vb) 
Ib=Yb*Vb;
dSdd=1j*diag(conj(Ib).*Vb)- 1j*diag(Vb)*conj(Yb)*diag(conj(Vb)); 
dSdv=diag(conj(Ib).*(Vb./abs(Vb)))+diag(Vb)*conj(Yb)*diag(conj(Vb)./abs(Vb));


