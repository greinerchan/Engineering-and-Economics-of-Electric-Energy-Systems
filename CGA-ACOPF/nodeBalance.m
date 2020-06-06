function [node_P,node_Q] = nodeBalance(Vm,Y_bus,busNum)
node_PQ=zeros(busNum,1);
for i = 1:busNum
    for k = 1:busNum
        node_PQ(i)=node_PQ(i)...
            + Vm(i)*conj(Y_bus(i,k))*conj(Vm(k));
    end
end
node_P=zeros(busNum,1);
node_Q=zeros(busNum,1);
for i=1:1:busNum
    node_P(i,1)=real(node_PQ(i,1));
    node_Q(i,1)=imag(node_PQ(i,1));
end
end

