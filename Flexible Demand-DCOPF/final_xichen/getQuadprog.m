function [H,f,A,b,Aeq,beq,LB,UB] = getQuadprog(caseName)
mpc = loadcase(caseName);
baseMVA = mpc.baseMVA;
zero_limit = find(mpc.branch(:,6) == 0);
mpc.branch(zero_limit,6) = 999;
genNum = size(mpc.gen,1);
Slack = find(mpc.bus(:,2) == 3);
branch = mpc.branch;
branchNum = size(branch,1); % find how many branches
bus = mpc.bus; busRow = size(mpc.bus,1);
P_Load = mpc.bus(:,3);
B_bus = findB(mpc);

% from and to bus
From_To = branch(:,[1 2]);
% vector for from and to bus
from = From_To(:,1); to = From_To(:,2);
busNum = size(bus,1);

A_1 = mpc.gencost(:,5); B = mpc.gencost(:,6); 
genLocate = mpc.gen(:,1);
A1 = zeros(3 * busRow,3 * busRow);
B1 = zeros(1,3 * busRow);
for i = 1:1:length(genLocate)
    A1(genLocate(i),genLocate(i)) = A_1(i);
    B1(genLocate(i)) = B(i);
end
H = 2 * A1 * baseMVA^2;
f = B1 * baseMVA;

% find from bus vector
from_red = []; to_red = []; bus_red = [];
for i = 1:1:branchNum
    from_cur = find(mpc.bus(:,1) == from(i));
    from_red = [from_red;from_cur];
end
% find to bus vector
for i = 1:1:branchNum
    to_cur = find(mpc.bus(:,1) == to(i));
    to_red = [to_red;to_cur];
end
% find the bus vector
for i = 1:1:busNum
    bus_cur = find(mpc.bus(:,1) == mpc.bus(i,1));
    bus_red = [bus_red;bus_cur];
end

% find branch susceptance matrix
branch_b = zeros(branchNum,1); 
for m = 1:1:branchNum
    branch_b(m) = B_bus(from_red(m),to_red(m));
end

% find line flow matrix
Line_Mat = zeros(branchNum,busNum); 
for m = 1:1:branchNum
    for n = 1:1:busNum
        Line_Mat(m,from_red(m)) = -B_bus(from_red(m),to_red(m));
        Line_Mat(m,to_red(m)) = B_bus(from_red(m),to_red(m));
    end
end

% find load matrix
Load_Mat = zeros(busNum,busNum); 
load_row = find(mpc.bus(:,3) > 0); % find bus load locates
for i = 1:1:size(load_row,1)
    load_bus = load_row(i);
    Load_Mat(load_bus,load_bus) = 1;
end
% find the generator matrix
Pg_Mat = zeros(busNum,busNum);
gen_vv = mpc.gen(:,1); gen_v = [];

for i = 1:1:genNum
    gen_index = find(mpc.bus(:,1) == gen_vv(i,1));
    gen_v = [gen_v;gen_index];
end
gen_min = mpc.gen(:,10)/baseMVA;
gen_max = mpc.gen(:,9)/baseMVA;
for i = 1:1:genNum
    Pg_Mat(gen_v(i),gen_v(i)) = -1;
end
% found bound for load
P_d = zeros(busNum,1);
for i = 1:1:busRow
    P_d(bus_red(i),1) = P_Load(i)/baseMVA;
end
% set up the generator matrix
LB_Theta = zeros(busNum,1) - pi/4; UB_Theta = zeros(busNum,1) + pi/4;
LB_gen = zeros(busNum,1)/baseMVA; UB_gen = zeros(busNum,1)/baseMVA;
for i = 1:1:genNum
    LB_gen(gen_v(i),1) = gen_min(i);
    UB_gen(gen_v(i),1) = gen_max(i);
end
b_c= branch(:,6);
% set up the quadprog
A = [zeros(branchNum,busNum),zeros(branchNum,busNum),Line_Mat]; b = b_c; 
A = [A;-A]; b = [b;b]/baseMVA;
Aeq = [Pg_Mat,Load_Mat,B_bus];
beq = zeros(busNum,1); LB = [LB_gen;P_d;LB_Theta]; UB = [UB_gen;P_d;UB_Theta];
LB(2*busNum+Slack,1) = 0; UB(2*busNum+Slack,1) = 0;

end

%{
Load_Mat = zeros(busNum,busNum); 
for i = 1:1:busRow
    Load_Mat(bus(i),bus(i)) = -1;
end
% find the load bus
%loadBus = find(mpc.bus(:,3) > 0);
%mpc.gencost(:,6) = [43,23,34,23,55,33];
%mpc.gencost(:,6) = [33.6;27.55;35.3];
%B_bus = imag(makeYbus(mpc));
%DCOPF Summary of this function goes here
%   Detailed explanation goes here
%mpc = loadcase(caseName);
%mpc = IEEE_RTS_96;
%mpc = loadcase(caseName);
%}
