function bool = isLineViolate(mpc)
% find line power violation
[lineFlow, losses] = findLineFlow(mpc);
lineMax = mpc.branch(:,6);
violation = lineFlow > lineMax;
violations = find(violation == 1);
if length(violations) ~= 0
    bool = 1;
else
    bool = 0;
end
end

