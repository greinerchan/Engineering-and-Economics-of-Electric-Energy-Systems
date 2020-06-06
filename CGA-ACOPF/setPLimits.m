function mpc2 = setPLimits(mpc)
%SETPLIMITS Pg is not in limit, set to the limit
Pmax = mpc.gen(:,9); Pmin = mpc.gen(:,10);
Pg = mpc.gen(:,2);  mpc2 = mpc;
numGen = length(Pg);

for i = 1:1:numGen
    if Pg(i) > Pmax(i)
        Pg(i) = Pmax(i);
    end
    if Pg(i) < Pmin(i)
        Pg(i) = Pmin(i);
    end
end

mpc2.gen(:,2) = Pg;

end

