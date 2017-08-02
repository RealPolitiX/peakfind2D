function avg = avgnearest(img, rcoord, ccoord, rrad, crad)
    
    % Average the nearest nxn pixel values
    imglet = img(rcoord-rrad:rcoord+rrad,ccoord-crad:ccoord+crad);
    avg = sum(imglet(:))/numel(imglet);

end