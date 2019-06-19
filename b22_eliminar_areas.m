% (2.2) ELIMINAR �REAS EN LA IMAGEN

if exist('RGB','var')
    
    % Almacenamiento de Imagen a modificar
    RGB0 = RGB; R0 = R; G0 = G; B0 = B;
    % Selecci�n del color m�s repetido, para utilizarlo al borrar
    [count1, loc1] = imhist(R);
    [count2, loc2] = imhist(G);
    [count3, loc3] = imhist(B);
    [~, pos_max1] = max(count1);
    [~, pos_max2] = max(count2);
    [~, pos_max3] = max(count3);
    eraser1 = loc1(pos_max1);
    eraser2 = loc2(pos_max2);
    eraser3 = loc3(pos_max3);

    % Mostrar imagen y cuadro de di�logo con instrucciones
    warning off all
    figure,	imshow(RGB),
    warning on all
    menu_elim = menu({ ...
        '(2.2) ELIMINAR �REAS'
        'DEFINICI�N DE �REA A ELIMINAR'
        '________________________'
        ''
        'Realice un ZOOM al �rea que desea eliminar'
        ''
        'Seleccione puntos que envuelvan el �rea que'
        'desea eliminar, haciendo CLICK en la imagen'
        ''
        'Presione ENTER al finalizar selecci�n'
        '________________________'
        ''
        'Haga click en OK al finalizar el zoom'
        '(No cierre la imagen. Haga click en Cancelar'
        'o cierre esta ventana para salir de la'
        'definici�n de m�rgenes)'}, ...
        'OK', ...
        'Cancelar');

    switch menu_elim
        case 1
            % Selecci�n de puntos
            [x_elim, y_elim,    ~] = impixel;
            close
            % Creaci�n matriz con �rea a borrar
            E = zeros(rows,cols);
            for m = 1:length(x_elim)
                E(y_elim(m),x_elim(m)) = 1;
            end
            E = bwconvhull(E);
            % Borrado de �reas y escritura de RGB0
            R0(E == 1) = eraser1;
            G0(E == 1) = eraser2;
            B0(E == 1) = eraser3;
            RGB0(:,:,1) = R0; RGB0(:,:,2) = G0; RGB0(:,:,3) = B0; 
            
            % Comparaci�n antes y despu�s de la imagen. Guardar Cambios,
            % junto con versi�n anterior de la imagen
            run('c1_guardar_cambios_rgb')
            
            if menu_guardar == 1
                % Mensaje en la ventana de comandos
                disp(['- (2.2) Eliminar �reas                           TERMINADO!        ' datestr(now)])
            end

            % Cuadro de pregunta para seleccionar m�s �reas
            quest_elim = questdlg('�Desea seleccionar otra �rea para eliminar?','Selecci�n de �reas a eliminar','Si','No','Si');
            if all(quest_elim == 'Si')
                run('b22_eliminar_areas')
            end
        otherwise
            close
    end
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de eliminar �reas.','Error: Imagen no encontrada')
end