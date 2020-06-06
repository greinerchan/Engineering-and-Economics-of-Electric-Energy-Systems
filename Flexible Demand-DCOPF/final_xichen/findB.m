function [B_bus] = findB(mpc)
branch = mpc.branch; 
x = branch(:,4);
b = 1./x;
from = branch(:,1);
to = branch(:,2);
mpc_bus = mpc.bus;
busNum = size(mpc_bus,1);

br = size(branch,1);

from_red = []; to_red = []; branch_red = []; bus_red = [];
% find absolute location the "from" bus locates 
for i = 1:1:br
    from_cur = find(mpc_bus(:,1) == from(i));
    from_red = [from_red;from_cur];
end
% find absolute location the "to" bus locates 
for i = 1:1:br
    to_cur = find(mpc_bus(:,1) == to(i));
    to_red = [to_red;to_cur];
end
% find absolute location bus locates 
for i = 1:1:busNum
    bus_cur = find(mpc_bus(:,1) == mpc_bus(i,1));
    bus_red = [bus_red;bus_cur];
end

B = zeros(busNum,busNum);

for k = 1:1:br
    B(from_red(k),to_red(k)) = B(from_red(k),to_red(k)) - b(k);
    B(to_red(k),from_red(k)) = B(from_red(k),to_red(k));
end

% add diagonal stuff
for bus = 1:1:busNum
    for brc = 1:1:br
         if from_red(brc) == bus                
             B(bus,bus) = B(bus,bus) + b(brc);
         elseif to_red(brc) == bus
             B(bus,bus) = B(bus,bus) + b(brc);
         end
     end
end
B_bus = B;
end

%{

for i=1:1:br
    if tap(i) ~= 0
        X(from_red(i),to_red(i)) = x(i) * (tap(i) * exp(-1j*tap_ang(i)));
        X(to_red(i),from_red(i)) = x(i) * (tap(i) * exp(1j*tap_ang(i)));
    end
    if tap(i) == 0
        X(from_red(i),to_red(i)) = x(i);
        X(to_red(i),from_red(i)) = x(i);
    end
end
%X = Inf(busNum,busNum); 

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%clear;
%caseName = IEEE_RTS_96;
%mpc = loadcase(caseName);
%}
