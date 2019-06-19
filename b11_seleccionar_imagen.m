% (1.1) SELECCIONAR IMAGEN

if ~ exist('RGB','var')
    
    % Nombre y ruta del archivo (las pausas están por un problema del
    % comando uigetfile)
    pause(1e-6)
    [filename, pathname] = uigetfile({ ...
        '*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','Todos los Archivos de Imagen'; ...
        '*.*','Todos los Archivos'},'Seleccionar Imagen');
    pause(1e-6)

    if ischar(filename) && ischar(pathname)
        % Lectura de imagen
        RGB = imread([pathname filename]);
        
        if numel(size(RGB)) == 3
            % Separación de matrices RGB
            R = RGB(:, :, 1); G = RGB(:, :, 2); B = RGB(:, :, 3);
            % Definición de dimensiones de la imagen
            [rows, cols, ~] = size(RGB);
            % Mostrar imagen
            warning off all
            figure, imshow(RGB),    set(gcf, 'Name', ['Imagen seleccionada:   ' filename], 'NumberTitle', 'off')
                                    set(gcf, 'Color', 'w', 'units', 'normalized', 'Position',[0.05 0.1 0.9 0.7])
            warning on all

            % Mensaje en la ventana de comandos
            disp(['- (1.1) Seleccionar Imagen                       TERMINADO!        ' datestr(now)])
            
        else
            % Cuadro de error en caso de seleccionar imagen en escala de
            % grises (o blancos y negros puros)
            errordlg('La imagen ingresada debe ser a color, no en blanco y negro.','Error: Imagen no válida');
        end
    end
    
else
    
    % Si existe una imagen ya seleccionada, preguntar si se quiere
    % seleccionar otra
    quest_select = questdlg(['Ya existe una imagen seleccionada. Si selecciona una nueva imagen perderá la configuración realizada a ésta. ' ...
        '¿Desea seleccionar una imagen nueva?'],'Seleccionar una nueva imagen','Si','No','Si');
    if all(quest_select == 'Si')
        clear all
        close all force
        run('b11_seleccionar_imagen')
    end
    
end