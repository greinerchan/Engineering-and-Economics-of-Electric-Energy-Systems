function bool = isVoltViolate(mpc)

% find voltage violation happened in solution
%Vmax = mpc.bus(1,12); Vmin = mpc.bus(1,13);
Vmax = 1.1; Vmin = 0.9;
Vm = mpc.bus(:,8); V_vioMax = Vm(Vm > Vmax);
V_vioMaxTotal = abs(sum(V_vioMax - Vmax));

V_vioMin = Vm(Vm < Vmin);
V_vioMinTotal = abs(sum(V_vioMin - Vmin));

V_vioTotal = V_vioMaxTotal + V_vioMinTotal;

if V_vioTotal ~= 0
    bool = 1;
else 
    bool = 0;
end

end

