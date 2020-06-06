function demandCost = findDemandCost(mpc,result)
% find the total demand cost for the flexible load 
loadBus = mpc.load(:,1); %load = mpc.load(:,2); 
a = mpc.load(:,5); b = mpc.load(:,6); c = mpc.load(:,7);
numLoad = length(loadBus); numGen = length(mpc.bus(:,1));

demandCost = 0;
for i = 1:1:numLoad
    demandCost = demandCost + a(loadBus == loadBus(i)) * result(numGen ...
        + loadBus(i))^2 + b(loadBus == loadBus(i)) * result(numGen ... 
        + loadBus(i)) + c(loadBus == loadBus(i));
end
end

