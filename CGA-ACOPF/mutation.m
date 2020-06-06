function [chromosome] = mutation(chromosome,Pm)
%MUTATION mutation the chromosome, random generator

mul = rand();
gene = chromosome.gene;
if mul < Pm
    feasibleGen = randomGen(gene);
    while ~isFeasible(feasibleGen)   % only generate feasible genes
        feasibleGen = randomGen(gene);
    end
    chromosome.gene = feasibleGen;
end

end

