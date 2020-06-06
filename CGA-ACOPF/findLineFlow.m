function [lineFlow, losses] = findLineFlow(mpc)
% find power flow for each branch
%mpc = loadcase(case9);
from = mpc.branch(:,1); to = mpc.branch(:,2);
numBranch = length(from); numBus = length(mpc.bus(:,1));
Ybus = findYbus(mpc); Gbus = real(Ybus); Bbus = imag(Ybus);
Vm = mpc.bus(:,8); delta = mpc.bus(:,9); theta = angle(Ybus);
Rs = mpc.branch(:,3); Xs = mpc.branch(:,4);
V = Vm .* exp(1j * pi/180 * delta); baseMVA = mpc.baseMVA;

lineFlow = []; losses = []; I = [];

for i = 1:1:numBranch
    from_bus = from(i); to_bus = to(i);
    % since we flip the positive to neagtive of Y value, add "-"
    I = -(V(from_bus) - V(to_bus))*Ybus(from_bus,to_bus); 
    S = V(from_bus)*conj(I)*baseMVA;
    lineFlow = [lineFlow; S];
    
    loss = (abs( V(from_bus) - V(to_bus) ) ^ 2 / (Rs(i) - 1j*Xs(i)))...
        * baseMVA;
    losses = [losses;loss];
end

lineFlow = abs(lineFlow);
end

