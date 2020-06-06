function [reduceJac] = reduceJac(J1,J2,Slack,PV,PQ)
%REDUCEJAC Summary of this function goes here
%   Detailed explanation goes here
%%{
PV_Slack = [PV;Slack];
PQ_Slack = [PQ;Slack];
J11 = real(J1); J12 = real(J2);
J21 = imag(J1); J22 = imag(J2);
%fullJac = [J11,J12;J21,J22];
%fullJacError = fullJac - DDD;
J11(Slack,:) = []; J11(:,Slack) = []; 
J12(PV_Slack.',:) = []; J12(:,Slack) = [];
J21(:,PV_Slack.') = []; J21(Slack,:) = [];
J22(:,PV_Slack.') = []; J22(PV_Slack.',:) = [];
reduceJac = [J11,J12.';J21.',J22];
%}
%{
    j11 = real(J1([pv; pq], [pv; pq]));
    j12 = real(J2([pv; pq], pq));
    j21 = imag(J1(pq, [pv; pq]));
    j22 = imag(J2(pq, pq));
    J = [   j11 j12;
            j21 j22;    ];
        reduceJac = J;

end
%}

