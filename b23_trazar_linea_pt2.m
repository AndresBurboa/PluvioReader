% (2.3) TRAZAR LÍNEA EN LA IMAGEN. Parte 2

% Mostrar inicio de línea y cuadro de diálogo con
% instrucciones (2)
warning off all
figure,	imshow(RGB),
warning on all
menu_traz2 = menu({ ...
    '(2.3) TRAZAR LÍNEA'
    'DEFINICIÓN DEL TRAZADO DE LINEA (2)'
    '________________________'
    ''
    'Realice un ZOOM al área donde trazará la linea'
    ''
    'Dibuje la linea a partir de segmentos rectos,'
    'haciendo CLICK en la imagen para definir cada uno'
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

switch menu_traz2
    case 1
        % Trazado de línea
        [x_traz,y_traz,~,~,~] = improfile;
        close
        x_traz = round(x_traz);
        y_traz = round(y_traz);
        % Almacenamiento matriz con línea a trazar
        L = zeros(rows,cols);
        for m = 1:numel(x_traz)
            L(y_traz(m),x_traz(m)) = 1;
        end
        % (Al parecer) por redondeo la linea queda segmentada
        L = bwmorph(L,'bridge');
        % Trazado de linea y escritura de RGB0
        R0(L == 1) = color_pixel1;
        G0(L == 1) = color_pixel2;
        B0(L == 1) = color_pixel3;
        RGB0(:,:,1) = R0; RGB0(:,:,2) = G0; RGB0(:,:,3) = B0;
        
        % Comparación antes y después de la imagen. Guardar Cambios, junto 
        % con versión anterior de la imagen
        run('c1_guardar_cambios_rgb')
        
        if menu_guardar == 1
            % Mensaje en la ventana de comandos
            disp(['- (2.3) Trazar Línea                             TERMINADO!        ' datestr(now)])
        end

        % Cuadro de pregunta para trazar más líneas
        quest_traz2 = questdlg('¿Desea trazar otra linea en la imagen?','Trazado de línea','Si','No','Si');
        if all(quest_traz2 == 'Si')
            run('b23_trazar_linea_pt2')
        end
otherwise
    close
end