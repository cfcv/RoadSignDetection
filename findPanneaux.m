function [boxes] = findPanneaux(rgbImage)
    boxes = [];
    rgbImage=rgbImage(1:floor(size(rgbImage,1)*0.75),:, :);
    
    %figure(); imshow(rgbImage, []); %title(int2str(i));
    
    %Getting the grayscale image
    imGray = rgb2gray(rgbImage);
    [L,C] = size(imGray);
    %imwrite(rgbImage,strcat('data/data/',int2str(1),'.png' ))
    
    %Normalization step
    %NORMALIZED = comprehensive_colour_normalization(rgbImage);
    NORMALIZED = RGBNormalize(rgbImage);
    %figure(); imshow(NORMALIZED, []); title('NORMALIZED');
    %sn= strcat('data/data/normalized',int2str(i),'.ppm' );

    hImage = NORMALIZED(:,:,1);
    sImage = NORMALIZED(:,:,2);
    vImage = NORMALIZED(:,:,3);
    
    %Puis on va définir les seuilles pour la couleur rouge
    %trying to make adaptatif thresholding
    %Segmentation Step
    filter = ones(3, 3)/9;
    conv_result = conv2(filter, hImage);
    RMeanTreshold = 0.63;
    GMeanTreshold = 0.55; 
    BMeanTreshold = 0.6;
    RMask = (hImage >= RMeanTreshold);
    GMask = (sImage <= GMeanTreshold);
    BMask = (vImage <= BMeanTreshold);
    Mask = uint8(RMask & GMask & BMask);
    
    coloredObjectMask = Mask;
    image_bw = bwareaopen(coloredObjectMask, 200);
    %figure(); imshow(bwareaopen(image_bw, 1500));title('fond');
    titre = strcat('seg', int2str(i));
    %figure(); imshow(image_bw);title(titre);
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
    %figure(); imshow(filled, []); title(strcat('filled', int2str(i)));
    
    %Finding the bounding boxes
    st=regionprops(filled,'BoundingBox', 'Area');
    for k=1:length(st)
        BB=st(k).BoundingBox;
        %condition 1: eliminer les regions petits
        %condition 2: eliminer les regions alonger à l'horizontal
        %condition 3: eliminer les regions trop alonger à la vertical tout
        %en avant une taille petite en x.
        if(st(k).Area>181) && (BB(3)/BB(4) <= 1.6) && (BB(3)/BB(4) >= 0.35)
            %rectangle('Position', [BB(1), BB(2), BB(3), BB(4)], 'EdgeColor', 'r' ,'LineWidth',2);
            slice_y = floor(BB(2)+BB(4));%uint8(BB(2)+BB(4));
            slice_x = floor(BB(1)+BB(3));%uint8(BB(1)+BB(3));
            img_to_process = imGray(BB(2):slice_y, BB(1):slice_x);
            %figure();
            %imshow(img_to_process, []);

            %Finding the pannels
            [centers, radii] = imfindcircles(img_to_process, [5 60], 'Sensitivity', 0.9);
            [m,n] = size(centers);
   
            if(~isempty(centers)) 
                %rectangle('Position', [BB(1), BB(2), BB(3), BB(4)], 'EdgeColor', 'r' ,'LineWidth',2);
                %figure();
                %imshow(img_to_process);
                centers(:, 1) = centers(:, 1) + BB(1);
                centers(:, 2) = centers(:, 2) + BB(2);
                %viscircles(centers, radii,'EdgeColor','b');
                centers(:, 1) = centers(:, 1) - radii(:)-10;
                centers(:, 2) = centers(:, 2) - radii(:)-10;
             
                for z=1:m
                    if(radii(z) < 25)
                        slice_xx = floor(centers(z, 1) + 4*radii(z));
                        slice_yy = floor(centers(z, 2) + 4*radii(z));
                    else
                        slice_xx = floor(centers(z, 1) + 3*radii(z));
                        slice_yy = floor(centers(z, 2) + 3*radii(z));
                    end

                    if(slice_xx > C || slice_yy > L || centers(z, 1) <= 0 || centers(z,2) <= 0 || mean2(filled(centers(z,2):slice_yy, centers(z,1):slice_xx)) < 0.4)
                        continue
                    end
                    
                    [img, d, l] = sift(imGray(centers(z,2):slice_yy, centers(z,1):slice_xx));
                    %length(l)
                    %norm(d30(:, :) - d(:, :))
                    if(length(l) > 30)
                        newBox = [centers(z, 1), centers(z,2), floor(slice_xx - centers(z,1)), floor(slice_yy - centers(z,2))];
                        boxes = [boxes newBox];
                        %rectangle('Position', [centers(z, 1), centers(z,2), floor(slice_xx - centers(z,1)), floor(slice_yy - centers(z,2))], 'EdgeColor', 'r' ,'LineWidth',2);
                        %figure();
                        %imshow(imGray(centers(z,2):slice_yy, centers(z,1):slice_xx), []);
                        %pause(2);
                    end
                end
            end
        end
    end
end