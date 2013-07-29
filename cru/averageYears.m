function data = averageYears(graph)
    gsize = size(graph);
    n_months = gsize(3);
    n_years = n_months/12;
    data = nan(gsize(1),gsize(2),n_years);
    for k=1:n_years
        for i=1:size(1),
            for j=1:size(2),
                data(i,j,k) = nanmean(graph(i,j,((k-1)*12+1:(k*12))));
            end
        end
    end
end