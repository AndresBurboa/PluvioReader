% (2.1) ENCUADRAR IMAGEN

if ~ exist('RGB','var')
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg({'Debe seleccionar una imagen antes de encuadrar.';
        'Debe definir los márgenes de la imagen antes de encuadrar.'},'Error: Imagen no encontrada')
elseif ~ exist('x_margen','var')
    % Cuadro de error en caso de no haber definido los márgenes
    errordlg('Debe definir los márgenes de la imagen correctamente antes de encuadrar.','Error: Márgenes no definidos')
else
    
    if ~ exist('tform','var')
        
        % Cálculo de dimensiones relevantes
        dist12 = sqrt( (x_margen2 - x_margen1)^2 + (y_margen2 - y_margen1)^2 );
        dist34 = sqrt( (x_margen4 - x_margen3)^2 + (y_margen4 - y_margen3)^2 );
        dist13 = sqrt( (x_margen3 - x_margen1)^2 + (y_margen3 - y_margen1)^2 );
        dist24 = sqrt( (x_margen4 - x_margen2)^2 + (y_margen4 - y_margen2)^2 );

        % Y máximos de las dimensiones
        length_x = round(max([dist12 dist34]));
        length_y = round(max([dist13 dist24]));
        
        % Márgenes después del enuadre
        xx1 = max(x_margen1,x_margen3);     yy1 = max(y_margen1,y_margen2);
        xx2 = xx1 + length_x;               yy2 = yy1;
        xx3 = xx1;                          yy3 = yy1 + length_y;
        xx4 = xx1 + length_x;               yy4 = yy1 + length_y;

        % DEFINIR TRANSFORMACIÓN a aplicar en la imagen
        tform = maketform('projective', [x_margen1 y_margen1; x_margen2 y_margen2; x_margen4 y_margen4; x_margen3 y_margen3], ...
                                        [xx1 yy1; xx2 yy2; xx4 yy4; xx3 yy3]);

        % ENCUADRE DE IMAGEN
        RGB = imtransform(RGB,tform);
        
        % Separación de matrices RGB
        R = RGB(:, :, 1); G = RGB(:, :, 2); B = RGB(:, :, 3);

        % Corrección de x_margen e y_margen
        x_margen1 = xx1; x_margen2 = xx2; x_margen3 = xx3; x_margen4 = xx4;
        y_margen1 = yy1; y_margen2 = yy2; y_margen3 = yy3; y_margen4 = yy4;
        
        x_margen = [x_margen1 x_margen2 x_margen3 x_margen4];
        y_margen = [y_margen1 y_margen2 y_margen3 y_margen4];
        
        % Recálculo de rows y cols
        [rows, cols, ~] = size(RGB);
        
    end
    
end