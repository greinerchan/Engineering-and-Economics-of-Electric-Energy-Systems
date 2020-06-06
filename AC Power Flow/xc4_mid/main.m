clear;
VTheta_bus = [8,9]; PQ_gen = [2,3]; 
%%
%{
Question 1. (100 pts)
Code in Matlab AC power flow using Matpower case (MPC) format. 
Your function should take an MPC structure as input and return an MPC 
structure of the solution. You are not allowed to use Matpower functions. 
Your program should handle networks with a single generator and/or a single 
load on a bus or no generator and/or no load. Use 10?7 for convergence accuracy.

Part(a) (50pts points) Plain vanilla AC power flow with no reactive power 
limits enforced. Provide demo case showing results with and without 
reactive power limit violations.
%}
casepj = loadcase(casepj);
casepj_result = ACPF_Parta(casepj);
casepj_result2 = runpf(casepj);
% load the cases
case4gs = loadcase(case4gs); case9 = loadcase(case9); 
case14 = loadcase(case14); case18 = loadcase(case18);
case22 = loadcase(case22);

% run power flow to get the MATPOWER answers
case4gs_MATPOWER = runpf(case4gs); case9_MATPOWER = runpf(case9);
case14_MATPOWER = runpf(case14); case18_MATPOWER = runpf(case18);
case22_MATPOWER = runpf(case22); 

% run power flow to get my answer
case4gs_MY = ACPF_Parta(case4gs); case9_MY = ACPF_Parta(case9);
case14_MY = ACPF_Parta(case14); case18_MY = ACPF_Parta(case18);
case22_MY = ACPF_Parta(case22); 

% test serveral cases to make sure it works
% compare two answers? bus and generator, when no reactive power violations
% case 1
a1_diffBus_case4gs_PartA = case4gs_MY.bus(:,VTheta_bus) - ...
    case4gs_MATPOWER.bus(:,VTheta_bus);
a1_diffGen_case4gs_PartA = case4gs_MY.gen(:,PQ_gen) - ...
    case4gs_MATPOWER.gen(:,PQ_gen);
% case 2
a1_diffBus_case9_PartA = case9_MY.bus(:,VTheta_bus) - ...
    case9_MATPOWER.bus(:,VTheta_bus);
a1_diffGen_case9_PartA = case9_MY.gen(:,PQ_gen) - ...
    case9_MATPOWER.gen(:,PQ_gen);
% case 3 
a1_diffBus_case14_PartA = case14_MY.bus(:,VTheta_bus) - ...
    case14_MATPOWER.bus(:,VTheta_bus);
a1_diffGen_case14_PartA = case14_MY.gen(:,PQ_gen) - ...
    case14_MATPOWER.gen(:,PQ_gen);
% case 4
a1_diffBus_case18_PartA = case18_MY.bus(:,VTheta_bus) - ...
    case18_MATPOWER.bus(:,VTheta_bus);
a1_diffGen_case18_PartA = case18_MY.gen(:,PQ_gen) - ...
    case18_MATPOWER.gen(:,PQ_gen);
% case 5
a1_diffBus_case22_PartA = case22_MY.bus(:,VTheta_bus) - ...
    case22_MATPOWER.bus(:,VTheta_bus);
a1_diffGen_case22_PartA = case22_MY.gen(:,PQ_gen) - ...
    case22_MATPOWER.gen(:,PQ_gen);

% I select case 9 as my demo case for violating the reactive limits
% add more reactive power to the bus 3 in case 9 to exceed the maximum 
% reactive power limits generation at generator 3 and set it 360 MVAr
a2_case9_violated = case9; a2_case9_violated.bus(3,4) = 360;
a2_case9_violatedMax_MATwithQ = ...
    runpf(a2_case9_violated, mpoption('pf.enforce_q_lims', 1));
a2_case9_violatedMax_MATnoQ = runpf(a2_case9_violated);
a2_case9_violatedMax_MYnoQ = ACPF_Parta(a2_case9_violated);
% reactive power limits generation at generator 3 and set it -360 MV
a3_case9_violated = case9; a3_case9_violated.bus(3,4) = -360;
a3_case9_violatedMin_MATwithQ_Min = ...
    runpf(a3_case9_violated, mpoption('pf.enforce_q_lims', 1));
a3_case9_violatedMin_MATnoQ = runpf(a3_case9_violated);
a3_case9_violatedMin_MYnoQ = ACPF_Parta(a3_case9_violated);
%%
%{
Part(b) (30pt points) Enforce reactive power limits. Provide demo case  
showing results with and without reactive power limit violations.
%}

% I will still use case 9 as my demo case to compare my result

% case 9, with no violation
b1_case9 = case9; 
b1_case9_MATPOWER_noQ = ...
    runpf(b1_case9, mpoption('pf.enforce_q_lims', 1));
b1_case9_MY_noQ = ACPF_Partb(b1_case9);

% case 9, with max violation, bus 3 set 360 MVAr load
b2_case9_violatedMax = case9; b2_case9_violatedMax.bus(3,4) = 360;
b2_case9_MATPOWER_MaxWithQ = ...
    runpf(b2_case9_violatedMax, mpoption('pf.enforce_q_lims', 1));
b2_case9_MY_MaxWithQ = ACPF_Partb(b2_case9_violatedMax);

% case 9, with min violation, bus 3 set -360 MVAr load
b3_case9_violatedMin = case9; b3_case9_violatedMin.bus(3,4) = -360;
b3_case9_MATPOWER_MinWithQ = ...
    runpf(b3_case9_violatedMin, mpoption('pf.enforce_q_lims', 1));
b3_case9_MY_MinWithQ = ACPF_Partb(b3_case9_violatedMin);

%%
%{
(c) (10pts points) Add transformers with fixed tap setting. Provide demo 
case showing results with different tap settings.
%}
% use case 14 becasue it uses tranformer 
c1_noTranformer_MY = ACPF_Parta(case14);
c1_noTranformer_MAT = runpf(case14);
% use different tap setting, change baranch 
% 4-7 4-9 5-6 6-11 ratio 0.7,0.8,0.9,0.7   
c2_withTranformer = case14; 
c2_withTranformer.branch(8,9) = 0.7; c2_withTranformer.branch(9,9) = 0.8;
c2_withTranformer.branch(10,9) = 0.9; c2_withTranformer.branch(11,9) = 0.7;
% use MATPOWER function to make sure the answer is correct
c2_withTransformer_MAT = runpf(c2_withTranformer);
c2_withTransformer_MY = ACPF_Parta(c2_withTranformer);
c2_diffBus_withTransformer = c2_withTransformer_MY.bus(:,VTheta_bus) - ...
    c2_withTransformer_MAT.bus(:,VTheta_bus);
c2_diffGen_withTransformer = c2_withTransformer_MY.gen(:,PQ_gen) - ...
    c2_withTransformer_MAT.gen(:,PQ_gen);
c2_Ybus_MY = findYbus(c2_withTranformer);
c2_Ybus_MATPOWER = full(makeYbus(c2_withTranformer));
c2_diffY_withTransformer = c2_Ybus_MY - c2_Ybus_MATPOWER;
% Last, compare the result in the write up
%%
%{
(d) (10pts points) Add transformers with fixed phase shift. Provide demo 
case showing results with different phase shift setting.
%}
% still use the struct modified in part C for the demo of part D but we  
% add phase shift for all tranformers, so it will be easier to compare the
% result between these two, and change baranch 4-7 4-9 5-6 6-11 angle to
% 10,20,10,10 
d1_withTranformer_Phase = c2_withTranformer; 
d1_withTranformer_Phase.branch(8,10) = 10; d1_withTranformer_Phase.branch(9,10) = 20;
d1_withTranformer_Phase.branch(10,10) = 10; d1_withTranformer_Phase.branch(11,10) = 10;
% use MATPOWER function to make sure the answer is correct
d2_withTransformer_MAT_Phase = runpf(d1_withTranformer_Phase);
d2_withTransformer_MY_Phase = ACPF_Parta(d1_withTranformer_Phase);
d2_diffBus_withTransformer_phase = d2_withTransformer_MY_Phase.bus(:,VTheta_bus) - ...
    d2_withTransformer_MAT_Phase.bus(:,VTheta_bus);
d2_diffGen_withTransformer = d2_withTransformer_MY_Phase.gen(:,PQ_gen) - ...
    d2_withTransformer_MAT_Phase.gen(:,PQ_gen);
d2_Ybus_MY_Phase = findYbus(d1_withTranformer_Phase);
d2_Ybus_MATPOWER_Phase = full(makeYbus(d1_withTranformer_Phase));
d2_diffY_withTransformer = d2_Ybus_MY_Phase - d2_Ybus_MATPOWER_Phase;
% last, compare the result in the write up
%%