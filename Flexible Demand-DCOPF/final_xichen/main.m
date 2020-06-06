% case 9, case 14 without tap, case 30,IEEE_RTS_96
clear;
%%
% test case 9
% since it's common MATPOWER case
options = optimset('Display', 'off');
x0 = [];
case9 =loadcase(case9);
%%

%|bus|load_max|load_min|n||a|   |b|  |c|
case9.load = [
	5  90 0	3 0.006 -11.4 2000;
	7 100 0 3 0.005 -11.5 2000;
	9 125 0 3 0.004   -12 2000;
];

% fixed load DCOPF quadprog parameters
[H1_c9,f1_c9,A1_c9,b1_c9,Aeq1_c9,beq1_c9,LB1_c9,UB1_c9] = getQuadprog(case9);
% variable load DCOPF quadprog parameters
[H2_c9,f2_c9,A2_c9,b2_c9,Aeq2_c9,beq2_c9,LB2_c9,UB2_c9] = getQuadprog_varLoad(case9);

x_my_case9_unvar = quadprog(H1_c9,f1_c9,A1_c9,b1_c9,Aeq1_c9,beq1_c9,LB1_c9,UB1_c9,x0,options);
x_my_case9_var = quadprog(H2_c9,f2_c9,A2_c9,b2_c9,Aeq2_c9,beq2_c9,LB2_c9,UB2_c9,x0,options);

x_my_case9_unvar = numFormat(x_my_case9_unvar,case9);
x_my_case9_var = numFormat(x_my_case9_var,case9);

a = printResult(case9,x_my_case9_var,'case9');
%%
% test case 14
case14 =loadcase(case14);
case14.load = [
	2 135 0	3 0.006 -31.7 4000;
	3 100 0 3 0.005   -32 4000;
	4 125 0 3 0.004 -32.5 4000;
];


% fixed load DCOPF quadprog parameters
[H1_c14,f1_c14,A1_c14,b1_c14,Aeq1_c14,beq1_c14,LB1_c14,UB1_c14] = getQuadprog(case14);
% variable load DCOPF quadprog parameters
[H2_c14,f2_c14,A2_c14,b2_c14,Aeq2_c14,beq2_c14,LB2_c14,UB2_c14] = getQuadprog_varLoad(case14);

x_my_case14_unvar = quadprog(H1_c14,f1_c14,A1_c14,b1_c14,Aeq1_c14,beq1_c14,LB1_c14,UB1_c14,x0,options);
x_my_case14_var = quadprog(H2_c14,f2_c14,A2_c14,b2_c14,Aeq2_c14,beq2_c14,LB2_c14,UB2_c14,x0,options);


x_my_case14_unvar = numFormat(x_my_case14_unvar,case14);
x_my_case14_var = numFormat(x_my_case14_var,case14);

a = printResult(case14,x_my_case14_var,'case14');

%%
% get the MATPOWER result
%
%%
% test case 30
case30 =loadcase(case30);
case30.load = [
	7 610 0	3 0.006 -13.5 6000;
	8 600 0 3 0.005   -13 6000;
   21 530 0 3 0.004 -13.3 6000;
];

%{
% if no congestion in the line and generator never reach its limitation
rows = length(case30.branch(:,1));
maxLine = repmat(999,rows,3);
case30.branch(:,6:8) = maxLine;
rows2 = length(case30.gen(:,9));
maxGen = repmat(999,rows2,1);
case30.gen(:,9) = maxGen;
%}

% fixed load DCOPF quadprog parameters
[H1_c30,f1_c30,A1_c30,b1_c30,Aeq1_c30,beq1_c30,LB1_c30,UB1_c30] = getQuadprog(case30);
x_my_case30_unvar = quadprog(H1_c30,f1_c30,A1_c30,b1_c30,Aeq1_c30,beq1_c30,LB1_c30,UB1_c30,x0,options);
x_my_case30_unvar = numFormat(x_my_case30_unvar,case30);

% variable load DCOPF quadprog parameters
[H2_c30,f2_c30,A2_c30,b2_c30,Aeq2_c30,beq2_c30,LB2_c30,UB2_c30] = getQuadprog_varLoad(case30);
x_my_case30_var = quadprog(H2_c30,f2_c30,A2_c30,b2_c30,Aeq2_c30,beq2_c30,LB2_c30,UB2_c30,x0,options);

x_my_case30_var = numFormat(x_my_case30_var,case30);
a = printResult(case30,x_my_case30_var,'case30');


% get the MATPOWER result
%x_mat_case9= rundcopf(case9);
%x_mat_case14= rundcopf(case14);
%x_mat_case30 = rundcopf(case30);
