if exist('BW','var')

    warning off all
    figure,	imshow(imcomplement(BW))
    warning on all
    menu_unirbw = menu({ ...
        '(3.4) JOIN ELEMENTS'
        'DEFINING THE JOINED LINE'
        '________________________'
        ''
        'ZOOM to the area where you will join elements'
        ''
        'Draw the line with straight segments,'
        'clicking on the image'
        ''
        '________________________'
        ''
        'Click OK when done zooming'
        '(Do not close the image. Click “Cancel”'
        'or else close this window in order to exit)'}, ...
        'OK', ...
        'Cancel');

    switch menu_unirbw
        case 1
            [x_unir_bw,y_unir_bw,~,~,~] = improfile;
            close
            x_unir_bw = round(x_unir_bw);
            y_unir_bw = round(y_unir_bw);

            L_bw = zeros(rows,cols);
            for m = 1:numel(x_unir_bw)
                L_bw(y_unir_bw(m),x_unir_bw(m)) = 1;
            end
            
            L_bw = bwmorph(L_bw,'bridge');
            BW(L_bw == 1) = 1;

            run('c2_guardar_cambios_bw')

            if menu_guardar == 1
                disp(['- (3.4) Join Elements (manual)                  COMPLETED!' datestr(now)])
            end

            quest_unirbw = questdlg('Do you wish to join more elements of this image?','Join Elements','Yes','No','Yes');
            if all(quest_unirbw == 'Yes')
                run('b34_unir_bw')
            end
    otherwise
        close
    end
    
elseif exist('RGB','var') && exist('BW','var') == 0
    errordlg('You must identify the line before joining elements.','Error: Line not identified')
else
    errordlg('You must select an image before removing areas.','Error: Image not found')
end