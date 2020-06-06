function matrix_return = addSlope(matrix)
%ADDSLOPE Summary of this function goes here
%   Detailed explanation goes here
    [row, col] = size(matrix);
    for i = 1:1:row
        if i == row
            matrix(i, 3) = 0;
            matrix_return = matrix;
            return
        end
        [slope, b] = findLinear(matrix(i,2),matrix(i,1), matrix(i+1,2), matrix(i+1,1));
        matrix(i, 3) = slope;
    end
end

