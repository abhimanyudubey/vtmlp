% MATLAB script for generating Binary Potentials from a 3-D graph according to rules from
% http://www-users.cs.umn.edu/~banerjee/papers/12/drought.pdf 
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function potentials = getPairwisePotentials(config, c1,c2)
% This function accepts the precipitation graphs and the configurations
% generated from getUnaryPotentials.m and generates the pairwise potential
% values using the values of c1 and c2 as described in the abovementioned
% paper.
    location_pairs=[];
    time_pairs=[];
    %Initializing default values.
    size_config = size(config);
    %The size of the table of configurations.
    if(length(size_config)==2),
        size_config = [size_config 1];
    end
    % We first generate the edges with respect to the spatial distribution
    % (4 nearest neighbors on land). To avoid duplicate edges, pairs are
    % generated from the top-left element and the right and bottom neighbor
    % is added (if ~NaN). Therefore only two edges added per iteration over
    % a node. 
    for k=1:size_config(3),
        for i=1:size_config(1),
            for j=1:size_config(2),
                if ~isnan(config(i,j,k))
                    if i ~= size_config(1),
                        if ~isnan(config(i+1,j,k)),
                            id_1 = getElementID(config,i,j,k);
                            id_2 = getElementID(config,i+1,j,k);
                            if config(i,j,k) == 1 && config(i+1,j,k) == 1,
                                location_potentials = c1;
                            else
                                location_potentials = c2;
                            end
                            location_pairs =    [location_pairs
                                                id_1 id_2 location_potentials];                   
                        end
                    end
                    %Appending new pairs in the format (id1) (id2)
                    %(potential);
                    if j ~= size_config(2),
                        if ~isnan(config(i,j+1,k)),
                            id_1 = getElementID(config,i,j,k);
                            id_2 = getElementID(config,i+1,j,k);
                            if config(i,j,k) == 1 && config(i,j+1,k) == 1,
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
    % We now generate the temporal pairs. Temporal pairs are added in
    % direction of increasing time, and per iteration on a node only one
    % edge is added. 
    for k=1:size_config(3)-1,
        for i=1:size_config(1),
            for j=1:size_config(2),
                if ~isnan(config(i,j,k))
                    if ~isnan(config(i,j,k+1)),
                        id_1 = getElementID(config,i,j,k);
                        id_2 = getElementID(config,i,j,k+1);
                        if config(i,j,k) == 1 && config(i,j,k+1) == 1,
                            time_potentials = c1;
                        else
                            time_potentials = c2;
                        end
                        time_pairs =    [time_pairs
                                            id_1 id_2 time_potentials];                   
                    end
                end
            end
        end
    end
    
    % The final list contains the spatial edges followed by the temporal
    % edges.
    potentials = [location_pairs
                 time_pairs];
end