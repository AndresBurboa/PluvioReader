% REHACER CAMBIOS EN LA IMAGEN

if exist('C2','var') && numel(C2) > 0
    
    % Reescritura de cambios rehechos
    if exist('C','var')
        C(length(C) + 1) = C2(end);
    else
        C = C2(end);
    end
    C2(end) = [];
    while length(C) > max_cambios
        C(1) = [];
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
    
    % Vista previa de cambio rehecho
    run('c3_vista_previa')
    
else
    % Cuadro de error en caso de no existir cambios
    errordlg('No existen cambios deshechos en la imagen para poder rehacer.','Error: Rehacer Imagen')
end
    