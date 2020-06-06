function str = printResult(mpc,result,caseName)

genNum = length(mpc.gen(:,1)); busNum = length(mpc.bus(:,1));
genBus = mpc.gen(:,1); loadNum = length(mpc.load(:,1)); 
loadBus = mpc.load(:,1);

gencost = findGenCost(mpc, result);
demandCost = findDemandCost(mpc,result);
obj_val = gencost + demandCost;
demandPrice = findDemandPrice(mpc,result);
genPrice = findGenPrice(mpc,result);

cc = strcat('current case is:',caseName,'\n');
fprintf(cc);
fprintf('The generation cost is $%f each hour\n', gencost);
fprintf('The demand cost is $%f each hour\n', demandCost);
fprintf('The total cost is $%f each hour\n', obj_val);

for i= 1:1:genNum  
    fprintf('Generator %d output is %f MW, the price is $%f/MW\n', ... 
        genBus(i),result(genBus(i)),genPrice(genBus(i)));
end

for i= 1:1:loadNum  
    fprintf('Load %d output is %f MW, the price is $%f/MW\n', ... 
        loadBus(i),result(busNum + loadBus(i)),-demandPrice(loadBus(i)));
end
fprintf('\n');
str = 1;
end

