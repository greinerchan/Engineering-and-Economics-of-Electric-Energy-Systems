function [population] = initPop(pop,mpc)

% initial population 
% find feasible range of each genration

for i = 1:1:pop
    feasibleGen = randomGen(mpc);
    % update the mpc
    feasibleGen = ACPF(feasibleGen);
    flag = ~isFeasible(feasibleGen);
    while flag   % only generate feasble genes
        feasibleGen = randomGen(mpc);
        if ~isFeasible(feasibleGen)
            flag = 1;
        else
            flag = 0;
        end
    end
    population.chromosomes(i).gene = feasibleGen;
end


end

