new_pre = nan(720,360,109);
for i=1:109,
    start_index = (i-1)*12+1;
    end_index = i*12;
    
    subset = pre(:,:,[start_index:end_index]);
    new_pre(:,:,i)=nanmean(subset,3);
end
