function blockmat = matsect(imgmat, runit, cunit)
    
    % Disect matrix into blocks determined by the specified dimensions
    % runit (row unit size), cunit (column unit size) have the unit of pixels
    % The function returns a cell array of disected matrix
    
    [r, c] = size(imgmat);
    nrblk = r/runit;
    ncblk = c/cunit;

    blockmat = mat2cell(imgmat,runit*ones(1,nrblk),cunit*ones(1,ncblk));

end