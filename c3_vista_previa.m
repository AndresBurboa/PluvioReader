if exist('C','var')
    
    if length(C) >= 10
        num_cambios = '10 or more';
    else
        num_cambios = num2str(length(C) - 1);
    end
    
    num_dim_C = numel(size(cell2mat(C(end))));
    warning off all
    switch num_dim_C
        case 3
            figure, imshow(cell2mat(C(end))),
        case 2
            figure, imshow(imcomplement(cell2mat(C(end)))),
    end
    set(gcf,'Name',['Preview:   ' filename '         (N° of changes: ' num_cambios ')'],'NumberTitle','off')
    warning on all
    
elseif exist('RGB','var') && exist('C','var') == 0
    
    warning off all
    figure, imshow(RGB), set(gcf,'Name',['Preview:   ' filename '         (N° of changes: 0)'],'NumberTitle','off')
    warning on all
    
else
    errordlg('You must select an image in order to be able to preview.','Error: Image not found')
end