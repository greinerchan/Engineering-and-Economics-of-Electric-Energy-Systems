function bool = isQViolate(mpc)
% find if the reative power exceed the limitation
Qmax = mpc.gen(:,4); Qmin = mpc.gen(:,5);
Qg = mpc.gen(:,3);
numGen = length(Qg);
bool = 0;
for i = 1:1:numGen
    if Qg(i) > Qmax(i) || Qg(i) < Qmin(i)
        bool = 1;
    end
end
end

