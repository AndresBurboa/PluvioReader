pause(1e-6)
path_sheets = uigetdir('','Select the folder containing results to merge');
pause(1e-6)

formato = '.xlsx';

rows_max = 1048576;
rows_max = rows_max - 10;

if ischar(path_sheets)
    dir_sheets = dir(fullfile(path_sheets, ['*' formato]));
    list_sheets0 = {dir_sheets.name};
    
    if ~ isempty(dir_sheets)
        [select_sheets, ok] = listdlg('PromptString','Select the spreadsheets you wish to merge:','ListString',list_sheets0);
        
        if ok
            list_sheets = list_sheets0(select_sheets);

            Precip_unir = zeros(rows_max*length(list_sheets),1);
            Date_unir = cell(rows_max*length(list_sheets),1);
            
            num0 = 1;
            for num_xlsx = 1:length(list_sheets)
                [Num, Text] = xlsread(fullfile(path_sheets,list_sheets{num_xlsx}));
                Precip_unir(num0:num0 + size(Num,1) - 1) = Num(:,1);
                Date_unir(num0:num0 + size(Num,1) - 1) = Text(end-size(Num,1)+1:end,1);
                num0 = num0 + size(Num,1);
            end
            
            Precip_unir(num0:end) = [];
            Date_unir(num0:end) = [];
            
            is_char_date_u = 1;
            for i = 1:length(Date_unir)
                if ~ ischar(Date_unir{i})
                    is_char_date_u = 0;
                    break
                end
            end
            
            if isnumeric(Precip_unir) && is_char_date_u
                Time_unir = zeros(size(Precip_unir));
                for i = 1:length(Precip_unir)
                    if numel(Date_unir{i}) == 10
                        Time_unir(i) = datenum(Date_unir{i},'dd-mm-yyyy');
                    elseif numel(Date_unir{i}) == 15 || numel(Date_unir{i}) == 16
                        Time_unir(i) = datenum(Date_unir{i},'dd-mm-yyyy HH:MM');
                    else
                        Time_unir(i) = datenum(Date_unir{i},'dd-mm-yyyy HH:MM:SS');
                    end
                end
                
                [~, I_sort] = sort(Time_unir);
                
                Date_unir = Date_unir(I_sort);
                Precip_unir = Precip_unir(I_sort);
                Time_unir = Time_unir(I_sort);
                
                borrar_unir = zeros(length(Time_unir),1);
                cont_k = 1;
                for k = 2:length(Time_unir)
                    if Time_unir(k) == Time_unir(k-1)
                        if Precip_unir(k) > Precip_unir(k-1)
                            borrar_unir(cont_k) = k - 1;
                        else
                            borrar_unir(cont_k) = k;
                        end
                        cont_k = cont_k + 1;
                    end
                end
                borrar_unir(borrar_unir == 0) = [];
                Date_unir(borrar_unir) = [];
                Precip_unir(borrar_unir) = [];
                
                stat = zeros(ceil(length(Precip_unir)/rows_max),1);
                for num_pl = 1:ceil(length(Precip_unir)/rows_max)
                    if num_pl ~= ceil(length(Precip_unir)/rows_max)
                        Result_unir = [{'DATE (dd/mm/yyyy HH:MM)', 'RAINFALL DEPTH (mm)'}; ...
                            Date_unir((num_pl-1)*rows_max + 1:num_pl*rows_max), num2cell(Precip_unir((num_pl-1)*rows_max + 1:num_pl*rows_max),2)];
                        fecha1 = Date_unir{(num_pl-1)*rows_max + 1};      	fecha1 = fecha1(1:10);
                        fecha2 = Date_unir{num_pl*rows_max};                fecha2 = fecha2(1:10);
                        stat(num_pl) = xlswrite(fullfile(path_sheets,['Joined Pluviograms ' fecha1 ' to ' fecha2 ' (' num2str(num_pl) ').xlsx']), ...
                            Result_unir, 1, 'A1');
                    else
                        Result_unir = [{'DATE (dd/mm/yyyy HH:MM)', 'RAINFALL DEPTH (mm)'}; ...
                            Date_unir((num_pl-1)*rows_max + 1:end), num2cell(Precip_unir((num_pl-1)*rows_max + 1:end))];
                        fecha1 = Date_unir{(num_pl-1)*rows_max + 1};      	fecha1 = fecha1(1:10);
                        fecha2 = Date_unir{end};                            fecha2 = fecha2(1:10);
                        stat(num_pl) = xlswrite(fullfile(path_sheets,['Joined Pluviogram ' fecha1 ' to ' fecha2 ' (' num2str(num_pl) ').xlsx']), ...
                            Result_unir, 1, 'A1');
                    end
                end

                if all(stat)
                    
                    uiwait(msgbox({'Operation Completed.'
                        'The spreadsheets with results have been merged.'
                        'The new spreadsheet has been saved to the folder that you selected initially.'},'Export Results','modal'));
                    disp(['- (5.3) Merge spreadsheets                           COMPLETED!        ' datestr(now)])
                end               
                
            end
        end
        
    else
        errordlg({'The chosen folder must contain spreadsheets with results.'
            ['All spreadsheets must have the format ' formato ' to be merged.']}, ...
            'Error: Folder or Spreadsheets are not valid')
    end
end