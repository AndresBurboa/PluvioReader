% COMPARACIÓN DE ANTES Y DESPUÉS, GUARDADO DE CAMBIOS Y GUARDADO DE
% VERSIONES ANTERIORES DE LA IMAGEN. VALIDO PARA IMÁGENES RGB

if exist('RGB','var') && exist('RGB0','var')
    
    % Cantidad máxima de cambios almacenados
    max_cambios = 10;
    
    % Gráfica comparación
    warning off all
    figure, subplot(2,1,1), imshow(RGB), title('Imagen antes de los cambios','FontWeight','bold','FontSize',12)
            subplot(2,1,2), imshow(RGB0), title('Imagen después de los cambios','FontWeight','bold','FontSize',12)
            set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8],'Name','Imágenes antes y después de los cambios realizados','NumberTitle','off')
    warning on all

    % Pregunta guardar cámbios
    menu_guardar = menu({ ...
            'GUARDAR CAMBIOS'
            '______________'
            ''
            '¿Desea guardar los cambios'
            'realizados en la imagen?'}, ...
            'Si', ...
            'No');
    close
    switch menu_guardar
        case 1
            if exist('C','var') == 0
                C = {RGB ; RGB0};
            else
                C(length(C) + 1) = {RGB0};
            end
            RGB = RGB0;
            R = R0; G = G0; B = B0;
            while length(C) > max_cambios
                C(1) = [];
            end
        case 2
            RGB0 = RGB;
            R0 = R; G0 = G; B0 = B;
    end
else
    errordlg('No es posible guardar cambios','Error: Guardar Cambios')
end