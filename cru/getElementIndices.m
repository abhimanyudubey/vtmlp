% MATLAB script for generating grid indices from a linearized 3D grid.
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function element = getElementIndices(serial,graph)
    gsize = size(graph);
    sz = mod(serial,(gsize(1)*gsize(2)));
    z = (serial-sz)/(gsize(1)*gsize(2));
    sy = mod(sz,gsize(1));
    y = (sz-sy)/(gsize(1));
    x = sy;
    element = [x+1,y+1,z+1];
end