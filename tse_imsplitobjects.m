function g=tse_imsplitobjects(f)
%TSE_IMSPLITOBJECTS(F) split connected objects in a binary image using the distance function.

validateattributes(f,{'uint8','logical'},{'2d'});

fd=-bwdist(~f);        %complement of distance function
fd=imhmin(fd,0.7);
ws=watershed(fd);   %watershed
g=f & (ws>0);          %separation
