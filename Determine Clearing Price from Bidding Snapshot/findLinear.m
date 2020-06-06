function [slope, b] = findLinear(Xa, Ya, Xb, Yb)
    slope = (Yb-Ya)/(Xb-Xa);
    b = Ya - slope*Xa;
end

