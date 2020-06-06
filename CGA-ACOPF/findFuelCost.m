function costTotal = findFuelCost(mpc)
%FINDFUELCOST Summary of this function goes here
%   Detailed explanation goes here
% find generator costs
Pg = mpc.gen(:,2); 
genFunc = mpc.gencost(:,5:7);
numGen = length(Pg);
costTotal = 0;
for i= 1:1:numGen
    genCost = polyval(genFunc(i,:),Pg(i));
    costTotal = costTotal + genCost;
end
end

