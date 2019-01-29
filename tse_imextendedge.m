function fext=tse_imextendedge(f,gh,gv,nb)

if nargin<4, nb=1; end

neig=[0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
[m,n]=size(f);

fext=f;

for it=1:nb
    fext=bwmorph(fext,'thin',Inf);   % Thinning
    pts=find(xor(bwmorph(fext,'spur'),fext)); % Coordinates of extremity points

    for k=1:numel(pts)
        j=floor((pts(k)-1)/m)+1;
        i=mod((pts(k)-1),m)+1;
        if (i>1) && (i<m) && (j>1) && (j<n)
            l=1;
            while (l<=8) && fext(i+neig(l,1),j+neig(l,2))==0, l=l+1; end
            ll=mod((l+1):(l+5),8)+1;
            ii=i+neig(ll,1);
            jj=j+neig(ll,2);
            p=ii+(jj-1)*m;
            [val,idx]=max(gh(p).*gh(p)+gv(p).*gv(p));
            fext(p(idx))=true;
        end
    end
end

end