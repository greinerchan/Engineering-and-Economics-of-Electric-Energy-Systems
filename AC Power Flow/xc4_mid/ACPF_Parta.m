function [result] = ACPF_Parta(obj_circ)
%ACOPF Summary of this function goes here
%%
% initial the Data set
%clear; %open('case9');
%caseName = case9;
%Y_bus_Mat = full(makeYbus(obj_circ,1));
%obj_circ = loadcase(case14);
obj_circ_copy = obj_circ;
[row,col] = size(obj_circ.bus); busNum = row;
genList = obj_circ.gen(:,1);
baseMVA = obj_circ.baseMVA;
%AAA = full(makeJac(caseName));
%CCC = runpf(caseName);
BBB = full(makeYbus(obj_circ));
%DDD = full(makeJac(caseName,1));
%%
%find the generator and load information
[genNum, genCol] = size(obj_circ.gen);
gen_bus = sortrows(obj_circ.gen(:,1),1);
gen_P = zeros(busNum,1); % real power for each generator 
gen_Q = zeros(busNum,1); % reactive power for each generator 
load_P = zeros(busNum,1); % real power for each bus load  
load_Q = zeros(busNum,1); % reactive power for each bus load    
for i=1:1:genNum
    gen_P(obj_circ.gen(i,1),1) = obj_circ.gen(i,2);
end
for i=1:1:genNum
    gen_Q(obj_circ.gen(i,1),1) = obj_circ.gen(i,3);
end
for i=1:1:busNum
    load_P(i,1) = obj_circ.bus(i,3);
end
for i=1:1:busNum
    load_Q(i,1) = obj_circ.bus(i,4);
end

% find per unit for the generator and load
gen_P=gen_P/obj_circ.baseMVA; gen_Q=gen_Q/obj_circ.baseMVA;
load_P=load_P/obj_circ.baseMVA; load_Q=load_Q/obj_circ.baseMVA;
P_s = (gen_P-load_P);
Q_s = (gen_Q-load_Q);
%%
% find limits
%%
% find PV bus, PQ bus and slack bus
%               PQ bus          = 1
%               PV bus          = 2
%               reference bus   = 3
Slack = find(obj_circ.bus(:,2) == 3);
PV = find(obj_circ.bus(:,2) == 2);
PQ = find(obj_circ.bus(:,2) == 1);
%%
Y_bus = findYbus(obj_circ); %find Y bus
Bus_Error = BBB - Y_bus;
V_initial = obj_circ.bus(:,8); % initial voltage
% bus with generator
for i=1:1:genNum
    V_initial(obj_circ.gen(i,1),1) = obj_circ.gen(i,6);
end
%V_gen = V_initial(1:genNum,1);
theta_initial = obj_circ.bus(:,9)/180*pi; % initial angle
ThetaV_Cur = [theta_initial; V_initial];
Vtheta_Cur = VThetaComplex(ThetaV_Cur,busNum);
%%
accuracy = 1e-7; iter = 1;
while 1
    % find the calculate value
    [P_cal,Q_cal]=nodeBalance(Vtheta_Cur,Y_bus,busNum);
    % find the change need to make
    delta_P = P_s - P_cal;
    delta_Q = Q_s - Q_cal;
    % find the jaccobian of the with initial point
    [J1,J2] = pflowjac(Y_bus,Vtheta_Cur);
    % fix 
    %result.bus( = 
    Jac_Reduced = reduceJac(J1,J2,Slack,PV,PQ);
    %Jac_Error = AAA - Jac_Reduced;
    % get rid of known P,Q
    delta_P(Slack,:) = [];
    delta_Q([Slack;PV].',:) = [];
    delta_PQ = [delta_P;delta_Q];
    % find V,theta change
    delta_ThetaV = Jac_Reduced \ delta_PQ;    
    % fix the delta_ThetaV to the orginal size
    %insert 0 slack bus angle 
    delta_ThetaV_full = [delta_ThetaV(1:Slack-1,:);0;...
        delta_ThetaV(Slack:end,:)]; 
    % insert 0 pv,slack bus voltage
    Slack_PV = [Slack;PV];
    Slack_PV = sortrows(Slack_PV(:,1),1);
    for i = 1:1:length(Slack_PV)
        insertBefore = Slack_PV(i,1);
        delta_ThetaV_full = [delta_ThetaV_full(1:(insertBefore+busNum-1),:);0;...
        delta_ThetaV_full((insertBefore+busNum):end,:)]; 
    end
    % update V,theta for next iteration
    ThetaV_Cur = ThetaV_Cur + delta_ThetaV_full;
    Vtheta_Cur = VThetaComplex(ThetaV_Cur, busNum);
    % 
    if max(abs(delta_PQ(:,1))) < accuracy || iter > 2
        Theta_V = ThetaV_Cur;
        [P_cal,Q_cal]=nodeBalance(Vtheta_Cur,Y_bus,busNum);
        P_Gen = P_cal + load_P; Q_Gen = Q_cal + load_Q;
        obj_circ_copy.bus(:,8) = Theta_V((busNum + 1):end,:);
        obj_circ_copy.bus(:,9) = Theta_V(1:busNum,:)./pi*180;
        obj_circ_copy.gen(:,2) = P_Gen(genList,1) * baseMVA;
        obj_circ_copy.gen(:,3) = Q_Gen(genList,1) * baseMVA;
        % check if Q violate
        [vioMax,vioMin] = findViolate(obj_circ_copy); 
        if ~isempty(vioMax)
            fprintf('reactive power violates upper bounds for generator on bus %d\n',...
                obj_circ.gen(i,1));
        end
        if ~isempty(vioMin)
            fprintf('reactive power violates lower bounds for generator on bus %d\n',...
                obj_circ.gen(i,1));
        end        
        result = obj_circ_copy;
        break;
    end
    iter = iter + 1;
end
end

