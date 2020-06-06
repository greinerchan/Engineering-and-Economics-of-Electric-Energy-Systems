function [Y_bus] = findYbus(caseName)
%FINDYBUS Summary of this function goes here
%   Detailed explanation goes here clear
%caseName = case5;
obj_circ = loadcase(caseName);
from_to = obj_circ.branch(:,1:2);
Z =  obj_circ.branch(:,3)+obj_circ.branch(:,4)*1j;
Z_line = [from_to,Z];
b_line = [from_to,obj_circ.branch(:,5)];

%a = full(makeYbus(caseName));
[row,col] = size(obj_circ.bus); busNum = row;
[row2,col2] = size(obj_circ.branch);
X = Inf(row);
for i=1:1:row2
    X(Z_line(i,1),Z_line(i,2)) = Z_line(i,3);
    X(Z_line(i,2),Z_line(i,1)) = Z_line(i,3);
end
Y_no_dig = -1./X;
%rror2 = Y_no_dig - a;
% add diagonal addmitance
Y_other = 0;
for i = 1:1:row
    for j = 1:1:row
        if i == j
            for m=1:row
                if m ~= i
                    Y_other = Y_other + Y_no_dig(i,m);
                end
            end
            Y_no_dig(i,i) = -Y_other - Y_no_dig(i,i);
            Y_other = 0;
        end
    end
end
Y_bus = Y_no_dig;
%error = Y_bus - a;
% add shunt reactance
b_shunt = zeros(busNum);
b_shunt_v = zeros(row2,1);
for i=1:1:row2
    b_shunt_v(b_line(i,1),1) = b_shunt_v(b_line(i,1),1) + b_line(i,3);
    b_shunt_v(b_line(i,2),1) = b_shunt_v(b_line(i,2),1) + b_line(i,3);
end
b_shunt_v = b_shunt_v/2*1i;
for i = 1:1:busNum
    b_shunt(i,i) = b_shunt_v(i,1);
end
Y_bus = Y_bus + b_shunt;
end

