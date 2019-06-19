% (1.3) DEFINIR MÁRGENES DEL ÁREA DE REGISTRO. Parte 2

% Cerrar figura
close

% Definición de posiciones de los nombres de cada punto
dx_puntos = 170;
dy_puntos = 50;
xx_corr2 = xx_corr;
xx_corr2([1 3]) = xx_corr2([1 3]) + dx_puntos;
xx_corr2([2 4]) = xx_corr2([2 4]) - dx_puntos;
yy_corr2 = yy_corr;
yy_corr2(1:2) = yy_corr2(1:2) + dy_puntos;
yy_corr2(3:4) = yy_corr2(3:4) - dy_puntos;

% Mostrar márgenes con los nombres de los puntos
warning off all
figure, imshow(RGB), hold on,
plot(xx_corr, yy_corr, 'r+', 'LineWidth', 2, 'MarkerSize', 30), hold on,
plot(xx_corr, yy_corr, 'ro', 'LineWidth', 2, 'MarkerSize', 15), hold on,
puntos = {'Punto 1','Punto 2','Punto 3','Punto 4'};
text(xx_corr2, yy_corr2, puntos, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontWeight', 'bold')
set(gcf,'Color','w','units','normalized','Position',[0.05 0.1 0.9 0.7])
warning on all

menu_marg2 = menu({ ...
    '(1.3) DEFINIR MÁRGENES DE LA IMAGEN'
    'CORRECCIÓN MANUAL DE PUNTOS'
    '________________________'
    ''
    'Haga clic en la casilla correspondiente al'
    'punto que desea corregir.'
    ''
    'Si ya corrigió los puntos que deseaba, haga'
    'click en "Finalizar".'
    ''
    'Si desea salir de la definición de márgenes,'
    'haga clic en "Cancelar".'}, ...
    'Punto 1', ...
    'Punto 2', ...
    'Punto 3', ...
    'Punto 4', ...
    '     Finalizar      ', ...
    'Cancelar');

if any(menu_marg2 == [1 2 3 4])
    
    % Cerrar figura
    close
    
    % Mostrar esquina seleccionada y cuadro de diálogo con instrucciones
    warning off all
    figure, imshow(RGB), hold on,
    plot(xx_corr, yy_corr, 'r+', 'LineWidth', 2, 'MarkerSize', 30), hold on,
    plot(xx_corr, yy_corr, 'ro', 'LineWidth', 2, 'MarkerSize', 15), hold on,
    set(gcf,'Color','w','units','normalized','Position',[0.15 0.1 0.7 0.7])
    xlim_puntos = [1 0.075*cols; 0.925*cols cols; 1 0.075*cols; 0.925*cols cols];
    ylim_puntos = [1 0.2*rows; 1 0.2*rows; 0.8*rows rows; 0.8*rows rows];
    set(gca,'xlim',xlim_puntos(menu_marg2,:),'ylim',ylim_puntos(menu_marg2,:))
    warning on all
    
    menu_marg3 = menu({ ...
        '(1.3) DEFINIR MÁRGENES Y ENCUADRAR IMAGEN'
        'CORRECCIÓN MANUAL DE PUNTOS'
        '________________________'
        ''
        'Si lo necesita, haga zoom al área de la imagen'
        'donde se encuentra el punto que desea corregir.'
        ''
        ['Seleccione el ' puntos{menu_marg2} ' haciendo clic en']
        'la imagen sobre la intersección de la grilla'
        'que corresponda.'
        '________________________'
        ''
        'Haga click en OK para pasar a la selección'
        'del punto.'
        ''
        '(No cierre la imagen. Haga click en Cancelar'
        'o cierre esta ventana para salir de la'
        'definición de márgenes)'}, ...
        'OK', ...
        'Cancelar');
    
    % Selección de punto
    if menu_marg3 == 1
        [xx_corr(menu_marg2), yy_corr(menu_marg2), ~] = ginput(1);
        xx_corr = round(xx_corr);     yy_corr = round(yy_corr);
    end
    % Repetir la corrección de márgenes
    run('b13_definir_margenes_pt2')
    % Cerrar figura
    close
    
elseif menu_marg2 == 5
    % Cambio de notación de los puntos, para mantener los nombres
    % utilizados en códigos antiguos
    x_margen1 = xx_corr(1); x_margen2 = xx_corr(2); x_margen3 = xx_corr(3); x_margen4 = xx_corr(4);
    y_margen1 = yy_corr(1); y_margen2 = yy_corr(2); y_margen3 = yy_corr(3); y_margen4 = yy_corr(4);
    x_margen = xx_corr;
    y_margen = yy_corr;

    % Mensaje en la ventana de comandos
    disp(['- (1.3) Definir márgenes y Encuadrar imagen      TERMINADO!        ' datestr(now)])
end