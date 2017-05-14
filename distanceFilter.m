function svmax = distanceFilter(imgmat, maxmat, dist)

    npks = size(maxmat, 1);
    % Sieving the found peaks to eliminate duplicates
    for s = 1:npks

        % Calculate proximity metric vector (each element is the squared
        % cartesian distance between the brightest pixels in the chosen blocks
        proxvec = (maxmat(:,1) - maxmat(s,1)).^2 + (maxmat(:,2) - maxmat(s,2)).^2;
        prind = find(proxvec < dist^2,1);

        % Proximity elimination: if there are peaks very close by, the compare
        % the values of the two peaks and retain the biggest
        if prind(1) ~= s && imgmat(maxmat(s,1),maxmat(s,2)) > imgmat(maxmat(prind(1),1),maxmat(prind(1),2))
            maxmat(prind(1),:) = [0 0 0];
        elseif prind(1) ~= s && imgmat(maxmat(s,1),maxmat(s,2)) <= imgmat(maxmat(prind(1),1),maxmat(prind(1),2))
            maxmat(s,:) = [0 0 0];
        end

    end

    % Remove the duplicates found from sieving
    svmax = maxmat(maxmat(:,3) ~= 0,:);
    
end