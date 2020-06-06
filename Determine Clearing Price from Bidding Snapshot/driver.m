function clearingPrice = driver(nameInput, demand)
    %the nameInput is the name of the file, demand is the mwh demand can
    %be set, demand should be possitive but less than 1.566614799999990E6
    %clear;
    fileName = nameInput;
    %fileName='energy_market_offers.csv';
    [bidsMatrix_partA, inversedBidsMatrix_partA, m_copy] = constBids(fileName);
    [bidsMatrix_partB, inversedBidsMatrix_partB] = linBids(fileName);
    [bidsMatrix_partC, inversedBidsMatrix_partC] = combineAB(fileName);
    partA_common = bidsMatrix_partA;
    partA_inversed = inversedBidsMatrix_partA;  
    partB_common = bidsMatrix_partB;
    partB_inversed = inversedBidsMatrix_partB;
    partC_common = bidsMatrix_partC;
    partC_inversed = inversedBidsMatrix_partC;
    assignin('base','partA_common',partA_common);
    assignin('base','partA_inversed',partA_inversed);
    assignin('base','partB_common',bidsMatrix_partB);
    assignin('base','partB_inversed',inversedBidsMatrix_partB);
    assignin('base','partC_common',bidsMatrix_partC);
    assignin('base','partC_inversed',inversedBidsMatrix_partC);
    m = [1 10];
    partD = zeros(m);
    v = [420.9 1400 920 1452.6 9324 9600 37 655546 1 333111];
    for i = 1:1:length(v)
        partD(1,i) = findPrice(bidsMatrix_partC,v(i));
    end
    assignin('base','partD', partD);
    clearingPrice = findPrice(bidsMatrix_partC,demand);
end

