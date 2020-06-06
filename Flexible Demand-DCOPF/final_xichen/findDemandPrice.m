function demandPrice = findDemandPrice(mpc,result)
% find the demand price for extra unit at each load
busNum = length(mpc.bus(:,1));
a = zeros(busNum,1); b = zeros(busNum,1); c = zeros(busNum,1);
am = mpc.load(:,5);
bm = mpc.load(:,6);
cm = mpc.load(:,7);

loadBus = mpc.load(:,1); numLoad = length(loadBus);
loadM = zeros(busNum,1);
for i = 1:1:numLoad
    a(loadBus(i)) = am(loadBus == loadBus(i));
    b(loadBus(i)) = bm(loadBus == loadBus(i));
    c(loadBus(i)) = cm(loadBus == loadBus(i));
    loadM(loadBus(i)) = result(busNum + loadBus(i));
end
p = [a,b,c];

demandPrice = zeros(busNum,1);
for i = 1:1:busNum
    curBus = p(i,:);
    p_der = polyder(curBus);
    curBusPrice = polyval(p_der,loadM(i));
    demandPrice(i) = curBusPrice;
end

end

