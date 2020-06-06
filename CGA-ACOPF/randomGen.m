function mpc2 = randomGen(mpc)
% randomly generate a feasible power flow generator combination
%clear;
%mpc = loadcase(case9);
UB = mpc.gen(:,9); LB = mpc.gen(:,10); space = 30;
UB_Q = mpc.gen(:,5); LB_Q = mpc.gen(:,4);


Pd = sum(mpc.bus(:,3)); genNum = length(mpc.gen(:,1));
Pg = round((UB-LB).*rand(genNum,1) + LB);
while sum(Pg) <=  (sum(Pd)- space) || sum(Pg) >= (sum(Pd) + space)
    Pg = round((UB-LB).*rand(genNum,1) + LB);
end
Qg = round((UB_Q-LB_Q).*rand(genNum,1) + LB_Q);

mpc.gen(:,2) = Pg;
mpc.gen(:,3) = Qg;
mpc2 = mpc;
end

