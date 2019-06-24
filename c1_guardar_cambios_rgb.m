if exist('RGB','var') && exist('RGB0','var')
    
    max_cambios = 10;
    
    warning off all
    figure, subplot(2,1,1), imshow(RGB), title('Image before changes','FontWeight','bold','FontSize',12)
            subplot(2,1,2), imshow(RGB0), title('Image after changes','FontWeight','bold','FontSize',12)
            set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8],'Name','Images before and after performing changes','NumberTitle','off')
    warning on all

    menu_guardar = menu({ ...
            'SAVE CHANGES'
            '______________'
            ''
            'Do you wish to save the changes'
            'effected on the image?'}, ...
            'Yes', ...
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
    errordlg('Changes cannot be saved','Error: Save Changes')
end