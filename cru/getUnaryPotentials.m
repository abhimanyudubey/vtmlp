% MATLAB script for generating Unary Potentials from a 3-D graph according to rules from
% http://www-users.cs.umn.edu/~banerjee/papers/12/drought.pdf 
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function [potentials,config] = getUnaryPotentials(graph,p)
% This function takes in the precipitation values of the CRU 1901-2009
% dataset and percentile threshold (check abovementioned paper) and 
% returns configs (for k=2, 0 or 1 values) and unary potential
% values of the dataset.
    size_graph = size(graph);
    potentials = nan(size_graph);
    config = nan(size_graph);
    % The default configuration is specified as a NaN field. Values which
    % are present (land values) are assigned 0 or 1.
    for i=1:size_graph(1),
        for j=1:size_graph(2),
            p_val = prctile(graph(i,j,:),p);
            x = zeros(size_graph(3));
            mean_pred = zeros(2);
            corr_val = zeros(2);
            for k=1:size_graph(3),
                if isnan(graph(i,j,k))
                    x(k) = NaN;
                elseif graph(i,j,k) > p_val
                    x(k) = 1;
                    mean_pred(2)=mean_pred(2)+graph(i,j,k);
                    corr_val(2)=corr_val(2)+1;
                else
                    x(k) = 0;
                    mean_pred(1)=mean_pred(1)+graph(i,j,k);
                    corr_val(1)=corr_val(1)+1;
                end
            end
            %Assigned the configurations to the values. We now assign the
            %potential values as the normal pdf value of the distribution.
            mean_pred(1) = mean_pred(1)/corr_val(1);
            mean_pred(2) = mean_pred(2)/corr_val(2);
            stdev = std(graph(i,j,:),1);
            for k=1:size_graph(3),
                if x(k) == 1,
                    potentials(i,j,k) = normpdf(graph(i,j,k),mean_pred(2),stdev);
                elseif x(k) == 0,
                    potentials(i,j,k) = normpdf(graph(i,j,k),mean_pred(1),stdev);
                elseif isnan(x(k)),
                    potentials(i,j,k) = NaN;
                    % The potentials are found using the method described
                    % in the paper, via normal probability distribution
                    % function on the 109 year data.
                end
            % Assigned the potential values.
            config(i,j,k) = x(k);
            end
        end
    end
    %Configuration complete.
end