function [vioMax,vioMin] = findViolate(obj_circ)
%FINDVIOLATE Summary of this function goes here
%   Detailed explanation goes here
vioMax = find( obj_circ.gen(:, 8) == 1  & ...
      obj_circ.gen(:, 3) > obj_circ.gen(:, 4));
vioMin = find( obj_circ.gen(:, 8) == 1  & ...
      obj_circ.gen(:, 3) < obj_circ.gen(:, 5));
end

