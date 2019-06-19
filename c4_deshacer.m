% DESHACER CAMBIOS EN LA IMAGEN

if exist('C','var') && numel(C) > 1
    
    % Almacenado de cambios deshechos
    if exist('C2','var')
        C2(length(C2) + 1) = C(end);
    else
        C2 = C(end);
    end
    C(end) = [];
    while length(C2) > max_cambios
        C2(1) = [];
    end
    
    % Escritura de la imagen, ya sea RGB o binaria
    dim_ultimo_guardado = numel(size(cell2mat(C(end))));
    switch dim_ultimo_guardado
        case 3
            RGB = cell2mat(C(end));
            R = RGB(:, :, 1); G = RGB(:, :, 2); B = RGB(:, :, 3);
        case 2
            BW = cell2mat(C(end));
    end
    
    % Vista previa de cambio deshecho
    run('c3_vista_previa')
    
else
    % Cuadro de error en caso de no existir cambios
    errordlg('No existen suficientes versiones anteriores de la imagen para poder deshacer cambios.','Error: Deshacer Imagen')
end
    