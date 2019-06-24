if ~ exist('RGB','var')
    
    pause(1e-6)
    [filename, pathname] = uigetfile({ ...
        '*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.pbm;*.png','All Image Files'; ...
        '*.*','All Files'},'Select Image');
    pause(1e-6)

    if ischar(filename) && ischar(pathname)
        RGB = imread([pathname filename]);
        
        if numel(size(RGB)) == 3
            R = RGB(:, :, 1); G = RGB(:, :, 2); B = RGB(:, :, 3);
            [rows, cols, ~] = size(RGB);
            warning off all
            figure, imshow(RGB),    set(gcf, 'Name', ['Selected Image:   ' filename], 'NumberTitle', 'off')
                                    set(gcf, 'Color', 'w', 'units', 'normalized', 'Position',[0.05 0.1 0.9 0.7])
            warning on all

            disp(['- (1.1) Select Image                       COMPLETED!        ' datestr(now)])
            
        else
            errordlg('Selected image must be in color, not black and white.','Error: Image is not Valid');
        end
    end
    
else
    
    quest_select = questdlg(['You have already selected an image. If you select a different image you will lose your configuration for the current image. ' ...
        'Do you really wish to select a new image?'],'Select a New Image','Yes','No','Yes');
    if all(quest_select == 'Yes')
        clear all
        close all force
        run('b11_seleccionar_imagen')
    end
    
end