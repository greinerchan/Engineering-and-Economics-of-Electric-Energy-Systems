function bool = isPViolate(mpc)
% find if the reative power exceed the limitation
Pmax = mpc.gen(:,9); Pmin = mpc.gen(:,10);
Pg = mpc.gen(:,2);
numGen = length(Pg);
bool = 0;
for i = 1:1:numGen
    if Pg(i) > Pmax(i) || Pg(i) < Pmin(i)
        bool = 1;
    end
end
end

