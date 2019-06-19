% (3.1) IDENTIFICAR LINEA EN IMAGEN

if 1 || exist('RGB','var') && exist('x_margen','var')

    if exist('C','var') && ~ isempty(C) && numel(size(cell2mat(C(end)))) == 2
        % Cuadro de pregunta para redefinir imagen binaria
        quest_ident = questdlg(['Ya existe una o más versiones guardadas de imagen binaria. ' ...
            '¿Desea eliminarlas e identificar nuevamente la línea?'],'Identificar Línea','Si','No','Si');
        switch quest_ident
            case 'Si'
                while numel(size(cell2mat(C(end)))) == 2
                    C(end) = [];
                end
                % Correr nuevamente el programa
                run('b31_identificar_linea')
        end
    else
        
        % Prealojar BW0
        BW0 = RGB;
        
        % Transformación a formato double de las matrices RGB
        RR = double(R);
        GG = double(G);
        BB = double(B);
        
        % Recálculo de imágen de mínimos RGB_min y grilla BW_grid
        RGB_min = min(RGB,[],3);
        BW_grid = RGB_min <= umb_grid;      % umb_grid se calculó al definir márgenes (b13)
        
        % Nótese que el complemento de BW_grid corresponderá a la imagen
        % binaria de fondo BW_back (BW_grid = ~ BW_back)
        
        % MATRIZ DE DIFERENCIA DEL COLOR AZUL RESPECTO A LOS DEMÁS
        % (diff_B), en la forma de imagen en escala de grises (aunque no
        % está en formato uint8)
        diff_B = BB - RR + BB - GG;
        diff_B = (diff_B - min(min(diff_B)))/(max(max(diff_B)) - min(min(diff_B)))*255;

        % CÁLCULO DEL UMBRAL DE INTENSIDAD QUE SEPARA A LA LÍNEA DE LA
        % GRILLA Y EL FONDO
        
        % Existe un valor umbral de intensidad que separa a la línea de la
        % grilla y el fondo en la imagen de diferencias diff_B.
        % El valor de ese umbral corresponde al punto de cambio de
        % tendencia en un gráfico de distribución de frecuencia acumulada
        % de color (normalizado)

        % Para encontrar el cambio de tendencia se verifica que la
        % distribución cumpla ciertos requisitos relativos a primera y
        % segunda derivada numérica para algún umbral de color (bla bla...
        % análogo a b13)
        
        % Cantidad de umbrales de color, y umbrales iniciales
        num_umb = 5;            % minimo 3
        d_umb = 1;
        umb = (0:num_umb-1)*d_umb;

        % Porcentajes iniciales bajo umbral
        rate = zeros(size(umb));
        for k = 1:num_umb
            rate(k) = sum(sum(diff_B <= umb(k)))/(rows*cols);
        end
        % Y su primera y segunda variación
        slope = abs(diff(rate))/d_umb;
        slope2 = abs(diff(slope))/d_umb;

        % Máximos permitidos para porcentajes, ...
        rate_min = 0.5;
        slope_max = 2e-3;       % 1.5e-3 o 2e-3;
        slope2_max = 0.5e-3;
        % Rutina de búsqueda
        while any(rate < rate_min) || any(slope > slope_max) || any(slope2 > slope2_max)
            % Redefinición de umbrales, porcentajes, etc...
            umb = umb + d_umb;
            rate(1:end-1) = rate(2:end);
            rate(end) = sum(sum(diff_B <= umb(end)))/(rows*cols);
            slope(1:end-1) = slope(2:end);
            slope(end) = abs(rate(end-1) - rate(end))/d_umb;
            slope2(1:end-1) = slope2(2:end);
            slope2(end) = abs(slope(end-1) - slope(end))/d_umb;
            % Umbral que separa a la línea de la grilla y el fondo
            umb_line = umb(2);
        end
        % IMAGEN BINARIA DE LA LÍNEA solo si se considera la diferencia
        % respecto al color azul BW_diff_B
        BW_diff_B = diff_B >= umb_line;
        
        % Graficar imagen BW
        figure, imshow(imcomplement(BW_diff_B))
        
        % Ventana de selección de alternativa
        menu_identif1 = menu({ ...
            '(3.1) IDENTIFICAR LÍNEA'
            'SELECCIÓN DE ALTERNATIVA'
            '________________'
            ''
            'Si la línea se encuentra bien definida,'
            'presione "Aceptar".'
            ''
            'Si la línea no se encuentra bien definida'
            'y desea probar otras alternativas,'
            'presione "Otras Alternativas".'
            ''
            'Y si desea salir de la identificación'
            'presione "Cancelar"'}, ...
            'Aceptar', ...
            'Otras Alternativas', ...
            'Cancelar');
        close
        
        switch menu_identif1
            case 1
                % IMAGEN BINARIA DE LA LÍNEA BW
                BW = BW_diff_B;
                
            case 2
                % Diferencias umbral entre colores RGB (alternativa 3)
                dif_gb = 10;
                % Alternativa 1
                bw1 = B > R & B > G;
                % Alternativa 2
                bw2 = B > R | B > G;
                % Alternativa 3 (alternativa 1 mejorada)
                bw3 = B > R & B > G | (R > G & G - B < dif_gb);

                % Número de alternativas (variable inventada por flojera cuando no
                % sabía si habría 2 o 3 opciones)
                n_alt = 3;
                % Graficar alternativas
                figure, subplot(n_alt,1,1), imshow(imcomplement(bw1)), title('Alternativa 1','FontWeight','bold','FontSize',12)
                        subplot(n_alt,1,2), imshow(imcomplement(bw2)), title('Alternativa 2','FontWeight','bold','FontSize',12)
                        subplot(n_alt,1,3), imshow(imcomplement(bw3)), title('Alternativa 3','FontWeight','bold','FontSize',12)

                % Ventana de selección de alternativa
                menu_identif2 = menu({ ...
                    '(3.1) IDENTIFICAR LÍNEA'
                    'SELECCIÓN DE ALTERNATIVA'
                    '________________'
                    ''
                    'Seleccione la alternativa que'
                    'mejor represente a la línea'}, ...
                    'Alternativa 1', ...
                    'Alternativa 2', ...
                    'Alternativa 3', ...
                    'Cancelar');
                close
                switch menu_identif2
                    case 1
                        BW = bw1;
                    case 2
                        BW = bw2;
                    case 3
                        BW = bw3;
                end
        end
        
        if menu_identif1 == 1 || ( exist('menu_identif2','var') && (menu_identif2 == 1 || menu_identif2 == 2 || menu_identif2 == 3) )
            % Comparación antes y después de la imagen. Guardar cambios
            % junto con versión anterior de la imagen
            run('c2_guardar_cambios_bw')

            if menu_guardar == 1
                % Mensaje en la ventana de comandos
                disp(['- (3.1) Identificar Línea                        TERMINADO!        ' datestr(now)])
            end
        else
            close
        end
        
    end
elseif ~ exist('RGB','var')
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de identificar línea.','Error: Imagen no encontrada')
elseif ~ exist('x_margen','var')
    % Cuadro de error en caso de no haber definido los márgenes de registro
    errordlg('Debe definir los márgenes de registro antes de unir y eliminar elementos.','Error: Márgenes no Definidos')
end