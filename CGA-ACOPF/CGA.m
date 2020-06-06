function [best_mpc,cost] = CGA(pop,Pc,Pm,Er,maxGen,mpc)
%CGA the main function to combine all the functions to work out best 
% generation

% initialization the feasible population

[population] = initPop(pop,mpc);

for i = 1:1:pop
    population.chromosomes(i).gene = ACPF(population.chromosomes(i).gene);
    population.chromosomes(i).fitness = fitness(population.chromosomes(i).gene);
end
%generation = 1;
%% plot
v_plot = zeros(1,maxGen);
afitness = [population.chromosomes(:).fitness];
[v_plot(1),~] = max(afitness);
%%

for generation = 2:1:maxGen
    
    disp(['Generation #', num2str(generation)]);
    % find the fitness value and new parameter for the mpc
    for i = 1:1:pop
        population.chromosomes(i).gene = ACPF(population.chromosomes(i).gene);
        population.chromosomes(i).fitness = fitness(population.chromosomes(i).gene);
    end
    
    for j = 1:2:pop
        % 1, selection
        [parent1,parent2] = selection(population);
        
        % 2, crossover
        [child1,child2] = crossover(parent1,parent2,Pc);
        
        % 3, mutation
        child1 = mutation(child1,Pm);
        child2 = mutation(child2,Pm);
        
        % copy the new solution to next generation
        population_next.chromosomes(j) = child1;
        population_next.chromosomes(j+1) = child2;
    end
    
    % find the fitness value and update the parameters again 
    for i = 1:1:pop
        population_next.chromosomes(i).gene = ACPF(population_next.chromosomes(i).gene);
        population_next.chromosomes(i).fitness = fitness(population_next.chromosomes(i).gene);
    end
    
    % 4, elitism, keep best genes from the current population
    newPop = elitism(population,population_next,Er);
    
    population = newPop;
    
    %%
    afitness = [population.chromosomes(:).fitness];
    [v_plot(generation),~] = max(afitness);
    %%
end

% find the fitness value
for i = 1:1:pop
    population.chromosomes(i).gene = ACPF(population.chromosomes(i).gene);
    population.chromosomes(i).fitness = fitness(population.chromosomes(i).gene);
end

[rankedFit, rankedID] = sort([population.chromosomes(:).fitness], 'descend');
best_mpc = population.chromosomes(rankedID(1)).gene;
cost = findFuelCost(best_mpc);

%%
figure;
x = 1:maxGen;
y = v_plot;

plot(x,y);
xlabel('Generation')
ylabel('fitness')
%%

end

