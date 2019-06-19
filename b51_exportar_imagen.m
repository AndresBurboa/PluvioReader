% EXPORTAR IMAGEN (RGB O BW)

% Si existe la imagen rgb y bw
if exist('RGB','var') && exist('BW','var')
    
    % Preguntar por imagen que se desea exportar
    quest_exp = questdlg('¿Qué imagen desea exportar?','Exportar Imagen','Color','Binaria','Cancelar','Binaria');
    
    % Guardado de imagen
    switch quest_exp
        case 'Color'
            % Definir carpeta de destino
            [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','Todos los Archivos de Imagen'; ...
                '*.*','Todos los Archivos'},'Exportar Imagen',['rgb_' filename '.jpg']);
            % Escribir imagen RGB
            if ischar(file_export_im) && ischar(path_export_im)
                imwrite(RGB,[path_export_im file_export_im])
            end
        case 'Binaria'
            % Definir carpeta de destino
            [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','Todos los Archivos de Imagen'; ...
                '*.*','Todos los Archivos'},'Exportar Imagen',['bw_' filename '.jpg']);
            % Escribir imagen BW
            if ischar(file_export_im) && ischar(path_export_im)
                % Exportar imagen con márgenes marcados
                BW2(:, :, 1) = imcomplement(BW);
                BW2(:, :, 2) = imcomplement(BW);
                BW2(:, :, 3) = imcomplement(BW);
                margenes = [ x_margen1, y_margen1; x_margen2, y_margen2; ...
                            x_margen3, y_margen3; x_margen4, y_margen4 ];
                radio_cruz = 20;
                espesor_cruz = 2;
                for m = 1:size(margenes,1)
                    % Parte vertical cruz
                    BW2(margenes(m,2)-radio_cruz:margenes(m,2)+radio_cruz, margenes(m,1)-espesor_cruz:margenes(m,1)+espesor_cruz, 2) = 0;
                    BW2(margenes(m,2)-radio_cruz:margenes(m,2)+radio_cruz, margenes(m,1)-espesor_cruz:margenes(m,1)+espesor_cruz, 3) = 0;
                    % Parte horizontal cruz
                    BW2(margenes(m,2)-espesor_cruz:margenes(m,2)+espesor_cruz, margenes(m,1)-radio_cruz:margenes(m,1)+radio_cruz, 2) = 0;
                    BW2(margenes(m,2)-espesor_cruz:margenes(m,2)+espesor_cruz, margenes(m,1)-radio_cruz:margenes(m,1)+radio_cruz, 3) = 0;
                end
                imwrite(BW2,[path_export_im file_export_im])
            end
    end

% Si solo existe la imagen rgb
elseif exist('RGB','var') && exist('BW','var') == 0
    
    % Guardado de imagen
    [file_export_im, path_export_im] = uiputfile({'*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','Todos los Archivos de Imagen'; ...
        '*.*','Todos los Archivos'},'Exportar Imagen',['rgb_' filename '.jpg']);
    if ischar(file_export_im) && ischar(path_export_im)
        imwrite(RGB,[path_export_im file_export_im])
    end
    
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de exportar.','Error: Imagen no encontrada')
end