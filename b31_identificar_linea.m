if 1 || exist('RGB','var') && exist('x_margen','var')

    if exist('C','var') && ~ isempty(C) && numel(size(cell2mat(C(end)))) == 2
        quest_ident = questdlg(['There already exists one or more saved versions of the binary image. ' ...
            'Do you wish to delete them and identify the line again?'],'Identify Line','Yes','No','Yes');
        switch quest_ident
            case 'Yes'
                while numel(size(cell2mat(C(end)))) == 2
                    C(end) = [];
                end
                run('b31_identificar_linea')
        end
    else
        
        BW0 = RGB;
        
        RR = double(R);
        GG = double(G);
        BB = double(B);
        
        RGB_min = min(RGB,[],3);
        BW_grid = RGB_min <= umb_grid;
        
        diff_B = BB - RR + BB - GG;
        diff_B = (diff_B - min(min(diff_B)))/(max(max(diff_B)) - min(min(diff_B)))*255;

        num_umb = 5;            
        d_umb = 1;
        umb = (0:num_umb-1)*d_umb;

        rate = zeros(size(umb));
        for k = 1:num_umb
            rate(k) = sum(sum(diff_B <= umb(k)))/(rows*cols);
        end
        slope = abs(diff(rate))/d_umb;
        slope2 = abs(diff(slope))/d_umb;

        rate_min = 0.5;
        slope_max = 2e-3;       % 1.5e-3 o 2e-3;
        slope2_max = 0.5e-3;
        while any(rate < rate_min) || any(slope > slope_max) || any(slope2 > slope2_max)
            umb = umb + d_umb;
            rate(1:end-1) = rate(2:end);
            rate(end) = sum(sum(diff_B <= umb(end)))/(rows*cols);
            slope(1:end-1) = slope(2:end);
            slope(end) = abs(rate(end-1) - rate(end))/d_umb;
            slope2(1:end-1) = slope2(2:end);
            slope2(end) = abs(slope(end-1) - slope(end))/d_umb;
            umb_line = umb(2);
        end
        BW_diff_B = diff_B >= umb_line;
        
        figure, imshow(imcomplement(BW_diff_B))
        
        menu_identif1 = menu({ ...
            '(3.1) IDENTIFY LINE'
            'OPTION SELECTION'
            '________________'
            ''
            'If the line is correctly defined,'
            'hit "Accept".'
            ''
            'If the line is not well defined'
            'and you wish to try other options,'
            'hit "Other Options".'
            ''
            'If you wish to exit the Line Identification routine'
            'hit "Cancel"'}, ...
            'Accept', ...
            'Other Options', ...
            'Cancel');
        close
        
        switch menu_identif1
            case 1
                BW = BW_diff_B;
                
            case 2
                dif_gb = 10;
                bw1 = B > R & B > G;
                bw2 = B > R | B > G;
                bw3 = B > R & B > G | (R > G & G - B < dif_gb);

                n_alt = 3;
                figure, subplot(n_alt,1,1), imshow(imcomplement(bw1)), title('Alternativa 1','FontWeight','bold','FontSize',12)
                        subplot(n_alt,1,2), imshow(imcomplement(bw2)), title('Alternativa 2','FontWeight','bold','FontSize',12)
                        subplot(n_alt,1,3), imshow(imcomplement(bw3)), title('Alternativa 3','FontWeight','bold','FontSize',12)

                menu_identif2 = menu({ ...
                    '(3.1) IDENTIFY LINE'
                    'OPTION SELECTION'
                    '________________'
                    ''
                    'Select the option that'
                    'best matches the line'}, ...
                    'Option 1', ...
                    'Option 2', ...
                    'Option 3', ...
                    'Cancel');
                close
                switch menu_identif2
                    case 1
                        BW = bw1;
                    case 2
                        BW = bw2;
                    case 3
                        BW = bw3;
                end
        end
        
        if menu_identif1 == 1 || ( exist('menu_identif2','var') && (menu_identif2 == 1 || menu_identif2 == 2 || menu_identif2 == 3) )
            run('c2_guardar_cambios_bw')

            if menu_guardar == 1
                disp(['- (3.1) Identify Line                        COMPLETED!        ' datestr(now)])
            end
        else
            close
        end
        
    end
elseif ~ exist('RGB','var')
    errordlg('You must select an image before identifying the line.','Error: Image not found')
elseif ~ exist('x_margen','var')
    errordlg('You must define the margins before identifying line.','Error: Undefined margins')
end