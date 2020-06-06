function bool = isAngViolate(mpc)
% find angle violtation
angle = mpc.bus(:,9); angle_min = -90;
angle_max = 90;
angle_vioMax = angle(angle > angle_max);
angle_vioMaxTotal = abs(sum(angle_vioMax - angle_max));

angle_vioMin = angle(angle < angle_min);
angle_vioMinTotal = abs(sum(angle_vioMin - angle_min));

angle_vioTotal = angle_vioMaxTotal + angle_vioMinTotal;

if angle_vioTotal ~= 0
    bool = 1;
else 
    bool = 0;
end
end

