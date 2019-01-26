close all; clear all;


%for i  = 1:41
    s= strcat('data/data/',int2str(12),'.ppm' );
    rgbImage=imread(s);
    figure(); imshow(rgbImage, []);
    
    %NORMALIZED = comprehensive_colour_normalization(rgbImage);
    NORMALIZED = RGBNormalize(rgbImage);
    %figure(); imshow(NORMALIZED, []); title('NORMALIZED');
    %sn= strcat('data/data/normalized',int2str(i),'.ppm' );
    %imwrite(NORMALIZED, sn);


    % Maintenant on va essayer de definir les r�gions d'interetclose 
    % qu'on va focaliser notre analyse, ces sont des regions rouges.
    % Donc, on doit segmenter l'image pour detecter ses regions d'interet

    % Tout d'abord il faut transformer l'image pour le domaine HSV
    % C'est domaine laisse plus �vident les caracteristique couleurs

    %hsvImage = rgb2hsv(NORMALIZED);

    %figure();
    %subplot(2,1,1); imshow(rgbImage, []); title('Original Image');
    %subplot(2,1,2); imshow(hsvImage, []); title('Image HSV');

    %extraction des chaines de l'image
%   hImage = hsvImage(:,:,1);
%   sImage = hsvImage(:,:,2);
%   vImage = hsvImage(:,:,3);

    hImage = NORMALIZED(:,:,1);
    sImage = NORMALIZED(:,:,2);
    vImage = NORMALIZED(:,:,3);
    %Puis on va d�finir les seuilles pour la couleur rouge
    hThresholdLow = 0.6;
    hThresholdHigh = 1;
    sThresholdLow = 0;
    sThresholdHigh = 0.55;
    vThresholdLow = 0;
    vThresholdHigh = 0.6;
    
    %Maintenant on cree des masques pour chaque chaine
    hMask = (hImage >= hThresholdLow) & (hImage <= hThresholdHigh);
    sMask = (sImage >= sThresholdLow) & (sImage <= sThresholdHigh);
    vMask = (vImage >= vThresholdLow) & (vImage <= vThresholdHigh);
        %%On affiche les trois masques
    coloredObjectsMask = uint8(hMask & sMask & vMask);
    final = bwareaopen(coloredObjectsMask, 15);
    figure(); imshow(bwareaopen(final, 1500));title('fond');
    
    final = final - bwareaopen(final, 2000);
    %final = final - bwareaopen(final, 1000);
    %coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');

    figure(); imshow(final, []); title(int2str(29));
    %pause(3);
    %close all;
%end
