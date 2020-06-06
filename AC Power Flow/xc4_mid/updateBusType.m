function [caseStructs] = updateBusType(caseFile,PV,PQ)
%UPDATEBUSTYOE Summary of this function goes here
%   Detailed explanation goes here
for i = 1:1:length(PV)
    caseFile.bus(PV(i,1),2) = 2;  
end
for i = 1:1:length(PQ)
    caseFile.bus(PQ(i,1),2) = 1;  
end
caseStructs = caseFile;
