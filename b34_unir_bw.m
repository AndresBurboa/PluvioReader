% (3.4) UNIR ELEMENTOS EN BW

if exist('BW','var')

    % Mostrar imagen y cuadro de di�logo con instrucciones
    warning off all
    figure,	imshow(imcomplement(BW))
    warning on all
    menu_unirbw = menu({ ...
        '(3.4) UNIR ELEMENTOS'
        'DEFINICI�N DE LINEA DE UNI�N'
        '________________________'
        ''
        'Realice un ZOOM al �rea donde unir� elementos'
        ''
        'Dibuje la linea a partir de segmentos rectos,'
        'haciendo CLICK en la imagen'
        ''
        'Presione ENTER al finalizar zoom'
        '________________________'
        ''
        'Haga click en OK al finalizar el zoom'
        '(No cierre la imagen. Haga click en Cancelar'
        'o cierre esta ventana para salir de la'
        'definici�n de m�rgenes)'}, ...
        'OK', ...
        'Cancelar');

    switch menu_unirbw
        case 1
            % Trazado de l�nea
            [x_unir_bw,y_unir_bw,~,~,~] = improfile;
            close
            x_unir_bw = round(x_unir_bw);
            y_unir_bw = round(y_unir_bw);
            % Almacenamiento matriz con l�nea a trazar
            L_bw = zeros(rows,cols);
            for m = 1:numel(x_unir_bw)
                L_bw(y_unir_bw(m),x_unir_bw(m)) = 1;
            end
            % (Al parecer) por redondeo la linea queda segmentada
            L_bw = bwmorph(L_bw,'bridge');
            % Escribir uni�n en BW
            BW(L_bw == 1) = 1;

            % Comparaci�n antes y despu�s de la imagen. Guardar Cambios, junto 
            % con versi�n anterior de la imagen
            run('c2_guardar_cambios_bw')

            if menu_guardar == 1
                % Mensaje en la ventana de comandos
                disp(['- (3.4) Unir Elementos (manual)                  TERMINADO!        ' datestr(now)])
            end

            % Cuadro de pregunta para seleccionar unir m�s elementos
            quest_unirbw = questdlg('�Desea unir m�s elementos de la imagen?','Unir Elementos','Si','No','Si');
            if all(quest_unirbw == 'Si')
                run('b34_unir_bw')
            end
    otherwise
        close
    end
    
elseif exist('RGB','var') && exist('BW','var') == 0
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la l�nea antes de borrar �reas.','Error: Imagen no encontrada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de eliminar �reas.','Error: Imagen no encontrada')
end