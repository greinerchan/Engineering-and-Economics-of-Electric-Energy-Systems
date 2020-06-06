function [result] = ACPF_Partb(caseFile)
%ACOPF Summary of this function goes here
%%
% initial the Data set
%Y_bus_Mat = full(makeYbus(caseFile,1));
origin_case = caseFile;
obj_circ = origin_case;
obj_circ = ACPF_Parta(obj_circ);
genList = obj_circ.gen(:,1);
%%
% find PV bus, PQ bus and slack bus
%               PQ bus          = 1
%               PV bus          = 2
%               reference bus   = 3
Slack = find(obj_circ.bus(:,2) == 3);
Slack_Row = find(obj_circ.gen(:,1) == Slack);
PV = find(obj_circ.bus(:,2) == 2);
PQ = find(obj_circ.bus(:,2) == 1);
[vioMax,vioMin] = findViolate(obj_circ);
iter = 1;
%%
while length(vioMax) > 0 || length(vioMin) > 0
    obj_circ_copy = origin_case;
    % slack bus ignore the reactive power limits, so get rid of the slack
    SlackRow1 = find(vioMax == Slack_Row); 
    SlackRow2 = find(vioMin == Slack_Row);
    vioMax(SlackRow1,:) = [];    vioMin(SlackRow2,:) = [];
    % change the PV bus to PQ bus and close the generator
    PQ = [PQ;vioMax;vioMin]; obj_circ.gen(vioMax,8) = 0; 
    obj_circ_copy.gen(vioMin,8) = 0;
    % set the output to the bounds
    obj_circ_copy.gen(vioMax,3) = obj_circ.gen(vioMax,4);
    obj_circ_copy.gen(vioMin,3) = obj_circ.gen(vioMin,5);
    % change the bus to the PQ
    obj_circ_copy.bus(genList(vioMax,1),2) = 1;
    obj_circ_copy.bus(genList(vioMin,1),2) = 1;
    obj_circ = ACPF_Parta(obj_circ_copy);
    % after run vinilla ACPF, find which gen violate the reactive limits
    [vioMax,vioMin] = findViolate(obj_circ);
    iter = iter + 1;
end
result = obj_circ;
% run power 
%{
while 1
    % check if Q violate, if violate, PV to PQ, set Pcal and Qcal to limit
 for i = 1:1:genNum
        if genList(i,1) == Slack
            continue;
        end
        len = length(temp_PQ); temp_PQ_copy = temp_PQ;
        for n = 1:1:len
            m = temp_PQ(n,1);
            % change PV back to PQ
            if Q_cal(m,1) < genQ_max(m,1) && ...
                    Q_cal(m,1) > genQ_min(m,1)
                PV = [PV;m];
                PV = unique(PV);
                row_PQtemp = find(temp_PQ_copy == m);
                temp_PQ_copy(row_PQtemp,:) = [];
                row_PQ = find(PQ == m);
                PQ(row_PQ,:) = [];
                flag = 1;
            end
            if n == len
                temp_PQ = temp_PQ_copy;
            end
        end
        % violate the upper bound, change to PQ
        if Q_cal(genList(i,1),1) > genQ_max(i,1)
            fprintf('reactive power violates upper bounds for generator %d\n',...
                genList(i,1));
            Q_cal(genList(i,1),1) = genQ_max(i,1);
            PQ = [PQ;genList(i,1)];
            PQ = unique(PQ);
            temp_PQ = [temp_PQ;genList(i,1)];
            temp_PQ = unique(temp_PQ);
            row_PV = find(PV == genList(i,1));
            PV(row_PV,:) = []; 
            flag = 1;
        end
        % violate the lower bound, change to PQ
        if Q_cal(genList(i,1),1) < genQ_min(i,1) 
            fprintf('reactive power violates lower bounds for generator %d\n',...
                genList(i,1));
            Q_cal(genList(i,1),1) = genQ_min(i,1);
            PQ = [PQ;genList(i,1)];
            PQ = unique(PQ);
            temp_PQ = [temp_PQ;genList(i,1)];
            temp_PQ = unique(temp_PQ);
            row_PV = find(PV == genList(i,1));
            PV(row_PV,:) = [];
            flag = 1;
        end
        if i == genNum && flag == 1
            % get new V and theta
            P_fm = P_cal(genList,:); Q_fm = Q_cal(genList,:);
            obj_circ_copy.gen(:,2) = P_fm*baseMVA;
            obj_circ_copy.gen(:,3) = Q_fm*baseMVA;
            obj_circ_copy.bus(:,8) = ThetaV_Cur(busNum+1:end,1);
            obj_circ_copy.bus(:,9) = ThetaV_Cur(1:busNum,1);
            obj_circ_copy = updateBusType(obj_circ_copy,PV,PQ);
            %ThetaV_pf = ACPF_Parta(obj_circ_copy);
            aaa = runpf(obj_circ_copy);
            ThetaV_pf = [(aaa.bus(:,9)/180*pi);aaa.bus(:,8)];
            Vtheta_Cur = VThetaComplex(ThetaV_pf, busNum);
            flag = 0;
        end
    end
end
%}


