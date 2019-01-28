close all; clear all;

for i=1:41
    s= strcat('data/data/',int2str(i),'.ppm' );
    rgbImage=imread(s);
    [m, n]=size(rgbImage);
    meanR= sum(sum(rgbImage(:,:, 1)))/(m*n);
    meanG= sum(sum(rgbImage(:,:, 2)))/(m*n);
    meanB= sum(sum(rgbImage(:,:, 3)))/(m*n);    
    
    display(int2str(i))
    luminance=0.2126*meanR+0.7152*meanG+0.0722*meanB
    
    figure(); imshow(rgbImage, []);
    title(int2str(i));

    NORMALIZED = comprehensive_colour_normalization(rgbImage);
    %figure(); imshow(NORMALIZED, []); title('NORMALIZED');
    sn= strcat('data/data/normalized',int2str(i),'.ppm' );
    imwrite(NORMALIZED, sn);

    
    [m, n]=size(NORMALIZED);
    meanR= sum(sum(NORMALIZED(:,:, 1)))/(m*n);
    meanG= sum(sum(NORMALIZED(:,:, 2)))/(m*n);
    meanB= sum(sum(NORMALIZED(:,:, 3)))/(m*n);
    
   % luminance=0.2126*meanR+0.7152*meanG+0.0722*meanB

% Maintenant on va essayer de definir les r�gions d'interetclose 
% qu'on va focaliser notre analyse, ces sont des regions rouges.
% Donc, on doit segmenter l'image pour detecter ses regions d'interet

% Tout d'abord il faut transformer l'image pour le domaine HSV
% C'est domaine laisse plus �vident les caracteristique couleurs

    hsvImage = rgb2hsv(NORMALIZED);

   % figure();
    %subplot(2,1,1); imshow(rgbImage, []); title('Original Image');
    %subplot(2,1,2); imshow(hsvImage, []); title('Image HSV');

    %extraction des chaines de l'image
%     hImage = hsvImage(:,:,1);
%     sImage = hsvImage(:,:,2);
%     vImage = hsvImage(:,:,3);
      hImage = NORMALIZED(:,:,1);
    sImage = NORMALIZED(:,:,2);
    vImage = NORMALIZED(:,:,3);
    %Puis on va d�finir les seuilles pour la couleur rouge
    hThresholdLow = 187;
    hThresholdHigh = 255;
    sThresholdLow = 155;
    sThresholdHigh = 247;
    vThresholdLow = 39;
    vThresholdHigh = 139;

    %Maintenant on cree des masques pour chaque chaine
    hMask = (hImage >= hThresholdLow) & (hImage <= hThresholdHigh);
    sMask = (sImage >= sThresholdLow) & (sImage <= sThresholdHigh);
    vMask = (vImage >= vThresholdLow) & (vImage <= vThresholdHigh);

    %%On affiche les trois masques
    coloredObjectsMask = uint8(hMask & sMask & vMask);
    coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');
   % figure(); imshow(coloredObjectsMask, []); title('Mask');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
   % pause(2);
end
