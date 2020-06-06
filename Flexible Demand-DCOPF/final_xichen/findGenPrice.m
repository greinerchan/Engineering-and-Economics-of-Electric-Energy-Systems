function genPrice = findGenPrice(mpc,result)
% find the demand price for extra unit at each load
busNum = length(mpc.bus(:,1));
a = zeros(busNum,1); b = zeros(busNum,1); c = zeros(busNum,1);
am = mpc.gencost(:,5);
bm = mpc.gencost(:,6);
cm = mpc.gencost(:,7);

genBus = mpc.gen(:,1); numGen = length(genBus);
genM = zeros(busNum,1);
for i = 1:1:numGen
    a(genBus(i)) = am(genBus == genBus(i));
    b(genBus(i)) = bm(genBus == genBus(i));
    c(genBus(i)) = cm(genBus == genBus(i));
    genM(genBus(i)) = result(genBus(i));
end
p = [a,b,c];

genPrice = zeros(busNum,1);
for i = 1:1:busNum
    curBus = p(i,:);
    p_der = polyder(curBus);
    curGenPrice = polyval(p_der,genM(i));
    genPrice(i) = curGenPrice;
end

end

