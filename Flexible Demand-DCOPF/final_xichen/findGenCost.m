function genCost = findGenCost(mpc,result)
% find generation cost
genNum = length(mpc.gencost(:,1)); genBus = mpc.gen(:,1);
a = mpc.gencost(:,5);
b = mpc.gencost(:,6);
c = mpc.gencost(:,7);
genCost = 0;

for i = 1:1:genNum
    genCost = genCost + a(genBus == genBus(i)) * (result(genBus(i)))^2 ... 
        + result(genBus(i)) * b(genBus == genBus(i)) + c(genBus == genBus(i));        
end

end

