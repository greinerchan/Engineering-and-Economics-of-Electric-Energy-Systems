function matrix_return = addNextRow(cur,next)
%COMBINETWO Summary of this function goes here
%   Detailed explanation goes here
    m_price = cat(1, cur(:,2), next(:,2)); 
    m_price = sortrows(m_price,1);
    [row1, col1] = size(m_price);
    cur = sortrows(cur,3);
    next = sortrows(next,3);
    cur = cur(all(~isnan(cur),2),:);    
    next = next(all(~isnan(next),2),:);   
    matrix_return = zeros(row1,3);
    [row, col] = size(cur);
    [row2,col2] = size(next);
    for j = 1:1:row
        for i = 1:1:row2
            if next(i,2) > cur(j,2)
                slope1 = cur(j,3);
                slope2 = next(i,3);
                slope_t = slope1+slope2;
                q_cur_line = slope1*next(i,2) + cur(j,1) - slope1*cur(j,2);
                q_next_line = slope2*next(i,2) + next(i,1) - slope2*next(i,2);
                Q_t = q_cur_line+q_next_line;
                matrix_return(j,1) = Q_t;
                matrix_return(j,2) = next(i,1);
                matrix_return(j,3) = slope_t;
            end
            if next(i,2) < cur(j,2)
                slope_t = next(i,3);
                Q_t = slope_t*next(i,2) + next(i,1) - slope_t*next(i,2);
                matrix_return(j,1) = Q_t;
                matrix_return(j,2) = next(i,1);
                matrix_return(j,3) = slope_t;
            end
            if next(i,2) == cur(j,2)
                slope1 = cur(j,3);
                slope2 = next(i,3);
                slope_t = slope1+slope2;
                q_cur_line = slope1*next(i,2) + cur(j,1) - slope1*cur(j,2);
                q_next_line = slope2*next(i,2) + next(i,1) - slope2*next(i,2);
                Q_t = q_cur_line+q_next_line;
                matrix_return(j,1) = Q_t;
                matrix_return(j,2) = next(i,1);
                matrix_return(j,3) = slope_t;
            end   
        end
    end
end

