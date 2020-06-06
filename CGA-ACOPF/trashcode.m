
clear;
error = 0;     mpc = loadcase(case9);

    aa = ACPF(mpc);
    bb = runpf(mpc);
    cc = runopf(mpc);
    tcheck = isFeasible(aa);
    check3 = isQViolate(mpc);
    [lineflow,losses] = findLineFlow(aa);
    check = isVoltViolate(aa);
    check2 = isAngViolate(aa);
    
for i = 1:1:1000
    %disp(i);
    mpc = randomGen(mpc);
    aa = ACPF(mpc);
    disp(fitness(aa));
    %bb = runpf(mpc);
    %error = error + aa.gen(:,2) - bb.gen(:,2);
end

clear;
mpc = loadcase(case9);
[population] = initPop(100,mpc);

for i = 1:1:100
    population.chromosomes(i).fitness = fitness(population.chromosomes(i).gene);
end

[parent1,parent2] = selection(population);
[child1,child2] = crossover(mpc,parent1,parent2,0.1);