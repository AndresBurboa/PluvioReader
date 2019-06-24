if exist('BW0','var') && exist('BW','var')
    
    max_cambios = 10;
    
    num_dim_BW0 = numel(size(BW0));
    warning off all
    switch num_dim_BW0
        case 3
            figure, subplot(2,1,1), imshow(BW0), title('Image before changes','FontWeight','bold','FontSize',12)
                    subplot(2,1,2), imshow(imcomplement(full(BW))), title('Image after changes','FontWeight','bold','FontSize',12)
        case 2
            figure, subplot(2,1,1), imshow(imcomplement(full(BW0))), title('Image before changes','FontWeight','bold','FontSize',12)
                    subplot(2,1,2), imshow(imcomplement(full(BW))), title('Image after changes','FontWeight','bold','FontSize',12)
    end
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
    errordlg('Changes cannot be saved','Error: Save Changes')
end