function getElement(serial,matrix)
    serial = int64(serial);
    size_matrix = size(matrix);
    dims = size(size_matrix);
    out_index = zeros(dims(2),1);
    for i=1:dims(2),
        product = int64(prod(size_matrix)/size_matrix(dims(2)+1-i));
        ci = dims(2)+1-i
        out_index(ci) = idivide(serial,product,'ceil')
        serial = serial - (out_index(ci)-1)*product
    end
end