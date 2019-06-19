% (4.2) EXPORTAR RESULTADOS

if (exist('BW','var') || exist('BW0','var')) ...
        && exist('precip_inst','var') && exist('precip_acum','var')
    
    answer_export = inputdlg( ...
        ['Ingrese un valor para la resoluci�n temporal de los resultados (min).' ...
        '                     ' ...
        'Se sugiere un valor m�nimo de 5 min:'], ...
        'Exportar Resultados', ...
        [1 45], {'5'});
    
    if ~ isempty(answer_export)
        % Llevar resoluci�n temporal a n�mero y transformarlo a d�as
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
                % Si existe el nombre de la estaci�n
                [file_export, path_export] = uiputfile({'*.*','Todos los Archivos'},'Exportar Resultados', ...
                    ['Pluviograma ' estacion ' ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            else
                % Si no existe el nombre
                [file_export, path_export] = uiputfile({'*.*','Todos los Archivos'},'Exportar Resultados', ...
                    ['Pluviograma estaci�n ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            end
            
            if ischar(file_export) && ischar(path_export)
                % Escribir resultados para Planilla Excel
                DATE = datestr(TIME,'dd/mm/yyyy HH:MM');
                Result = [{'FECHA (dd/mm/yyyy HH:MM)', 'PRECIPITACI�N INSTANT�NEA (mm)', 'PRECIPITACI�N ACUMULADA (mm)'}; ...
                    num2cell(DATE,2), num2cell([PRECIP_INST, PRECIP_ACUM])];
                
                % Escribir Planilla
                stat_exp1 = xlswrite([path_export file_export], Result, 1, 'A3');
                stat_exp2 = xlswrite([path_export file_export], {['LECTURA DE PRECIPITACIONES, ENTRE EL ' fecha_inicio ' Y EL ' fecha_termino]}, 1, 'A1');
                
                if stat_exp1 && stat_exp2
                    % Cuadro con mensaje
                    uiwait(msgbox({'Operaci�n Completada.','Las planillas con resultados han sido creadas.'},'Exportar Resultados','modal'));
                    % Mensaje en la ventana de comandos
                    disp(['- (4.2) Exportar Resultados                      TERMINADO!        ' datestr(now)])
                end
            end
                
        elseif d_TIME < d_time
            % Cuadro de error en caso de elegir una resoluci�n temporal que
            % es menor a la resoluci�n de la imagen
            errordlg(['Debe elegir una resoluci�n temporal mayor a ' num2str(d_time*24*60) ' min, '...
                'que es la resoluci�n m�nima de la imagen.'],'Error: Resoluci�n temporal no v�lida')
        elseif mod(time_final-time_inicial,d_TIME) ~= 0
            % Cuadro de error en caso de elegir una resoluci�n temporal que
            % no divide de forma exacta la semana
            errordlg(['Debe elegir una resoluci�n temporal que divida de forma exacta la semana. ' ...
                'De preferencia, en m�ltiplos de 5 min.'],'Error: Resoluci�n temporal no v�lida')
        end
    end
    
        
elseif (exist('BW','var') || exist('BW0','var')) && ~ exist('hieto','var')
    % Cuadro de error en caso de no haber definido fecha y hora, de
    % inicio y t�rmino, de la imagen
    errordlg('Debe realizar la digitalizaci�n antes de exportar resultados.','Error: Digitalizaci�n no Realizada')
elseif exist('RGB','var') && ~ exist('BW','var') && ~ exist('BW0','var')
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la l�nea antes de unir y eliminar elementos.','Error: Linea no Identificada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de unir y eliminar elementos.','Error: Imagen no encontrada')
end