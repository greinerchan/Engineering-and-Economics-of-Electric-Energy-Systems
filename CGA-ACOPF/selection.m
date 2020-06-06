function [parent1,parent2] = selection(population)

% select parents to crossover
% parent1,parent2 are chromosomes
numPop = length(population.chromosomes(:));
tempPopulation = population;

% normalize the fitness to create roulette
normFit = [population.chromosomes(:).fitness] ./ sum([population.chromosomes(:).fitness]);

[rankedFitness, rankedID] = sort(normFit, 'descend');
% copy the current population
for i = 1:1:numPop
    tempPopulation.chromosomes(i).gene = population.chromosomes(rankedID(i)).gene;
    tempPopulation.chromosomes(i).fitness = population.chromosomes(rankedID(i)).fitness;
    tempPopulation.chromosomes(i).normFit = normFit(rankedID(i));
end

roulette = zeros(1, numPop);

for i = 1:1:numPop
    for j = i:1:numPop
        roulette(i) = roulette(i) + tempPopulation.chromosomes(j).normFit;
    end
end

% see where the first parent locate by check the rouletteVal
% example: roulette = [1 0.6 0.3 0.1 0] and rouletteVal = 0.8, it is
% between 1 and 0.6, so the second person win the price
rouletteVal = rand();
p1 = numPop;
for i = 1:1:numPop
    if rouletteVal > roulette(i)
        p1 = i - 1;
        break;
    end
end

% flag for if they have same id, which p1 == p2
p2 = numPop;
while p1 == p2
    rouletteVal = rand();
    for i = 1:1:numPop
        if rouletteVal > roulette(i)
            p2 = i - 1;
            if p2 ~= p1
                break;
            end
        end 
    end
end
parent1 = tempPopulation.chromosomes(p1);
parent2 = tempPopulation.chromosomes(p2);
end



