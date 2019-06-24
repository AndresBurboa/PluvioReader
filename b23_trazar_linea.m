if exist('RGB','var')
    
    RGB0 = RGB; R0 = R; G0 = G; B0 = B;
    
    if exist('color_pixel','var') && numel(color_pixel) == 3
        quest_traz1 = questdlg(['A line color has already been selected. ' ...
            '¿Do you wish to use the same line color to digitize your next pluviogram?'],'Trace line','Yes','No','Yes');
        switch quest_traz1
            case 'Yes'
                run('b23_trazar_linea_pt2')
            otherwise
                clear color_pixel color_pixel1 color_pixel2 color_pixel3
                run('b23_trazar_linea')
        end
    else
        warning off all
        figure,	imshow(RGB), set(gcf,'Position',[300 100 800 500]), set(gca,'xlim',[0.02*cols 0.06*cols],'ylim',[0.9*rows rows])
        warning on all
        menu_traz1 = menu({ ...
            '(2.3) DRAW LINE'
            'SELECT LINE COLOR (1)'
            '________________________'
            ''
            'Please ZOOM to a line with the color'
            'you would like to use'
            ''
            'Select a line pixel with the color you would like to use,'
            'clicking on the image'
            ''
            'Hit ENTER when done'
            '________________________'
            ''
            'Click OK when done zooming'
            '(Do not close the image. Click “Cancel”'
            'or else close this window in order to exit)'}, ...
            'OK', ...
            'Cancel');

            switch menu_traz1
                case 1
                    [~, ~, color_pixel] = impixel;
                    close
                    color_pixel1 = round(mean(color_pixel(:,1)));
                    color_pixel2 = round(mean(color_pixel(:,2)));
                    color_pixel3 = round(mean(color_pixel(:,3)));
                    
                    run('b23_trazar_linea_pt2')
                    
                otherwise
                    close
            end
    end 
else
    errordlg('You must select an image before drawing the line.','Error: Image not found')
end