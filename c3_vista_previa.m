% VISTA PREVIA DE LA IMAGEN

if exist('C','var')
    
    % Definición de la cantidad de cambios realizados en la imagen
    if length(C) >= 10
        num_cambios = '10 o más';
    else
        num_cambios = num2str(length(C) - 1);
    end
    
    % Mostrar Imagen
    num_dim_C = numel(size(cell2mat(C(end))));
    warning off all
    switch num_dim_C
        case 3
            figure, imshow(cell2mat(C(end))),
        case 2
            figure, imshow(imcomplement(cell2mat(C(end)))),
    end
    set(gcf,'Name',['Vista Previa:   ' filename '         (N° Cambios: ' num_cambios ')'],'NumberTitle','off')
    warning on all
    
elseif exist('RGB','var') && exist('C','var') == 0
    
    % Mostrar Imagen
    warning off all
    figure, imshow(RGB), set(gcf,'Name',['Vista Previa:   ' filename '         (N° Cambios: 0)'],'NumberTitle','off')
    warning on all
    
else
    errordlg('Debe seleccionar una imagen antes de solicitar su vista previa.','Error: Imagen no encontrada')
end