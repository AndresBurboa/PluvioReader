% (2.2) ELIMINAR ÁREAS EN BW

if exist('BW','var')

    % Mostrar imagen y cuadro de diálogo con instrucciones
    warning off all
    figure,	imshow(imcomplement(BW)),
    warning on all
    menu_elimbw = menu({ ...
        '(3.3) ELIMINAR ELEMENTOS SELECCIONADOS'
        'DEFINICIÓN DE ÁREA CON ELEMENTOS A ELIMINAR'
        '________________________'
        ''
        'Realice un ZOOM al elemnto que desea eliminar'
        ''
        'Seleccione puntos que envuelvan al elemento que'
        'desea eliminar, haciendo CLICK en la imagen'
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

    switch menu_elimbw
        case 1
            % Selección de puntos
            [x_elim_bw, y_elim_bw,    ~] = impixel;
            close
            % Definición de área a eliminar
            E_bw = zeros(rows,cols);
            for m = 1:length(x_elim_bw)
                E_bw(y_elim_bw(m),x_elim_bw(m)) = 1;
            end
            E_bw = bwconvhull(E_bw);
            % Borrado de área
            BW(E_bw == 1) = 0;
            
            % Comparación antes y después de la imagen. Guardar Cambios,
            % junto con versión anterior de la imagen
            run('c2_guardar_cambios_bw')
            
            if menu_guardar == 1
                % Mensaje en la ventana de comandos
                disp(['- (3.3) Eliminar Elementos (manual)              TERMINADO!        ' datestr(now)])
            end

            % Cuadro de pregunta para seleccionar más áreas
            quest_elimbw = questdlg('¿Desea seleccionar otra área con elementos a eliminar?','Eliminar Elementos','Si','No','Si');
            if all(quest_elimbw == 'Si')
                run('b33_eliminar_bw')
            end
        otherwise
            close
    end
elseif exist('RGB','var') && ~ exist('BW','var')
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la línea antes de borrar áreas.','Error: Imagen no encontrada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de eliminar áreas.','Error: Imagen no encontrada')
end