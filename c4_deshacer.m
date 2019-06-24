if exist('C','var') && numel(C) > 1
    
    if exist('C2','var')
        C2(length(C2) + 1) = C(end);
    else
        C2 = C(end);
    end
    C(end) = [];
    while length(C2) > max_cambios
        C2(1) = [];
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
    errordlg('There are not enough previous versions of this image in order to undo changes.','Error: Undo Changes')
end
    