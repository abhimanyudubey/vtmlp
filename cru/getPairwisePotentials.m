% MATLAB script for generating Binary Potentials from a 3-D graph according to rules from
% http://www-users.cs.umn.edu/~banerjee/papers/12/drought.pdf 
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function potentials = getPairwisePotentials(graph,config, c1,c2)
% This function accepts the precipitation graphs and the configurations
% generated from getUnaryPotentials.m and generates the pairwise potential
% values using the values of c1 and c2 as described in the abovementioned
% paper.
    num_nonnan_elements = sum(sum(sum(~isnan(config))));
    %This is the number of nodes on land (non-nan values)
end