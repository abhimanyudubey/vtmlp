function compile_pascal_data(cls,year)
startup;

[pos, neg, impos] = pascal_data(cls,year);

save(pos,'pos.m');
save(neg,'neg.m');
save(impos,'impos.m');

end
