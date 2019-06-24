close

dx_puntos = 170;
dy_puntos = 50;
xx_corr2 = xx_corr;
xx_corr2([1 3]) = xx_corr2([1 3]) + dx_puntos;
xx_corr2([2 4]) = xx_corr2([2 4]) - dx_puntos;
yy_corr2 = yy_corr;
yy_corr2(1:2) = yy_corr2(1:2) + dy_puntos;
yy_corr2(3:4) = yy_corr2(3:4) - dy_puntos;

warning off all
figure, imshow(RGB), hold on,
plot(xx_corr, yy_corr, 'r+', 'LineWidth', 2, 'MarkerSize', 30), hold on,
plot(xx_corr, yy_corr, 'ro', 'LineWidth', 2, 'MarkerSize', 15), hold on,
puntos = {'Punto 1','Punto 2','Punto 3','Punto 4'};
text(xx_corr2, yy_corr2, puntos, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontWeight', 'bold')
set(gcf,'Color','w','units','normalized','Position',[0.05 0.1 0.9 0.7])
warning on all

menu_marg2 = menu({ ...
    '(1.3) DEFINE IMAGE MARGINS'
    'INPUT CORNER POINTS MANUALLY'
    '________________________'
    ''
    'Please click on the choice corresponding to the'
    'corner point you wish to select.'
    ''
    'If you are done selecting points, please'
    'click "Finalize".'
    ''
    'If you wish to leave the DEFINE IMAGE MARGINS routine,'
    'please click "Cancel".'}, ...
    'Point 1', ...
    'Point 2', ...
    'Point 3', ...
    'Point 4', ...
    '      End      ', ...
    'Cancel');

if any(menu_marg2 == [1 2 3 4])
    
    close
    
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
        '(1.3) DEFINE IMAGE MARGINS AND CENTER THE IMAGE'
        'MANUAL SELECTION OF CORNER POINTS'
        '________________________'
        ''
        'If needed, you can zoom in to that part of the image'
        'where you wish to select a corner point.'
        ''
        ['Select the ' puntos{menu_marg2} ' clicking over']
        'the image at the corresponding grid intersection.'
        '________________________'
        ''
        'Click OK to go to corner point selection.'
      
        ''
        '(Do not close the image. Click “Cancel”'
        'or else close this window in order to exit'
        'define image margins)'}, ...
        'OK', ...
        'Cancel');
    
    if menu_marg3 == 1
        [xx_corr(menu_marg2), yy_corr(menu_marg2), ~] = ginput(1);
        xx_corr = round(xx_corr);     yy_corr = round(yy_corr);
    end
    run('b13_definir_margenes_pt2')
    close
    
elseif menu_marg2 == 5
    x_margen1 = xx_corr(1); x_margen2 = xx_corr(2); x_margen3 = xx_corr(3); x_margen4 = xx_corr(4);
    y_margen1 = yy_corr(1); y_margen2 = yy_corr(2); y_margen3 = yy_corr(3); y_margen4 = yy_corr(4);
    x_margen = xx_corr;
    y_margen = yy_corr;

    disp(['- (1.3) Define Image Margins and Center Image      COMPLETED!        ' datestr(now)])
end