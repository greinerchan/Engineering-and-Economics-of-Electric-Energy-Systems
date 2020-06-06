function newPop = elitism(prevPop,curPop,Er)
%ELITISM % some best genes must remain, no thing will change
numPop = length(curPop.chromosomes);
elites = round(Er * numPop);
[rankedFit, rankedID] = sort([prevPop.chromosomes(:).fitness], 'descend');
% copy and paste elites to our new population
for i = 1:1:elites
    newPop.chromosomes(i).gene = prevPop.chromosomes(rankedID(i)).gene;
    newPop.chromosomes(i).fitness = prevPop.chromosomes(rankedID(i)).fitness;
end
% copy and paste the rest population to our new population
for j = (elites+1):1:numPop
    newPop.chromosomes(j).gene = curPop.chromosomes(j).gene;
    newPop.chromosomes(j).fitness = curPop.chromosomes(j).fitness;
end
end

