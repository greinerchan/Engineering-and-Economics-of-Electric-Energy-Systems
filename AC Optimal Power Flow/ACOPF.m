function [Pgen] = ACOPF(caseName)
%ACOPF Summary of this function goes here
%   Detailed explanation goes here
clear; %open('case9');
caseName = case9;
%Y_bus_Mat = full(makeYbus(caseName,1));
obj_circ = loadcase(caseName);
initial_case = runpf(caseName);
%right_case=runopf(caseName);
%JJ = full(makeJac(caseName, 1));
[row,col] = size(obj_circ.bus); busNum = row; 
for i=1:1:busNum
    if obj_circ.bus(i,2)==3
        slackBus = obj_circ.bus(i,1);
    end
end
[genNum, genCol] = size(obj_circ.gen);
gen_P = zeros(busNum,1); % real power for each generator 
gen_Q = zeros(busNum,1); % reactive power for each generator 
load_P = zeros(busNum,1); % real power for each bus load  
load_Q = zeros(busNum,1); % reactive power for each bus load    
for i=1:1:genNum
    gen_P(i,1) = initial_case.gen(i,2);
end
for i=1:1:genNum
    gen_Q(i,1) = initial_case.gen(i,3);
end
for i=1:1:busNum
    load_P(i,1) = initial_case.bus(i,3);
end
for i=1:1:busNum
    load_Q(i,1) = initial_case.bus(i,4);
end
% find per unit for the generator and load
gen_P=gen_P/obj_circ.baseMVA; gen_Q=gen_Q/obj_circ.baseMVA;
load_P=load_P/obj_circ.baseMVA; load_Q=load_Q/obj_circ.baseMVA;

Y_bus = findYbus(caseName); %find Y bus
V_initial = initial_case.bus(:,8); % initial voltage 
theta_initial = initial_case.bus(:,9)/180*pi; % initial angle
Vtheta_initial = [];
for i=1:1:busNum
    theta = theta_initial(i,1); rho = V_initial(i,1);
    [realPart,imagPart] = pol2cart(theta,rho);
    Vtheta_initial(i,1) = realPart+imagPart*1j;
end

%set up initial objective function
costFunc = obj_circ.gencost(:,5:7);
[rowObj,colObj] = size(costFunc);
dF_dP = [];
for i=1:1:rowObj
    singleFunc = costFunc(i,:);
    derive_Cost = polyder(singleFunc);
    dF_dP = [dF_dP;derive_Cost];
end
% find the df/dp|p0 for each dF_dP
dF_dP_tot = [];
for i=1:1:rowObj
    dF_dP_one = dF_dP(i,:);
    dF_dP_P0 = polyval(dF_dP_one,gen_P(i,1));
    dF_dP_tot = [dF_dP_tot;dF_dP_P0];
end
% find the jaccobian of the with initial point
[J1,J2] = pflowjac(Y_bus,Vtheta_initial);
J11 = real(J1); J12 = real(J2);
J21 = imag(J1); J22 = imag(J2);
% find Aeq for the linprog
Aeq=findAeq(J11,J12,J21,J22,busNum);
% find initial calculated value
[P_cal1,Q_cal1]=nodeBalance(Vtheta_initial,Y_bus,busNum);
PQ_cal1=[P_cal1;Q_cal1];
% set up the linprog
initial_deltaP = (gen_P-load_P);
initial_deltaQ = (gen_Q-load_Q);

delta_PQ=[initial_deltaP;initial_deltaQ];
[row_dF_dP,col_dF_dP] = size(dF_dP_tot);
extra_row = busNum*2-row_dF_dP;
% set up the objective function
f=[dF_dP_tot;zeros(extra_row,1)];
f(4*busNum,1)=0;
A=[]; b=[]; 
beq=delta_PQ-PQ_cal1; 
LB_min1=zeros(2*busNum,1);
% initial LB
for i=1:1:2*busNum
    if 1<=i && i<=busNum
        genPmin_init=obj_circ.gen(:,10);
        genPmin_init(busNum,1)=0;
        LB_min1(i,1)=-pi/2;
    end
    if busNum<i && i<=2*busNum
        genQmin_init=obj_circ.gen(:,5);
        genQmin_init(busNum,1)=0;
        LB_min1(i,1)=0.95;   
    end
end
UB_max1=zeros(2*busNum,1);
% initial UB
for i=1:1:2*busNum
    if 1<=i && i<=busNum
        genPmax_init=obj_circ.gen(:,9);
        genPmax_init(busNum,1)=0;
        UB_max1(i,1)=pi/2;
    end
    if busNum<i && i<=2*busNum
        genQmax_init=obj_circ.gen(:,4);
        genQmax_init(busNum,1)=0;
        UB_max1(i,1)=1.07;   
    end
end

% change the bounds to per unit
genPmin_init=genPmin_init/obj_circ.baseMVA;
genQmin_init=genQmin_init/obj_circ.baseMVA;
LB_min1=[genPmin_init;genQmin_init;LB_min1];
LB_min2=[gen_P;gen_Q;theta_initial;V_initial];
genPmax_init=genPmax_init/obj_circ.baseMVA;
genQmax_init=genQmax_init/obj_circ.baseMVA;
LB_init=LB_min1-LB_min2; 
UB_max1=[genPmax_init;genQmax_init;UB_max1];
UB_max2=[gen_P;gen_Q;theta_initial;V_initial];
UB_init=UB_max1-UB_max2; 

% the slack bus cannot change
LB_init(2*busNum+slackBus,1)=0; LB_init(3*busNum+slackBus,1)=0; 
UB_init(2*busNum+slackBus,1)=0; UB_init(3*busNum+slackBus,1)=0; 

%need to fix
LB_init(10:12,1)=-inf; UB_init(10:12,1)=inf;
LB_init(3*busNum+1:(genNum+3*busNum),1)=0; 
UB_init((3*busNum+1):(genNum+3*busNum),1)=0;

x_next = linprog(f,[],[],Aeq,beq,LB_init,UB_init);

%initialize P,Q,V,theta
p_k=gen_P; q_k=gen_Q; theta_k=theta_initial; v_k=V_initial; 
% find initial delta P Q theta V
x_cur=[p_k;q_k;theta_k;v_k];

% iteration starts
while ~all(abs(x_next([1:2*busNum (3*busNum+1):4*busNum],1))<0.005)
    % new parameters
    %p_k1=x_cur(1:9,:); q_k1=x_cur(10:18,:);
    %x_k1=x_cur;   
    x_next = x_next*0.01;
    x_cur=x_cur+x_next;
    Vtheta_k2 = zeros(busNum,1); Vp_k2=zeros(busNum,1); theta_k2=zeros(busNum,1);
    for i=(2*busNum+1):1:3*busNum
        ptr_2 = i+busNum;
        theta=x_cur(i,1); 
        rho=x_cur(ptr_2,1);
        theta_k2(i-2*busNum,1)=theta;
        V_k2(ptr_2-3*busNum,1)=rho;
        [realPart,imagPart] = pol2cart(theta,rho);
        Vtheta_k2(i-2*busNum,1) = realPart+imagPart*1j;
    end
    % create new jaccobian based on the new V and theta calated
    [J1,J2] = pflowjac(Y_bus,Vtheta_k2);
    J11 = real(J1); J12 = real(J2);
    J21 = imag(J1); J22 = imag(J2);  
    Aeq=findAeq(J11,J12,J21,J22,busNum);
    
    % find the new P,Q for each bus
    P_k2=x_cur(1:busNum,1); Q_k2=x_cur((busNum+1):2*busNum,1); 
    
    % create new object equation
    dF_dP_tot = [];
    for i=1:1:rowObj
        dF_dP_one = dF_dP(i,:);
        dF_dP_P0 = polyval(dF_dP_one,P_k2(i,1));
        dF_dP_tot = [dF_dP_tot;dF_dP_P0];
    end
    
    [row_dF_dP,col_dF_dP] = size(dF_dP_tot);
    extra_row = busNum*2-row_dF_dP;
    % set up the objective function
    f=[dF_dP_tot;zeros(extra_row,1)];
    f(4*busNum,1)=0;
    % find P Q calculated
    [P_calk2,Q_calk2]=nodeBalance(Vtheta_k2,Y_bus,busNum);
    
    % find beq for linprog, new deltaP    
    beq=[P_k2;Q_k2]-[load_P;load_Q]-[P_calk2;Q_calk2];
    
    % find new LB
    LB_k2=LB_min1-x_cur;
    
    % find new UB
    UB_k2=UB_max1-x_cur;
    
    LB_k2(10:12,1)=-inf; UB_k2(10:12,1)=inf;
    LB_k2(10:12,1)=-inf; UB_k2(10:12,1)=inf;
    %LB_k2(2:3,1)=0; UB_k2(2:3,1)=0;
    LB_k2((3*busNum+1):(genNum+3*busNum),1)=0; 
    UB_k2((3*busNum+1):(genNum+3*busNum),1)=0;
    % set up linprog and find the delta P Q theta V for next iteration
    x_next = linprog(f,[],[],Aeq,beq,LB_k2,UB_k2);
end
Pgen=x_cur;

%Vtheta_initial_noslack = Vtheta_initial;
%Vtheta_initial_noslack(slackBus,1) = [];


%{
% no slack bus
J11(slackBus,:)=[];J11(:,slackBus)=[]; 
J12(slackBus,:)=[];J12(:,slackBus)=[];
J21(slackBus,:)=[];J21(:,slackBus)=[];
J22(slackBus,:)=[];J22(:,slackBus)=[];
%}


%V_noslack = V_initial;
%V_noslack(slackBus,:) = [];
%theta_noslack = zeros(busNum-1,1);%%%
%init_thetaV = [theta_noslack;V_noslack]; %theta and votlage without the slack
%delta_PQ = [initial_deltaP;initial_deltaQ];% Ps-Pl-P,Qs-Ql-Q, delta real and reactive 
%delta_PQ(slackBus,:) = [];% no slack P 
%delta_PQ(slackBus+genNum-1,:) = [];% no slack Q
%delta_PQ = delta_PQ/100; %normalize delta PQ
%delta_angV = J\delta_PQ;
%thetaV = init_thetaV+delta_angV;




%P_initial
%JJ = full(makeJac(caseName,1));
%error = JJ - J;
%error2 = Y_bus_Mat - Y_bus;

end

