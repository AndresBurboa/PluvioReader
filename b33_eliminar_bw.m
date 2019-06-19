% (2.2) ELIMINAR �REAS EN BW

if exist('BW','var')

    % Mostrar imagen y cuadro de di�logo con instrucciones
    warning off all
    figure,	imshow(imcomplement(BW)),
    warning on all
    menu_elimbw = menu({ ...
        '(3.3) ELIMINAR ELEMENTOS SELECCIONADOS'
        'DEFINICI�N DE �REA CON ELEMENTOS A ELIMINAR'
        '________________________'
        ''
        'Realice un ZOOM al elemnto que desea eliminar'
        ''
        'Seleccione puntos que envuelvan al elemento que'
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

    switch menu_elimbw
        case 1
            % Selecci�n de puntos
            [x_elim_bw, y_elim_bw,    ~] = impixel;
            close
            % Definici�n de �rea a eliminar
            E_bw = zeros(rows,cols);
            for m = 1:length(x_elim_bw)
                E_bw(y_elim_bw(m),x_elim_bw(m)) = 1;
            end
            E_bw = bwconvhull(E_bw);
            % Borrado de �rea
            BW(E_bw == 1) = 0;
            
            % Comparaci�n antes y despu�s de la imagen. Guardar Cambios,
            % junto con versi�n anterior de la imagen
            run('c2_guardar_cambios_bw')
            
            if menu_guardar == 1
                % Mensaje en la ventana de comandos
                disp(['- (3.3) Eliminar Elementos (manual)              TERMINADO!        ' datestr(now)])
            end

            % Cuadro de pregunta para seleccionar m�s �reas
            quest_elimbw = questdlg('�Desea seleccionar otra �rea con elementos a eliminar?','Eliminar Elementos','Si','No','Si');
            if all(quest_elimbw == 'Si')
                run('b33_eliminar_bw')
            end
        otherwise
            close
    end
elseif exist('RGB','var') && ~ exist('BW','var')
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la l�nea antes de borrar �reas.','Error: Imagen no encontrada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de eliminar �reas.','Error: Imagen no encontrada')
end