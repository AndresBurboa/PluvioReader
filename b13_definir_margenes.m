% (1.3) DEFINIR MÁRGENES DEL ÁREA DE REGISTRO

if exist('RGB','var') && exist('fecha_inicio','var') && exist('fecha_termino','var')
    
    % DEFINICIÓN DE VARIABLES DE ENTRADA dependiendo del pluviograma
    % Si es un pluviograma semanal
    if round( datenum(fecha_termino,'dd/mm/yyyy') - datenum(fecha_inicio,'dd/mm/yyyy') ) == 7
        num_div_v = 14;             % dos divisiones por cada día
        pos_first8 = 2;             % cantidad de peaks hasta las 8 hrs iniciales
        pos_last8 = 86;             % cantidad de peaks hasta las 8 hrs finales
        mpd_v = round(0.01*cols);   % distancia mínima entre peaks verticales
        mpd_h = round(0.08*rows);   % y entre peaks horizontales
    % O si es un pluviograma diario
    elseif round( datenum(fecha_termino,'dd/mm/yyyy') - datenum(fecha_inicio,'dd/mm/yyyy') ) == 1
        num_div_v = 12;             % una división cada dos horas
        pos_first8 = 5;             % cantidad de peaks hasta las 8 hrs iniciales
        pos_last8 = 101;            % cantidad de peaks hasta las 8 hrs finales
        mpd_v = round(0.01*cols);   % distancia mínima entre peaks verticales
        mpd_h = round(0.08*rows);   % y entre peaks horizontales
    end
    % Transformación a formato double de las matrices RGB
    RR = double(R);
    GG = double(G);
    BB = double(B);
    
    % CÁLCULO DE IMAGEN DE MÍNIMOS EN RGB Y DEL UMBRAL DE INTENSIDAD QUE
    % SEPARA A LA GRILLA (Y LA LÍNEA) DEL FONDO
    
    % Existe un valor umbral de intensidad que separa a la grilla (y la
    % línea) del fondo en la imagen de mínimos (RGB_min).
    % El valor de ese umbral corresponde al punto de cambio de tendencia
    % en un gráfico del porcentaje de la imagen bajo cierto umbral vs el
    % umbral de color asociado
    
    % Para encontrar el cambio de tendencia se verifica que el porcentaje
    % bajo umbral cumpla ciertos criterios para una ventana de umbrales de
    % color específica. Además debe cumplirse otros criterios para la
    % pendiente entre dichos umbrales, y para la tasa de cambio de la
    % pendiente (que llamaremos primera y segunda variación)
    
    % Imagen de mínimos RGB
    RGB_min = min(RGB,[],3);
    
    % Cantidad de umbrales de color, y umbrales iniciales
    num_umb = 5;            % minimo 3, para la segunda variación
    d_umb = 1;
    umb = (0:num_umb-1)*d_umb + (255 - num_umb + 1);
    
    % Porcentajes iniciales bajo umbral
    rate = zeros(size(umb));
    for k = 1:num_umb
        rate(k) = sum(sum(RGB_min <= umb(k)))/(rows*cols);
    end
    % Y la primera y segunda variación de los porcentajes
    slope = abs(diff(rate))/d_umb;
    slope2 = abs(diff(slope))/d_umb;
    
    % Máximos permitidos para porcentajes, primeras y segundas variaciones
    rate_max = 0.5;
    slope_max = 1e-2;       % 1.5e-3 o 2e-3;
    slope2_max = 0.5e-3;
    % Rutina de búsqueda
    while any(rate > rate_max) || any(slope > slope_max) || any(slope2 > slope2_max)
        % Redefinición de umbrales, porcentajes, etc...
        umb = umb - d_umb;
        rate(2:end) = rate(1:end-1);
        rate(1) = sum(sum(RGB_min <= umb(1)))/(rows*cols);
        slope(2:end) = slope(1:end-1);
        slope(1) = abs(rate(1) - rate(2))/d_umb;
        slope2(2:end) = slope2(1:end-1);
        slope2(1) = abs(slope(1) - slope(2))/d_umb;
        % Umbral que separa la grilla del fondo
        umb_grid = umb(end-1);
    end
    % IMAGEN BINARIA DE LA GRILLA BW_grid
    % (incluirá a la línea, pero es despreciable)
    BW_grid = RGB_min <= umb_grid;
    % Suma vertical y horizontal de BW_grid
    sum_vert = sum(BW_grid);
    sum_horz = sum(BW_grid,2);
    
    % CÁLCULO DE LOS PEAKS DE DICHOS VECTORES DE SUMAS (FUNCIONA BIEN SOLO
    % PARA PLUVIOGRAMAS SEMANALES, SE DEBE DETERMINAR EL MinPeakDistance
    % PARA PLUVIOGRAMAS DIARIOS. MODIFICAR CÓDIGO líneas 18 y 19)
    mph_v = mean(sum_vert);      % valor mínimo de los peaks verticales
    mph_h = mean(sum_horz);      % y de los peaks horizontales
    [peaks_v, ind_v] = findpeaks(sum_vert,'MinPeakHeight',mph_v,'MinPeakDistance',mpd_v);
    [peaks_h, ind_h] = findpeaks(sum_horz,'MinPeakHeight',mph_h,'MinPeakDistance',mpd_h);
    
    % Corrección de la posición de los peaks si se encuentran muy cerca de
    % los bordes de la imagen
    d_umb_edge = 20;      % distancia umbral a los bordes
    while ind_v(1) < d_umb_edge
        ind_v(1) = [];
        peaks_v(1) = [];
    end
    while ind_v(end) < d_umb_edge
        ind_v(end) = [];
        peaks_v(end) = [];
    end
    while ind_h(1) < d_umb_edge
        ind_h(1) = [];
        peaks_h(1) = [];
    end
    while ind_h(end) < d_umb_edge
        ind_h(end) = [];
        peaks_h(end) = [];
    end
    
    % Corrección de la posición de los peaks en caso de haber espacios muy
    % grandes entre cada uno
    diff_ind_v = diff(ind_v);
    for n = 1:numel(diff_ind_v)
        if diff_ind_v(n) > 1.5*mean(diff_ind_v)
            ind_v = [ind_v(1:n), round((ind_v(n) + ind_v(n+1))/2), ind_v(n+1:end)];
            peaks_v = [peaks_v(1:n), sum_vert(ind_v(n+1)), peaks_v(n+1:end)];
        end
    end
    diff_ind_h = diff(ind_h);
    for n = 1:numel(diff_ind_h)
        if diff_ind_h(n) > 1.5*mean(diff_ind_h)
            ind_h = [ind_h(1:n), round((ind_h(n) + ind_h(n+1))/2), ind_h(n+1:end)];
            peaks_h = [peaks_h(1:n), sum_horz(ind_h(n+1)), peaks_h(n+1:end)];
        end
    end
    
    % Definición de los MÁRGENES DE LA GRILLA a partir de los peaks
    % Para el vector yy, la posición de los 0 y 10 mm en general
    % corresponde a la del primer y último peak
    xx = [ind_v(pos_first8), ind_v(pos_last8), ind_v(pos_first8), ind_v(pos_last8)];
    yy = [ind_h(1), ind_h(1), ind_h(end), ind_h(end)];
    
    % CORRECCIÓN DE LOS MÁRGENES en función de los pixeles cercanos que
    % tengan color parecido al de la grilla
    % Criterio de corrección, combinación de RGB_min y exageración del
    % valor de los pixeles de fondo y notoriamente azules
    Crit_corr = double(RGB_min); %abs(double(RGB_min) - umb_grid);
    Crit_corr(~ BW_grid) = 1e3;
    % Dimensiones de las zonas de búsqueda y cálculo de las correcciones
    dx = 10;        % (mitad de la) distancia horizontal que define la zona de búsqueda de márgenes corregidos
    dy = 20;        % (mitad de la) distancia vertical que define la zona de búsqueda de márgenes corregidos
    di1 = 20;       % (mitad de la) longitud vertical de cálculo
    dj1 = 1;        % (mitad del) grosor de la longitud vertical
    di2 = 2;        % (mitad del) grosor de la longitud horizontal
    dj2 = 20;       % (mitad de la) longitud horizontal de cálculo
    % Zonas de cálculo de color y variables de almacenamiento
    cruz1 = zeros(2*di1 + 1, 2*dj2 + 1);
    cruz1((-di2:di2) + di1 + 1, :) = 1;
    cruz1(:, (-dj1:dj1) + dj2 + 1) = 1;
    cruz2 = cruz1;
    cruz2(di1 + di2 + 2:end,:) = 0;
    xx_corr = zeros(1,4);
    yy_corr = xx_corr;
    for n = 1:4
        if n == 1 || n == 2
            cruz_grid = cruz1;
        elseif n == 3 || n == 4
            cruz_grid = cruz2;
        end
        min_sum_corr = Inf;
        for i = round(max(yy(n)-dy,dj1+1)):round(min(yy(n)+dy,rows-dj1))
            for j = round(max(xx(n)-dx,dj1+1)):round(min(xx(n)+dx,cols-dj1))
                i1 = (-di1:di1) + i;
                j1 = (-dj2:dj2) + j;
                sum_corr = sum(sum(Crit_corr(i1,j1).*cruz_grid));
                if sum_corr < min_sum_corr
                    xx_corr(n) = j;
                    yy_corr(n) = i;
                    min_sum_corr = sum_corr;
                end
            end
        end
    end
    
    % Corrección del punto 3 si se encuentra muy alejado de su posición, en
    % comparación a las componentes de los puntos 1 y 4 (debido a la
    % intervención de la línea trazada o la perforadora)
    d_umb_p3 = 10;
    dy = 2;
    dij = 25;
    if (xx_corr(1) - xx_corr(3))^2 + (yy_corr(4) - yy_corr(3))^2 > d_umb_p3^2
        x_aux = xx_corr(1);
        y_aux = yy_corr(4);
        min_sum_corr = Inf;
        for i = (-dy:dy) + y_aux
            for j = (-dy:dy) + x_aux
                i0 = (-dy:dy) + i;
                j0 = (-dy:dy) + j;
                i1 = i0 - dij;
                j1 = j0 - dij;
                j2 = j0 + dij;                
                sum_corr = sum(sum(Crit_corr(i1,j0) + Crit_corr(i0,j1) + Crit_corr(i0,j2)));
                if sum_corr < min_sum_corr
                    xx_corr(3) = j;
                    yy_corr(3) = i;
                    min_sum_corr = sum_corr;
                end
            end
        end
    end
    
    % Mostrar resultados de la definición automática de márgenes
    warning off all
    figure, imshow(RGB), hold on,
    plot(xx_corr, yy_corr, 'r+', 'LineWidth', 2, 'MarkerSize', 30), hold on,
    plot(xx_corr, yy_corr, 'ro', 'LineWidth', 2, 'MarkerSize', 15)
    set(gcf,'Color','w','units','normalized','Position',[0.05 0.1 0.9 0.7])
    warning on all
    
    menu_marg1 = menu({ ...
        '(1.3) DEFINIR MÁRGENES DE LA IMAGEN'
        'DEFINICIÓN AUTOMÁTICA DE MÁRGENES'
        '________________________'
        ''
        'Se ha definido automáticamente cuatro puntos que'
        'delimitan el área relevante del pluviograma'
        '(de 8 a 8 hrs y de 0 a 10 mm).'
        ''
        'Si los puntos se encuentran en la intersección de los 0'
        'y 10 mm con las 8 hrs, tanto al inicio como al final'
        'del pluviograma, haga clic en "Aceptar".'
        ''
        'Revise cada punto. Si alguno no cumple lo dicho'
        'anteriormente, haga clic en "Corregir puntos" para'
        'corregirlos de forma manual.'
        ''
        'Si desea salir de la definición de márgenes'
        'haga clic en "Cancelar".'}, ...
        '        Aceptar        ', ...
        'Corregir puntos', ...
        'Cancelar');
    
    switch menu_marg1
        case 1
            % Cambio de notación de los puntos, para mantener los nombres
            % utilizados en códigos antiguos
            x_margen1 = xx_corr(1); x_margen2 = xx_corr(2); x_margen3 = xx_corr(3); x_margen4 = xx_corr(4);
            y_margen1 = yy_corr(1); y_margen2 = yy_corr(2); y_margen3 = yy_corr(3); y_margen4 = yy_corr(4);
            x_margen = xx_corr;
            y_margen = yy_corr;
            
            % Mensaje en la ventana de comandos
            disp(['- (1.3) Definir márgenes                         TERMINADO!        ' datestr(now)])
            
        case 2
            % Ejecutar la segunda parte de la definición de márgenes
            run('b13_definir_margenes_pt2')
            
        otherwise
            close            
    end
      
elseif ~ (exist('fecha_inicio','var') || exist('fecha_termino','var'))
    % Cuadro de error en caso de no haber definido fecha y hora (de inicio
    % y término) de la imagen
    errordlg('Debe definir la información de fecha y hora (de inicio y término) de la imagen.','Error: Información no Definida')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de definir márgenes.','Error: Imagen no encontrada')
end