warning off all
figure,	imshow(RGB),
warning on all
menu_traz2 = menu({ ...
    '(2.3) DRAW LINE'
    'DRAW WITH SELECTED COLOR (2)'
    '________________________'
    ''
    'ZOOM to the area where you want to draw the line'
    ''
    'Draw the line with straight segments,'
    'successively CLICKING on the image in order to define each segment'
    ''
    'Hit ENTER when done'
    '________________________'
    ''
    'Click OK when done zooming'
    '(Do not close the image. Click “Cancel”'
    'or else close this window in order to exit)'}, ...
    'OK', ...
    'Cancel');

switch menu_traz2
    case 1
        [x_traz,y_traz,~,~,~] = improfile;
        close
        x_traz = round(x_traz);
        y_traz = round(y_traz);
        L = zeros(rows,cols);
        for m = 1:numel(x_traz)
            L(y_traz(m),x_traz(m)) = 1;
        end
        L = bwmorph(L,'bridge');
        R0(L == 1) = color_pixel1;
        G0(L == 1) = color_pixel2;
        B0(L == 1) = color_pixel3;
        RGB0(:,:,1) = R0; RGB0(:,:,2) = G0; RGB0(:,:,3) = B0;
        
        run('c1_guardar_cambios_rgb')
        
        if menu_guardar == 1
            disp(['- (2.3) Draw Line                             COMPLETED!        ' datestr(now)])
        end

        quest_traz2 = questdlg('Do you wish to draw another line on the image?','Draw line','Yes','No','Yes');
        if all(quest_traz2 == 'Yes')
            run('b23_trazar_linea_pt2')
        end
    otherwise
        close
end