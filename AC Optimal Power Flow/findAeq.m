function [editedAeq] = findAeq(J11,J12,J21,J22,busNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
J = [J11,J12;J21,J22];
onesV=zeros(1,2*busNum)-1;
Aeq=[diag(onesV),J];
editedAeq = Aeq;

%{
J11(slackBus,:)=0;J11(:,slackBus)=0; 
J12(slackBus,:)=0;J12(:,slackBus)=0;
J21(slackBus,:)=0;J21(:,slackBus)=0;
J22(slackBus,:)=0;J22(:,slackBus)=0;
J11(slackBus,slackBus)=1; J12(slackBus,slackBus)=1;
J21(slackBus,slackBus)=1; J22(slackBus,slackBus)=1;
%}
%J(slackBus,:)=0;J(:,slackBus)=0; 
%J(slackBus,slackBus)=1;

end

