function [Y_bus] = findYbus(obj_circ)
%FINDYBUS Summary of this function goes here
%   Detailed explanation goes here clear
%caseName = case5;

%obj_circ = loadcase(caseName);
%b = linedata(:,5); 
%a = full(makeYbus(caseName));
%%{
from_to = obj_circ.branch(:,1:2); baseMVA = obj_circ.baseMVA;
Z =  obj_circ.branch(:,3)+obj_circ.branch(:,4)*1j;
Z_line = [from_to,Z];
b_line = [from_to,obj_circ.branch(:,5)];
tap = obj_circ.branch(:,9); tap_ang = obj_circ.branch(:,10)/180*pi;
[busN,col] = size(obj_circ.bus); busNum = busN;
[br,col2] = size(obj_circ.branch);
X = Inf(busN); z = obj_circ.branch(:,3) + obj_circ.branch(:,4) * 1j;
y = 1./z; B_s = obj_circ.bus(:,6) * 1j; G_s = obj_circ.bus(:,5);
branch = obj_circ.branch; 

for i=1:1:br
    if tap(i) ~= 0
        X(Z_line(i,1),Z_line(i,2)) = Z_line(i,3) * (tap(i) * exp(-1j*tap_ang(i)));
        X(Z_line(i,2),Z_line(i,1)) = Z_line(i,3) * (tap(i) * exp(1j*tap_ang(i)));
    end
    if tap(i) == 0
        X(Z_line(i,1),Z_line(i,2)) = Z_line(i,3);
        X(Z_line(i,2),Z_line(i,1)) = Z_line(i,3);
    end
end


Y_no_dig = -1./X;
% add diagonal stuff
for bus = 1:1:busN
    for brc = 1:1:br
         if branch(brc,1) == bus
             if tap(brc) ~= 0
                  Y_no_dig(bus,bus) = Y_no_dig(bus,bus) + ...
                      y(brc) ./ (tap(brc))^2;
             end
             if tap(brc) == 0                  
                  Y_no_dig(bus,bus) = Y_no_dig(bus,bus) + y(brc);
             end
         elseif branch(brc,2) == bus
             Y_no_dig(bus,bus) = Y_no_dig(bus,bus) + y(brc);
         end
     end
end
Y_bus = Y_no_dig;
%error = Y_bus - a;
% add shunt reactance
b_shunt = zeros(busNum);
b_shunt_v = zeros(busNum,1);
for i=1:1:br
    b_shunt_v(b_line(i,1),1) = b_shunt_v(b_line(i,1),1) + b_line(i,3);
    b_shunt_v(b_line(i,2),1) = b_shunt_v(b_line(i,2),1) + b_line(i,3);
end
b_shunt_v = b_shunt_v/2*1i;
for i = 1:1:busNum
    b_shunt(i,i) = b_shunt_v(i,1) + (G_s(i) + B_s(i)) ./ baseMVA;
end
Y_bus = Y_bus + b_shunt;
end


