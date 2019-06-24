if exist('RGB','var')
    
    RGB0 = RGB; R0 = R; G0 = G; B0 = B;

    [count1, loc1] = imhist(R);
    [count2, loc2] = imhist(G);
    [count3, loc3] = imhist(B);
    [~, pos_max1] = max(count1);
    [~, pos_max2] = max(count2);
    [~, pos_max3] = max(count3);
    eraser1 = loc1(pos_max1);
    eraser2 = loc2(pos_max2);
    eraser3 = loc3(pos_max3);

    warning off all
    figure,	imshow(RGB),
    warning on all
    menu_elim = menu({ ...
        '(2.2) ERASE AREA'
        'DEFINE IMAGE AREA TO BE REMOVED'
        '________________________'
        ''
        'Please zoom in to the area where you wish to remove an element'
        ''
        'Clicking on the image, select points so as to surround the area that you wish to remove'
        ''
        'Hit ENTER when done'
        '________________________'
        ''
        'Click OK when done zooming'
        '(Do not close the image. Click “Cancel”'
        'or else close this window in order to exit)'}, ...
        'OK', ...
        'Cancel');

    switch menu_elim
        case 1
            [x_elim, y_elim,    ~] = impixel;
            close
            E = zeros(rows,cols);
            for m = 1:length(x_elim)
                E(y_elim(m),x_elim(m)) = 1;
            end
            E = bwconvhull(E);
            R0(E == 1) = eraser1;
            G0(E == 1) = eraser2;
            B0(E == 1) = eraser3;
            RGB0(:,:,1) = R0; RGB0(:,:,2) = G0; RGB0(:,:,3) = B0; 
            
            run('c1_guardar_cambios_rgb')
            
            if menu_guardar == 1
                disp(['- (2.2) Remove Elements                           COMPLETED!        ' datestr(now)])
            end

            quest_elim = questdlg('Do you wish to select another area in order to remove some element?','Define image area to be removed','Yes','No','Yes');
            if all(quest_elim == 'Yes')
                run('b22_eliminar_areas')
            end
        otherwise
            close
    end
else
    errordlg('You must select an image before removing elements.','Error: Image not found')
end