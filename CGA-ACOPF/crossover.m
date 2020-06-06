function [child1,child2] = crossover(parent1,parent2,Pc)

%CROSSOVER use the parents from last step to crossover, and produce two
%offsprings, child 1 and child 2 are chromosomes


if (parent1.fitness >= parent2.fitness)
    x1 = parent1;
    x2 = parent2;
else
    x1 = parent2;
    x2 = parent1;
end

n = 1;

child1 = parent1; child2 = parent2;
e = rand();

x1_gen = x1.gene.gen(:,2);
x2_gen = x2.gene.gen(:,2);

% flag = 1, while loop will continue
flag = 1; 
while flag
    tau = (x1.fitness / (x1.fitness + x2.fitness))^(e^(n-1));
    x1_child = tau * x1_gen + (1 - tau) * x2_gen;
    x2_child = tau * x1_gen - (1 - tau) * x2_gen;
    child1.gene.gen(:,2) = x1_child;
    child2.gene.gen(:,2) = x2_child;
    if (isFeasible(child1.gene) && isFeasible(child2.gene)) || n >= 50
        flag = 0;
        child1.gene = randomGen(child1.gene);
        child2.gene = randomGen(child2.gene);
    end
    n = n + 1;
end

cross = rand(2,1);

if cross(1) <= Pc
    child1 = child1;
else
    child1 = parent1;
end

if cross(2) <= Pc
    child2 = child2;
else
    child2 = parent2;
end

end

