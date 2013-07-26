% MATLAB script for generating Binary Potentials from a 3-D graph according to rules from
% http://www-users.cs.umn.edu/~banerjee/papers/12/drought.pdf 
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function potentials = getPairwisePotentials(graph,config, c1,c2)
% This function accepts the precipitation graphs and the configurations
% generated from getUnaryPotentials.m and generates the pairwise potential
% values using the values of c1 and c2 as described in the abovementioned
% paper.
    size_graph = size(graph);
    potentials = nan(size_graph);
    numElements = prod(size(graph));
    element_pairs = cmbntns(numElements,2);
    size_element_pairs = size(element_pairs);
    for i=1:size_element_pairs(2),
        elementA = getElement(element_pairs(1,i),graph);
        elementB = getElement(element_pairs(2,i),graph);
        configA = getElement(element_pairs(1,i),config);
        configB = getElement(element_pairs(2,i),config);
        indexA = getPosition(element_pairs(1,i),graph);
        indexB = getPosition(element_pairs(2,i),graph);
        if configA + configB == 2
            potentials(indexA(1),indexA(2),indexA(3)) = c1;
            potentials(indexB(1),indexB(2),indexB(3)) = c1;
        elseif configA + configB >= 0
            potentials(indexA(1),indexA(2),indexA(3)) = c1;
            potentials(indexB(1),indexB(2),indexB(3)) = c1;
    end
end