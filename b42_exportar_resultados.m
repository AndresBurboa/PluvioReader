% (4.2) EXPORTAR RESULTADOS

if (exist('BW','var') || exist('BW0','var')) ...
        && exist('precip_inst','var') && exist('precip_acum','var')
    
    answer_export = inputdlg( ...
        ['Ingrese un valor para la resolución temporal de los resultados (min).' ...
        '                     ' ...
        'Se sugiere un valor mínimo de 5 min:'], ...
        'Exportar Resultados', ...
        [1 45], {'5'});
    
    if ~ isempty(answer_export)
        % Llevar resolución temporal a número y transformarlo a días
        d_TIME_str = answer_export{1};
        d_TIME = str2double(d_TIME_str)/24/60;
        % Crear vector de tiempo para exportar
        TIME = time_inicial:d_TIME:time_final;
        TIME = TIME';
        % Crear vector para almacenar hietograma a exportar
        PRECIP_INST = zeros(length(TIME),1);
        
        if d_TIME >= d_time && mod(time_final-time_inicial,d_TIME) == 0
            
            % Recorrer PRECIP_INST para almacenar valores
            n2 = 1;
            n1 = 1;
            for N = 2:length(TIME)
                while n2+1 <= length(time) && TIME(N) > time(n2+1)
                    n2 = n2 + 1;
                end
                % Escritura de hietograma a exportar
                PRECIP_INST(N) = sum(precip_inst(n1+1:n2)) + ...
                    (TIME(N) - time(n2))/d_time*precip_inst(n2+1) + ...
                    (time(n1) - TIME(N-1))/d_time*precip_inst(n1);
                n1 = n2 + 1;
            end
            % Escritura de pluviograma a exportar
            PRECIP_ACUM = cumsum(PRECIP_INST);
            
            % Seleccionar carpeta donde exportar planilla con resultados
            if exist('estacion','var') && ~ isempty(estacion)
                % Si existe el nombre de la estación
                [file_export, path_export] = uiputfile({'*.*','Todos los Archivos'},'Exportar Resultados', ...
                    ['Pluviograma ' estacion ' ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            else
                % Si no existe el nombre
                [file_export, path_export] = uiputfile({'*.*','Todos los Archivos'},'Exportar Resultados', ...
                    ['Pluviograma estación ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            end
            
            if ischar(file_export) && ischar(path_export)
                % Escribir resultados para Planilla Excel
                DATE = datestr(TIME,'dd/mm/yyyy HH:MM');
                Result = [{'FECHA (dd/mm/yyyy HH:MM)', 'PRECIPITACIÓN INSTANTÁNEA (mm)', 'PRECIPITACIÓN ACUMULADA (mm)'}; ...
                    num2cell(DATE,2), num2cell([PRECIP_INST, PRECIP_ACUM])];
                
                % Escribir Planilla
                stat_exp1 = xlswrite([path_export file_export], Result, 1, 'A3');
                stat_exp2 = xlswrite([path_export file_export], {['LECTURA DE PRECIPITACIONES, ENTRE EL ' fecha_inicio ' Y EL ' fecha_termino]}, 1, 'A1');
                
                if stat_exp1 && stat_exp2
                    % Cuadro con mensaje
                    uiwait(msgbox({'Operación Completada.','Las planillas con resultados han sido creadas.'},'Exportar Resultados','modal'));
                    % Mensaje en la ventana de comandos
                    disp(['- (4.2) Exportar Resultados                      TERMINADO!        ' datestr(now)])
                end
            end
                
        elseif d_TIME < d_time
            % Cuadro de error en caso de elegir una resolución temporal que
            % es menor a la resolución de la imagen
            errordlg(['Debe elegir una resolución temporal mayor a ' num2str(d_time*24*60) ' min, '...
                'que es la resolución mínima de la imagen.'],'Error: Resolución temporal no válida')
        elseif mod(time_final-time_inicial,d_TIME) ~= 0
            % Cuadro de error en caso de elegir una resolución temporal que
            % no divide de forma exacta la semana
            errordlg(['Debe elegir una resolución temporal que divida de forma exacta la semana. ' ...
                'De preferencia, en múltiplos de 5 min.'],'Error: Resolución temporal no válida')
        end
    end
    
        
elseif (exist('BW','var') || exist('BW0','var')) && ~ exist('hieto','var')
    % Cuadro de error en caso de no haber definido fecha y hora, de
    % inicio y término, de la imagen
    errordlg('Debe realizar la digitalización antes de exportar resultados.','Error: Digitalización no Realizada')
elseif exist('RGB','var') && ~ exist('BW','var') && ~ exist('BW0','var')
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la línea antes de unir y eliminar elementos.','Error: Linea no Identificada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de unir y eliminar elementos.','Error: Imagen no encontrada')
end