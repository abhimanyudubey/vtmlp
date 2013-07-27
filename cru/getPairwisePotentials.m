% MATLAB script for generating Binary Potentials from a 3-D graph according to rules from
% http://www-users.cs.umn.edu/~banerjee/papers/12/drought.pdf 
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function potentials = getPairwisePotentials(config, c1,c2)
% This function accepts the precipitation graphs and the configurations
% generated from getUnaryPotentials.m and generates the pairwise potential
% values using the values of c1 and c2 as described in the abovementioned
% paper.
    land_count = sum(sum(sum(~isnan(config))));
    %This is the number of nodes on land (non-nan values)
    size_config = size(config);
    location_pairs = [];
    location_potentials = NaN;
    %The size of the table of configurations.
    if(length(size_config)==2),
        size_config = [size_config 1];
    end
    for k=1:size_config(3),
        for i=1:size_config(1),
            for j=1:size_config(2),
                if ~isnan(config(i,j,1))
                    if i ~= size_config(1),
                        if ~isnan(config(i+1,j,1)),
                            id_1 = getElementID(config,i,j,k);
                            id_2 = getElementID(config,i+1,j,k);
                            if config(i,j,k) == 1 & config(i+1,j,k) == 1,
                                location_potentials = c1;
                            else
                                location_potentials = c2;
                            end
                            location_pairs =    [location_pairs
                                                id_1 id_2 location_potentials];                   
                        end
                    end
                    if j ~= size_config(2),
                        if ~isnan(config(i,j+1,1)),
                            id_1 = getElementID(config,i,j,k);
                            id_2 = getElementID(config,i+1,j,k);
                            if config(i,j,k) == 1 & config(i,j+1,k) == 1,
                                location_potentials = c1;
                            else
                                location_potentials = c2;
                            end
                            location_pairs =    [location_pairs
                                                id_1 id_2 location_potentials];                   
                        end
                    end
                end
            end
        end
    end
    potentials = location_pairs;
end