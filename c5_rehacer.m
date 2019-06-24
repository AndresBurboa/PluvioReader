if exist('C2','var') && numel(C2) > 0
    
    if exist('C','var')
        C(length(C) + 1) = C2(end);
    else
        C = C2(end);
    end
    C2(end) = [];
    while length(C) > max_cambios
        C(1) = [];
    end
    
    dim_ultimo_guardado = numel(size(cell2mat(C(end))));
    switch dim_ultimo_guardado
        case 3
            RGB = cell2mat(C(end));
            R = RGB(:, :, 1); G = RGB(:, :, 2); B = RGB(:, :, 3);
        case 2
            BW = cell2mat(C(end));
    end
    
    run('c3_vista_previa')
    
else
    errordlg('No changes were previously undone for this image.','Error: Redo Changes')
end
    