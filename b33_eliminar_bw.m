if exist('BW','var')

    warning off all
    figure,	imshow(imcomplement(BW)),
    warning on all
    menu_elimbw = menu({ ...
        '(3.3) REMOVE SELECTED ELEMENTS'
        'DEFINE AREA CONTAINING ELEMENTS TO BE REMOVED'
        '________________________'
        ''
        'ZOOM to that element you wish to remove'
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

    switch menu_elimbw
        case 1
            [x_elim_bw, y_elim_bw,    ~] = impixel;
            close
            E_bw = zeros(rows,cols);
            for m = 1:length(x_elim_bw)
                E_bw(y_elim_bw(m),x_elim_bw(m)) = 1;
            end
            E_bw = bwconvhull(E_bw);
            BW(E_bw == 1) = 0;
            
            run('c2_guardar_cambios_bw')
            
            if menu_guardar == 1
                disp(['- (3.3) Remove Elements (manual)              COMPLETED!        ' datestr(now)])
            end

            quest_elimbw = questdlg('Do you wish to select some other area with elements to be removed?','Remove Elements','Yes','No','Yes');
            if all(quest_elimbw == 'Yes')
                run('b33_eliminar_bw')
            end
        otherwise
            close
    end
elseif exist('RGB','var') && ~ exist('BW','var')
    errordlg('You must identify the line before removing elements.','Error: Line not identified')
else
    errordlg('You must select an image before removing elements.','Error: Image not found')
end