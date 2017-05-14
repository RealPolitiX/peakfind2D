function img = centerblock(imgmat, rcent, ccent, rrad, crad)

    % Block an elliptical region of the input image near the center by
    % setting the pixel values there to zero.
    % 
    % The variables are named as,
    % imgmat -- image matrix
    % rrad -- radius in the row dimension
    % crad -- radius in the column dimension
    % rcent -- estimated center row position
    % ccent -- estimated center column position
    %
    % The function returns the center-blocked image
    
    img = imgmat;

    for i = rcent - rrad:rcent + rrad
        for j = ccent - crad:ccent + crad
            if ((i - rcent)/rrad)^2 + ((j - ccent)/crad)^2 < 1
                img(i,j) = 0;
            end
        end
    end
    
end