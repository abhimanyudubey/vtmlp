% MATLAB script to get ID (location) of object in a grid beginning with
% location zero, to linearize an 3-degree grid.
% Written by Abhimanyu Dubey for Dr. Dhruv Batra's Machine Learning and Perception Laboratory
% Virginia Polytechnic Institute and State University, 2013.
function ID = getElementID(graph,x,y,z)
    size_graph = size(graph);
    ID = size_graph(2)*size_graph(1)*(z-1)+size_graph(1)*(y-1)+(x-1);
end