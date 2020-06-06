function [y] = fitness(mpc)
% find fitness value for each chromosome
% weight for excess P and Q, and the violation of line limits
W1 = 10; W2 = 0; W3 = 35;
% find generator costs
Pg = mpc.gen(:,2); Pd = mpc.gen(:,3); Qd = mpc.gen(:,4);
genFunc = mpc.gencost(:,5:7);
numGen = length(Pg);
y1 = 0; costTotal = 0;
for i= 1:1:numGen
    genCost = polyval(genFunc(i,:),Pg(i));
    costTotal = costTotal + genCost;
end

[lineFlow, losses] = findLineFlow(mpc);
lineMax = mpc.branch(:,6);

Ploss = sum(real(losses));
Qloss = sum(imag(losses));

Pextra = sum(Pg) - Ploss - sum(Pd);
Qextra = sum(Pg) - Qloss - sum(Qd);

lineViolation = lineMax - lineFlow;
numBranch = length(lineViolation);
for i = 1:1:numBranch
    if lineViolation(i) > 0
        lineViolation(i) = 0;
    end
end
lineViolation = sum(abs(lineViolation));


y1 = costTotal + W1 * abs(Pextra) + W2 * abs(Qextra) + W3 * lineViolation;

y = 1/(1+y1);
end

