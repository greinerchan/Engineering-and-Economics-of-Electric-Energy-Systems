function matrix_return = combineTwo(cur,next)
%COMBINETWO Summary of this function goes here
%   Detailed explanation goes here
    [row, col] = size(cur);
    m_price = cat(1, cur(:,2), next(:,2)); 
    m_price = sortrows(m_price,1);
    cur = sortrows(cur,3);
    next = sortrows(next,3);
    [row2,col2] = size(m_price);
    % first and last price just leave them original
    for i = 1:1:row
        cur_price = m_price(i);
        [rowp1, colp1] = find(cur(:,3)==cur_price);
        [rowp2, colp2] = find(next(:,3)==cur_price);
        % they all have the same price
        if ~isnan(cur_price) && ~isempty(rowp1) && ~isempty(rowp2)
           slope1 = cur(rowp(1,1),3);
           q1 = cur(rowp1(1,1),1);
           p1 = cur(rowp1(1,1),2);
           slope2 = next(rowp(1,1),3);
           q2 = next(rowp2(1,1),1);
           p2 = next(rowp2(1,1),2);
           q_cur_line = slope1*cur_price + q1 - slope1*p1;
           q_next_line = slope2*cur_price + q2 - slope2*p2;
           q_new = q_cur_line + q_next_line;
           slope_new = slope1+slope2;
        end
        % cur matrix does not have price but next has
        if ~isnan(cur_price) && isempty(rowp1) && ~isempty(rowp2)
            j = 0;
            for i = 1:1:row
                if cur(i,3) > isnan(cur_price)
                j = i - 1;
                break
                end
            end
           slope1 = cur(j,3);
           q1 = cur(j,1);
           p1 = cur(j,2);
           slope2 = next(j,3);
           q2 = next(j,1);
           p2 = next(j,2);
           q_cur_line = slope1*cur_price + q1 - slope1*p1;
           q_next_line = slope2*cur_price + q2 - slope2*p2;
           q_new = q_cur_line + q_next_line;
        end
           
         % cur matrix has price but next does have
        if ~isnan(cur_price) && ~isempty(rowp1) && isempty(rowp2)
            j = 0;
            for i = 1:1:row
                if cur(i,3) > isnan(cur_price)
                j = i - 1;
                break
                end
            end
        end
           slope1 = cur(j,3);
           q1 = cur(j,1);
           p1 = cur(j,2);
           slope2 = next(j,3);
           q2 = next(j,1);
           p2 = next(j,2);
           q_cur_line = slope1*cur_price + q1 - slope1*p1;
           q_next_line = slope2*cur_price + q2 - slope2*p2;
           q_new = q_cur_line + q_next_line;
    end


