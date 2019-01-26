function [imgN] = RGBNormalize(img)
[m, n] = size(img(:,:,1));
imgR = double(img(:,:,1));
imgG = double(img(:,:,2));
imgB = double(img(:,:,3));
NormR = zeros(m, n);
NormG = zeros(m, n);
NormB = zeros(m, n);

for i = 1:m
        %display('i');
        %display(i);
    for j = 1:n
        %display('j');
        %display(j);
        red = imgR(i,j);
        green = imgG(i, j);
        blue = imgB(i,j);
        
        NormR(i, j) = red/sqrt(red^2+green^2+blue^2);
        NormG(i, j) = green/sqrt(red^2+green^2+blue^2);
        NormB(i, j) = blue/sqrt(red^2+green^2+blue^2);
    end
end

imgN = cat(3, NormR, NormG, NormB);
end