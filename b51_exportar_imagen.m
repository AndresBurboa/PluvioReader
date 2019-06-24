if exist('RGB','var') && exist('BW','var')
    
    quest_exp = questdlg('Which image do you wish to export?','Export Image','Color','Binary','Cancel','Binary');
    
    switch quest_exp
        case 'Color'
            [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','All Image Files'; ...
                '*.*','All Files'},'Export Image',['rgb_' filename '.jpg']);
            if ischar(file_export_im) && ischar(path_export_im)
                imwrite(RGB,[path_export_im file_export_im])
            end
        case 'Binary'
            [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','All Image Files'; ...
                '*.*','All Files'},'Export Image',['bw_' filename '.jpg']);
            if ischar(file_export_im) && ischar(path_export_im)
                BW2(:, :, 1) = imcomplement(BW);
                BW2(:, :, 2) = imcomplement(BW);
                BW2(:, :, 3) = imcomplement(BW);
                margenes = [ x_margen1, y_margen1; x_margen2, y_margen2; ...
                            x_margen3, y_margen3; x_margen4, y_margen4 ];
                radio_cruz = 20;
                espesor_cruz = 2;
                for m = 1:size(margenes,1)
                    BW2(margenes(m,2)-radio_cruz:margenes(m,2)+radio_cruz, margenes(m,1)-espesor_cruz:margenes(m,1)+espesor_cruz, 2) = 0;
                    BW2(margenes(m,2)-radio_cruz:margenes(m,2)+radio_cruz, margenes(m,1)-espesor_cruz:margenes(m,1)+espesor_cruz, 3) = 0;
                    
                    BW2(margenes(m,2)-espesor_cruz:margenes(m,2)+espesor_cruz, margenes(m,1)-radio_cruz:margenes(m,1)+radio_cruz, 2) = 0;
                    BW2(margenes(m,2)-espesor_cruz:margenes(m,2)+espesor_cruz, margenes(m,1)-radio_cruz:margenes(m,1)+radio_cruz, 3) = 0;
                end
                imwrite(BW2,[path_export_im file_export_im])
            end
    end

elseif exist('RGB','var') && exist('BW','var') == 0
    
    [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','All Image Files'; ...
        '*.*','All Files'},'Export Image',['rgb_' filename '.jpg']);
    if ischar(file_export_im) && ischar(path_export_im)
        imwrite(RGB,[path_export_im file_export_im])
    end
    
else
    errordlg('You must select an image before exporting.','Error: Image not found')
end