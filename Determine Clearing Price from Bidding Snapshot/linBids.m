function [bidsMatrix, inversedBidsMatrix] = linBids(fileinput)
% This function will return two matrixs, the first one is aggreagated
% supply function, the second one is inverse aggreagated supply function
% This is Part(a) of the assigment, input is the file's name
    %clear;
    % import data from csv file
    %filename = 'energy_market_offers.csv';
    filename = fileinput;
    data=importdata(filename);

    % find the column has false flage for the flag
    target_col = 4;% target column
    target_val = 'True'; % target value
    % find row which has no slope flag
    [row,col] = find(strcmp(data.textdata(:,target_col),target_val));
    result_row = row;
    data_raw = result_row - 1; %get rid of head row
    m_true = data.data(data_raw,:); % matrix of data false
    m_trueQ = m_true(:, 1:10); % false matrix only contains quantity
    m_trueQ2 = m_trueQ; % copy a to a new matrix to store original data
    [rowm, colm] = size(m_trueQ);
    for i = 1:1:rowm
        for j = 1:1:colm
            if ~isnan(m_trueQ(i,j)) && (j+1) <= colm
                m_trueQ(i, j+1) = m_trueQ(i, j+1) - m_trueQ2(i,j);
            end
        end
    end
    m_true(:,1:10) = m_trueQ(:,1:10);

    mw1_bid1 = m_true(:,[1 11]); %get initial bid combination
    m_totalPairs = mw1_bid1; % set the initial total pairs

    % put all mw/price combinations into a matrix
    for i = 2:1:10
        mw_bid = m_true(:,[i i+10]);
        % put all matrix together in one matrix
        m_totalPairs = cat(1, m_totalPairs, mw_bid); 
    end

    % rank the matrix by price from low to high
    m_sortByPrice = sortrows(m_totalPairs, 2);
    % get rid of nan in matrix
    m_sortByPrice(any(isnan(m_sortByPrice),2),:) = [];
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
    %inversedBidsMatrix = m_sortByPrice;
    % get rid of value with same price
    [row3, col3] = size(bidsMatrix);
    noRedundancy = zeros(row3,col3);
    for i = 1:1:row3
        if i + 1 == row3
            noRedundancy(i+1,:) = bidsMatrix(i+1,:);
            noRedundancy(all(noRedundancy==0,2),:) = [];
            % add slope for each point
            bidsMatrix = addSlope(noRedundancy);
            break
        end
        if bidsMatrix(i,2) ~= bidsMatrix(i+1,2)
            noRedundancy(i,:) = bidsMatrix(i,:);
        end
    end 
    inversedBidsMatrix = noRedundancy;
    inversedBidsMatrix(:,[1 2]) = inversedBidsMatrix(:,[2 1]);
    addSlope(inversedBidsMatrix);
    % plot the graph MW accumulates VS price
    %subplot(2,1,1)
    %plot(bidsMatrix(:,1),bidsMatrix(:,2));
    %xlabel('MWh'); 
    %ylabel('Dollars per MWh');
    %title('Part(b)');
    % plot the graph Price VS MW accumulates
    %subplot(2,1,2)
    %plot(inversedBidsMatrix(:,1),inversedBidsMatrix(:,2));
    %xlabel('Dollars per MWh'); 
    %ylabel('MWh');
end

