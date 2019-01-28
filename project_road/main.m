close all; clear all;

%for i  = 1:41
    s= strcat('data/data/',int2str(1),'.ppm' );
    rgbImage=imread(s);
 
    rgbImage=rgbImage(1:floor(size(rgbImage,1)*0.75),:, :);
    
    imwrite(rgbImage,strcat('data/data/',int2str(1),'.png' ))
    
    %canny = edge(rgb2gray(rgbImage));
    %figure(); imshow(canny, []); title('canny');
    %[centers, radii, metric] = imfindcircles(rgb2gray(rgbImage),[1 300]);
    %viscircles(centers, radii,'EdgeColor','b');
    
    %NORMALIZED = comprehensive_colour_normalization(rgbImage);
    NORMALIZED = RGBNormalize(rgbImage);
    figure(); imshow(NORMALIZED, []); title('NORMALIZED');
    %sn= strcat('data/data/normalized',int2str(i),'.ppm' );
    %imwrite(NORMALIZED, sn);


    % Maintenant on va essayer de definir les régions d'interetclose 
    % qu'on va focaliser notre analyse, ces sont des regions rouges.
    % Donc, on doit segmenter l'image pour detecter ses regions d'interet

    % Tout d'abord il faut transformer l'image pour le domaine HSV
    % C'est domaine laisse plus évident les caracteristique couleurs

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
    %Puis on va définir les seuilles pour la couleur rouge
    %trying to make adaptatif thresholding
    filter = ones(3, 3)/9;
    conv_result = conv2(filter, hImage);
    RMeanTreshold = 0.63;
    GMeanTreshold = 0.55; 
    BMeanTreshold = 0.6;
    RMask = (hImage >= RMeanTreshold);
    GMask = (sImage <= GMeanTreshold);
    BMask = (vImage <= BMeanTreshold);
    Mask = uint8(RMask & GMask & BMask);
    %image_bw = bwareaopen(Mask, 50);
    %figure();imshow(image_bw, []);title('adaptatif');
    
    
    
%     hThresholdLow = 0.8;
%     hThresholdHigh = 1;
%     sThresholdLow = 0;
%     sThresholdHigh = 0.55;
%     vThresholdLow = 0;
%     vThresholdHigh = 0.6;
    
    %Maintenant on cree des masques pour chaque chaine
%     hMask = (hImage >= hThresholdLow) & (hImage <= hThresholdHigh);
%     sMask = (sImage >= sThresholdLow) & (sImage <= sThresholdHigh);
%     vMask = (vImage >= vThresholdLow) & (vImage <= vThresholdHigh);
        %%On affiche les trois masques
%     coloredObjectsMask = uint8(hMask & sMask & vMask);
    coloredObjectMask = Mask;
    image_bw = bwareaopen(coloredObjectMask, 200);
     figure(); imshow(bwareaopen(image_bw, 1500));title('fond');
    titre = strcat('seg', int2str(i));
    figure(); imshow(image_bw);title(titre);
    s=strel('disk',1);
    image_bw=imerode(image_bw,s);
    %figure(); imshow(image_bw);title('erosion');
    %image_split=tse_imsplitobjects(uint8(image_bw));
    %figure(); imshow(image_split);title('split');
     
     
    %image_bw = image_split - bwareaopen(image_split, 2000);
    canny = edge(image_bw);
    %[maxg, gh, gv]=tse_imgrad(image_bw, 'sobel');
    %figure(); imshow(canny, []); title('canny');
    %extended=tse_imextendedge(image_bw,gh, gv);
    s = strel('disk', 2);
    dilated = imdilate(canny, s);
    %figure(); imshow(dilated, []); title(strcat('dilate', int2str(i)));
    filled = imfill(dilated, 'holes');
    %figure(); imshow(filled, []); title(strcat('fill', int2str(i)));
    s2=strel('disk', 4);
    filled = imopen(filled, s2);%?
    %figure(); imshow(filled, []); title(strcat('open', int2str(i)));
    filled = bwareaopen(filled, 455);
    %figure(); imshow(filled, []); title(strcat('areaopen', int2str(i)));
    
    st=regionprops(filled,'BoundingBox', 'Area');
    for k=1:length(st)
        BB=st(k).BoundingBox;
        %condition 1: eliminer les regions petits
        %condition 2: eliminer les regions alonger à l'horizontal
        %condition 3: eliminer les regions trop alonger à la vertical tout
        %en avant une taille petite en x.
        if(st(k).Area>181) && (BB(3)/BB(4) <= 1.6) && (BB(3)/BB(4) >= 0.35)
            rectangle('Position', [BB(1), BB(2), BB(3), BB(4)], 'EdgeColor', 'r' ,'LineWidth',2);
        end
    end
    pause(3);
   
    %final = final - bwareaopen(final, 1000);
    %coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');
    
    %image_bw=bwareaopen(image_bw,50);

    %figure(); imshow(image_bw, []); title('final ');
    %[centers, radii, metric] = imfindcircles(uint8(255*image_bw),[10 100]);
    %viscircles(centers, radii,'EdgeColor','b');
    
     %s=strel('disk',1);
    %image_bw_split=imdilate(image_bw_split,s);
     %figure(); imshow(image_bw_split);title('g');
    % pause(1);
     %close all;
%end
