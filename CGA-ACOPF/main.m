
clear;
mpc = loadcase(case9);
Matpower = runopf(mpc);
% population should be even number
Pc = 0.9; Pm = 0.01; Er = 0.2; maxGen = 180; pop = 40;
[best_mpc,cost] = CGA(pop,Pc,Pm,Er,maxGen,mpc);
genCost = findFuelCost(best_mpc);


