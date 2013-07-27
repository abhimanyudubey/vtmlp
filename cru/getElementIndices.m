function element = getElementIndices(serial,graph)
    gsize = size(graph);
    sz = mod(serial,(gsize(1)*gsize(2)));
    z = (serial-sz)/(gsize(1)*gsize(2));
    sy = mod(sz,gsize(1));
    y = (sz-sy)/(gsize(1));
    x = sy;
    element = [x+1,y+1,z+1];
end