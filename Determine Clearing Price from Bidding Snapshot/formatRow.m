function matrix_return = formatRow(rowFormat)
%FORMATMATRIX Summary of this function goes here
%   Detailed explanation goes here
    [row,col] = size(rowFormat);
    matrix_return = zeros(col/2, 3);
    for i = 1:1:(col/2)
        matrix_return(i,1) = rowFormat(1,i);
        matrix_return(i,2) = rowFormat(1,i+10);
    end
end

