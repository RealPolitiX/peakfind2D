function maxmat = findPeakCandidates(blockmat, npks)
    
    [nrblk, ncblk] = size(blockmat);
    [runit, cunit] = size(blockmat{1,1});
    nblk = nrblk*ncblk; % total number of disected blocks
    
    sumlet = zeros(1,nblk);
    maxmat = zeros(npks,3);

    % Sum the intensities in every disected block
    for i = 1:nblk
        
        [rblk,cblk] = ind2sub([nrblk,ncblk],i);
        sumlet(i) = sum(sum(blockmat{rblk,cblk}));
        
    end

    % Sort the list of summed intensities of disected blocks
    [~,sumidx] = sort(sumlet,'descend');

    % Find peaks in the brightest npks blocks
    % Loop over the brightest npks image blocks (imglets)
    for j = 1:npks
    
        % Retrieve every imglet from disected image
        [rblkj,cblkj] = ind2sub([nrblk,ncblk],sumidx(j));
        imglet = blockmat{rblkj,cblkj};

        % Retrieve the relative index (rel. to imglet origin) of the most intense pixel
        imgletmax = max(imglet(:));
        [rmlet,cmlet] = find(imglet - imgletmax == 0);

        % Calculate the absolute coordinates of the brightest pixel
        rm = rmlet(1) + (rblkj-1)*runit;
        cm = cmlet(1) + (cblkj-1)*cunit;

        % Store the absolute coordinates of the brightest pixel
        maxmat(j,:) = [rm,cm,imgletmax];
        
    end

end