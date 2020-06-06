function [child1,child2] = crossover(parent1,parent2,Pc)

%CROSSOVER use the parents from last step to crossover, and produce two
%offsprings, child 1 and child 2 are chromosomes

child1 = parent1; child2 = parent2;
numGen = length(parent1.gene.gen(:,1));
child1_gen = zeros(1,numGen);
child2_gen = zeros(1,numGen);

p1_gen = parent1.gene.gen(:,2);
p2_gen = parent2.gene.gen(:,2);
UB = parent1.gene.gen(:,9);
LB = parent1.gene.gen(:,10);

for k = 1 : numGen
    beta = rand();
    child1_gen(k) = beta .* p1_gen(k) + (1-beta) * p2_gen(k); 
    child2_gen(k) = (1-beta) .* p1_gen(k) + beta * p1_gen(k);
    
    if child1_gen(k) > UB(k)
        child1_gen(k)  =  UB(k);
    end
    if child1_gen < LB(k)
        child1_gen = LB(k);
    end
    if child2_gen(k) > UB(k)
        child2_gen(k)  =  UB(k);
    end
    if child2_gen < LB(k)
        child2_gen = LB(k);
    end
end

child1.gene.gen(:,2) = child1_gen;
child2.gene.gen(:,2) = child2_gen;

cross = rand();

if cross <= Pc
    child1 = child1;
else
    child1 = parent1;
end

if cross <= Pc
    child2 = child2;
else
    child2 = parent2;
end

end

