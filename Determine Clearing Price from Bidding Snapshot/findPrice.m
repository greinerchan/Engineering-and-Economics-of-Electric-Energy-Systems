function clearingPrice = findPrice(supply,demand)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % find the first place bigger than demand
    [nrow, ncol] = size(supply);
    if demand >= 1566615
        fprintf('not valid input\n');
        return
    end
    if demand <= 0 
        fprintf('not valid input\n');
        return
    end
   if 0 < demand && demand <= supply(1,1)
        clearingPrice = supply(1,2);
        return
    end
    row = 0; col = 0;
    for i=1:1:nrow
        if supply(i,1) >= demand
            row = i;
            col = 1;
            break
        end
    end
    slope=supply(row-1,3);
    if supply(row,col) == demand
        clearingPrice = supply(row,2);
    % if slope is invalid
    elseif slope == inf || isnan(slope) || slope == 0
        clearingPrice = supply(row,2);
    else
    % slope is valid
    p = supply(row-1,1);
    q = supply(row-1,2);
    b = q - slope*p;
    clearingPrice = (demand-b)/slope;
    end
end

