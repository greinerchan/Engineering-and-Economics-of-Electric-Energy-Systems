function [bidsMatrix, inversedBidsMatrix] = linearBids(fileinput)
% This function will return two matrixs, the first one is aggreagated
% supply function, the second one is inverse aggreagated supply function
% This is Part(a) of the assigment, input is the file's name
    clear;
    % import data from csv file
    filename = 'energy_market_offers.csv';
    %filename = fileinput;
    data=importdata(filename);

    % find the column has false flage for the flag
    target_col = 4;% target column
    target_val = 'True'; % target value
    % find row which has slope flag
    [row,col] = find(strcmp(data.textdata(:,target_col),target_val));
    result_row = row;
    data_raw = result_row - 1; %get rid of head row
    m_true = data.data(data_raw,:); % matrix of data true
    m_true = m_true(:,1:20);
    m_true(any(isnan(m_true),2),:) = [];
    [row, col] = size(m_true);
    cur = formatRow(m_true(1,:));
    cur = addSlope(cur);
    for i = 1:1:(row - 1)
        next = formatRow(m_true(i+1,:));
        next = addSlope(next);
        cur = addNextRow(cur, next);
        cur = addSlope(cur);
    end 
    bidsMatrix = cur;
end

