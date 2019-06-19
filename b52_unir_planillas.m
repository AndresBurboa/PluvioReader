% (5.3) UNIR PLANILLAS CON RESULTADOS EXPORTADOS

% Nombre y ruta del archivo (las pausas están por un problema del
% comando uigetdir)
pause(1e-6)
path_sheets = uigetdir('','Seleccione la carpeta con resultados para unir');
pause(1e-6)

% Formato de planillas
formato = '.xlsx';

% Cantidad máxima de filas en excel
rows_max = 1048576;
rows_max = rows_max - 10;

if ischar(path_sheets)
    % Crear lista con archivos en la carpeta
    dir_sheets = dir(fullfile(path_sheets, ['*' formato]));
    list_sheets0 = {dir_sheets.name};
    
    if ~ isempty(dir_sheets)
        % Cuadro de diálogo con lista a seleccionar
        [select_sheets, ok] = listdlg('PromptString','Seleccione las planillas que desea unir:','ListString',list_sheets0);
        
        if ok
            % Lista seleccionada de planillas
            list_sheets = list_sheets0(select_sheets);

            % Vectores de almacenamiento de precipitación y fecha
            Precip_unir = zeros(rows_max*length(list_sheets),1);
            Date_unir = cell(rows_max*length(list_sheets),1);
            
            % Escribir matriz de unión
            num0 = 1;
            for num_xlsx = 1:length(list_sheets)
                [Num, Text] = xlsread(fullfile(path_sheets,list_sheets{num_xlsx}));
                Precip_unir(num0:num0 + size(Num,1) - 1) = Num(:,1);
                Date_unir(num0:num0 + size(Num,1) - 1) = Text(end-size(Num,1)+1:end,1);
                num0 = num0 + size(Num,1);
            end
            
            % Eliminar elementos no escritos en los vectores
            Precip_unir(num0:end) = [];
            Date_unir(num0:end) = [];
            
            % Verificar que el vector "Date" posee fechas (o por lo menos
            % caracteres)
            is_char_date_u = 1;
            for i = 1:length(Date_unir)
                if ~ ischar(Date_unir{i})
                    is_char_date_u = 0;
                    break
                end
            end
            
            % Verificación, cálculo de tiempo, reordenamiento y escritura
            % de planillas
            if isnumeric(Precip_unir) && is_char_date_u
                % Tiempo asociado a la fecha, en días
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
                
                % Vector de reordenamiento de fechas
                [~, I_sort] = sort(Time_unir);
                
                % Reordenar Date_u, Precip_u y Time_u
                Date_unir = Date_unir(I_sort);
                Precip_unir = Precip_unir(I_sort);
                Time_unir = Time_unir(I_sort);
                
                % Eliminar elementos de fecha repetidos
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
                
                % Escribir resultados
                stat = zeros(ceil(length(Precip_unir)/rows_max),1);
                for num_pl = 1:ceil(length(Precip_unir)/rows_max)
                    if num_pl ~= ceil(length(Precip_unir)/rows_max)
                        Result_unir = [{'FECHA (dd/mm/yyyy HH:MM)', 'PRECIPITACIÓN INSTANTÁNEA (mm)'}; ...
                            Date_unir((num_pl-1)*rows_max + 1:num_pl*rows_max), num2cell(Precip_unir((num_pl-1)*rows_max + 1:num_pl*rows_max),2)];
                        fecha1 = Date_unir{(num_pl-1)*rows_max + 1};      	fecha1 = fecha1(1:10);
                        fecha2 = Date_unir{num_pl*rows_max};                fecha2 = fecha2(1:10);
                        stat(num_pl) = xlswrite(fullfile(path_sheets,['Pluviogramas Unidos ' fecha1 ' a ' fecha2 ' (' num2str(num_pl) ').xlsx']), ...
                            Result_unir, 1, 'A1');
                    else
                        Result_unir = [{'FECHA (dd/mm/yyyy HH:MM)', 'PRECIPITACIÓN INSTANTÁNEA (mm)'}; ...
                            Date_unir((num_pl-1)*rows_max + 1:end), num2cell(Precip_unir((num_pl-1)*rows_max + 1:end))];
                        fecha1 = Date_unir{(num_pl-1)*rows_max + 1};      	fecha1 = fecha1(1:10);
                        fecha2 = Date_unir{end};                            fecha2 = fecha2(1:10);
                        stat(num_pl) = xlswrite(fullfile(path_sheets,['Pluviogramas Unidos ' fecha1 ' a ' fecha2 ' (' num2str(num_pl) ').xlsx']), ...
                            Result_unir, 1, 'A1');
                    end
                end

                if all(stat)
                    
                    % Cuadro con mensaje
                    uiwait(msgbox({'Operación Completada.'
                        'Las planillas con resultados han sido unidas.'
                        'La nueva planilla ha sido guardada en la carpeta seleccionada al inicio.'},'Exportar Resultados','modal'));
                    % Mensaje en la ventana de comandos
                    disp(['- (5.3) Unir Planillas                           TERMINADO!        ' datestr(now)])
                end               
                
            end
        end
        
    else
        % Cuadro de error en caso que las planillas no se encuentren en
        % formato .xlsx
        errordlg({'La carpeta seleccionada debe contener planillas con resultados.'
            ['Todas las planillas deben encontrarse en formato ' formato ' para su unión.']}, ...
            'Error: Carpeta o planillas no válidas')
    end
end