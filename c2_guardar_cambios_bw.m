% COMPARACIÓN DE ANTES Y DESPUÉS, GUARDADO DE CAMBIOS Y GUARDADO DE
% VERSIONES ANTERIORES DE LA IMAGEN. VALIDO PARA IMÁGENES BW

if exist('BW0','var') && exist('BW','var')
    
    % Cantidad máxima de cambios almacenados
    max_cambios = 10;
    
    % Gráfica comparación
    num_dim_BW0 = numel(size(BW0));
    warning off all
    switch num_dim_BW0
        case 3
            figure, subplot(2,1,1), imshow(BW0), title('Imagen antes de los cambios','FontWeight','bold','FontSize',12)
                    subplot(2,1,2), imshow(imcomplement(full(BW))), title('Imagen después de los cambios','FontWeight','bold','FontSize',12)
        case 2
            figure, subplot(2,1,1), imshow(imcomplement(full(BW0))), title('Imagen antes de los cambios','FontWeight','bold','FontSize',12)
                    subplot(2,1,2), imshow(imcomplement(full(BW))), title('Imagen después de los cambios','FontWeight','bold','FontSize',12)
    end
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
            if ~ exist('C','var')
                C = {BW0 ; BW};
            else
                C(length(C) + 1) = {BW};
            end
            BW0 = BW;
            while length(C) > max_cambios
                C(1) = [];
            end
        case 2
            if numel(size(BW0)) == 2
                BW = BW0;
            end
    end
else
    errordlg('No es posible guardar cambios','Error: Guardar Cambios')
end