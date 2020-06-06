function [bidsMatrix, inversedBidsMatrix, m_copy] = constBids(filename)
% This function will return two matrixs, the first one is aggreagated
% supply function, the second one is inverse aggreagated supply function
% This is Part(a) of the assigment, input is the file's name
    % import data from csv file
    %clear;
    %filename = 'energy_market_offers.csv';
    %filename = fileinput;
    data=importdata(filename);

    % find the column has false flage for the flag
    target_col = 4;% target column
    target_val = 'False'; % target value
    % find row which has no slope flag
    [row,col] = find(strcmp(data.textdata(:,target_col),target_val));
    result_row = row;
    data_raw = result_row - 1; %get rid of head row
    m_false = data.data(data_raw,:); % matrix of data false
    m_falseQ = m_false(:, 1:10); % false matrix only contains quantity
    m_falseQ2 = m_falseQ; % copy a to a new matrix to store original data
    [rowm, colm] = size(m_falseQ);
    for i = 1:1:rowm
        for j = 1:1:colm
            if ~isnan(m_falseQ(i,j)) && (j+1) <= colm
                m_falseQ(i, j+1) = m_falseQ(i, j+1) - m_falseQ2(i,j);
            end
        end
    end
    m_false(:,1:10) = m_falseQ(:,1:10);

    mw1_bid1 = m_false(:,[1 11]); %get initial bid combination
    m_totalPairs = mw1_bid1; % set the initial total pairs

    % put all mw/price combinations into a matrix
    for i = 2:1:10
        mw_bid = m_false(:,[i i+10]);
        % put all matrix together in one matrix
        m_totalPairs = cat(1, m_totalPairs, mw_bid); 
    end

    % rank the matrix by price from low to high
    m_sortByPrice = sortrows(m_totalPairs, 2);
    % get rid of nan in matrix
    m_sortByPrice(any(isnan(m_sortByPrice),2),:) = [];
    m_copy = m_sortByPrice;
    [a,b] = size(m_copy);
    zeroColunm = zeros(a,1);
    m_copy = [m_copy,zeroColunm];
    % find size of the matrix
    [row2, col2] = size(m_sortByPrice);
    % change the first column of matrix for MW accumulates 
    x_prev = 0;
    for j = 1:1:row2
        m_sortByPrice(j,1) = x_prev + m_sortByPrice(j,1);
        x_prev = m_sortByPrice(j,1);
    end
    zeroColunm = zeros(row2,1);
    m_sortByPrice = [m_sortByPrice,zeroColunm];
    bidsMatrix = m_sortByPrice;
    % flip first and second column of the matrix
    m_sortByPrice(:, [1 2]) = m_sortByPrice(:, [2 1]);
    inversedBidsMatrix = m_sortByPrice; 
    % plot the graph MW accumulates VS price
    %subplot(2,1,1)
    %plot(bidsMatrix(:,1),bidsMatrix(:,2));
    %xlabel('MWh'); 
    %ylabel('Dollars per MWh');
    %title('Part(a)');
    %plot the graph Price VS MW accumulates
    %subplot(2,1,2)
    %plot(inversedBidsMatrix(:,1),inversedBidsMatrix(:,2));
    %xlabel('Dollars per MWh'); 
    %ylabel('MWh');
end









