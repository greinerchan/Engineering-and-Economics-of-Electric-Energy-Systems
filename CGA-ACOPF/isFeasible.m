function bool = isFeasible(mpc)
% upate the data in mpc
mpc = ACPF(mpc);
% check the solution good for Q, line, V, angle limitations
if isVoltViolate(mpc) || isAngViolate(mpc) ||...
        isPViolate(mpc) || isQViolate(mpc)%|| isLineViolate(mpc)  
    bool = 0;
else 
    bool = 1;
end
end

