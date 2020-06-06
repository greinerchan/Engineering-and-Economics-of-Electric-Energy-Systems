function [fortmat_case] = numFormat(my_case,mpc)
% convert per unit to MVA, and radian to degree

rowNum = size(mpc.bus,1);
fortmat_case = [my_case(1:rowNum,1) .* mpc.baseMVA;...
    my_case(rowNum+1:2*rowNum,1) .* ...
    mpc.baseMVA;my_case(2*rowNum+1:3*rowNum,1) ./ pi .* 180];
end

