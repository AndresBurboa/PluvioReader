% (2.3) TRAZAR L�NEA EN LA IMAGEN. Parte 2

% Mostrar inicio de l�nea y cuadro de di�logo con
% instrucciones (2)
warning off all
figure,	imshow(RGB),
warning on all
menu_traz2 = menu({ ...
    '(2.3) TRAZAR L�NEA'
    'DEFINICI�N DEL TRAZADO DE LINEA (2)'
    '________________________'
    ''
    'Realice un ZOOM al �rea donde trazar� la linea'
    ''
    'Dibuje la linea a partir de segmentos rectos,'
    'haciendo CLICK en la imagen para definir cada uno'
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

switch menu_traz2
    case 1
        % Trazado de l�nea
        [x_traz,y_traz,~,~,~] = improfile;
        close
        x_traz = round(x_traz);
        y_traz = round(y_traz);
        % Almacenamiento matriz con l�nea a trazar
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
        
        % Comparaci�n antes y despu�s de la imagen. Guardar Cambios, junto 
        % con versi�n anterior de la imagen
        run('c1_guardar_cambios_rgb')
        
        if menu_guardar == 1
            % Mensaje en la ventana de comandos
            disp(['- (2.3) Trazar L�nea                             TERMINADO!        ' datestr(now)])
        end

        % Cuadro de pregunta para trazar m�s l�neas
        quest_traz2 = questdlg('�Desea trazar otra linea en la imagen?','Trazado de l�nea','Si','No','Si');
        if all(quest_traz2 == 'Si')
            run('b23_trazar_linea_pt2')
        end
otherwise
    close
end