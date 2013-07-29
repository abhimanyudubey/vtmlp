function output = generateFile(unaryPotentials, pairwisePotentials)
    size_unary_pot = size(unaryPotentials);
    size_pairwise_pot = size(pairwisePotentials);
    s = 'MARKOV\n';
    % MARKOV random field, specified by the UAI file format.
    total_nodes = numel(unaryPotentials);
    s = strcat(s,num2str(int64(total_nodes)),'\n');
    for i=1:size_unary_pot(1),
        for j=1:size_unary_pot(2),
            for k=1:size_unary_pot(3),
                ID = getElementID(unaryPotentials,i,j,k);
                line = strcat('1 ',num2str(int64(ID)));
                s = strcat(s,line,'\n');
            end
        end
    end
    % Printed preamble for unary potentials.
    for i=1:size_pairwise_pot(1),
        line = strcat('2 ',num2str(int64(pairwisePotentials(i,1))),' ',num2str(int64(pairwisePotentials(i,2))));
        s = strcat(s,line,'\n');
    end
    % Printed preamble for pairwise potentials.
    
end