% (2.3) TRAZAR LÍNEA EN LA IMAGEN. Parte 1

if exist('RGB','var')
    
    % Almacenamiento de Imagen a modificar
    RGB0 = RGB; R0 = R; G0 = G; B0 = B;
    
    if exist('color_pixel','var') && numel(color_pixel) == 3
        % Cuadro de pregunta para mantener color de pixel
        quest_traz1 = questdlg(['Ya existe un color de línea definido. ' ...
            '¿Desea utilizar este mismo color para realizar la siguiente línea?'],'Trazado de línea','Si','No','Si');
        switch quest_traz1
            case 'Si'
                % Correr solo parte 2 del programa
                run('b23_trazar_linea_pt2')
            otherwise
                % Borrar color de pixel y volver a correr
                clear color_pixel color_pixel1 color_pixel2 color_pixel3
                run('b23_trazar_linea')
        end
    else
        % Mostrar inicio de línea y cuadro de diálogo con instrucciones (1)
        warning off all
        figure,	imshow(RGB), set(gcf,'Position',[300 100 800 500]), set(gca,'xlim',[0.02*cols 0.06*cols],'ylim',[0.9*rows rows])
        warning on all
        menu_traz1 = menu({ ...
            '(2.3) TRAZAR LÍNEA'
            'SELECCIÓN DE COLOR DE LINEA (1)'
            '________________________'
            ''
            'Realice un ZOOM al color de linea'
            'que desea utilizar'
            ''
            'Seleccione el pixel con el color,'
            'haciendo CLICK en la imagen'
            ''
            'Presione ENTER al finalizar selección'
            '________________________'
            ''
            'Haga click en OK al finalizar el zoom'
            '(No cierre la imagen. Haga click en Cancelar'
            'o cierre esta ventana para salir de la'
            'definición de márgenes)'}, ...
            'OK', ...
            'Cancelar');

            switch menu_traz1
                case 1
                    % Selección de pixel
                    [~, ~, color_pixel] = impixel;
                    close
                    color_pixel1 = round(mean(color_pixel(:,1)));
                    color_pixel2 = round(mean(color_pixel(:,2)));
                    color_pixel3 = round(mean(color_pixel(:,3)));
                    
                    % Correr parte 2 del programa
                    run('b23_trazar_linea_pt2')
                    
                otherwise
                    close
            end
    end 
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de trazar una línea.','Error: Imagen no encontrada')
end