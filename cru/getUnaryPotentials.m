function [potentials config] = getUnaryPotentials(graph,p)
    size_graph = size(graph);
    potentials = nan(size_graph);
    config = nan(size_graph);
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
                end
            end
            config(i,j) = x;
        end
    end
end