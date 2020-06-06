function [Vtheta_Cur] = VThetaComplex(ThetaV_Cur,busNum)
%VTHETACOMPLEX Summary of this function goes here
%   Detailed explanation goes here
Vtheta_Cur1 = [];
for i=1:1:busNum
    theta = ThetaV_Cur(i,1); rho = ThetaV_Cur(i+busNum,1);
    [realPart,imagPart] = pol2cart(theta,rho);
    Vtheta_Cur1(i,1) = realPart+imagPart*1j;
end
Vtheta_Cur = Vtheta_Cur1;
end

