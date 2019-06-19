% (1.2) AÑADIR INFORMACIÓN DE LA IMAGEN

if exist('RGB','var')
    
    % Información predeterminada
    answer_info0 = {'','01/01/2013','08:00','08/01/2013','08:00'};
    
    % Ventana de ingreso de información
    if ~ exist('answer_info','var') || isempty(answer_info)
        % Cuadro de diálogo si no se ha ingresado info anteriormente
        answer_info = inputdlg({ ...
            'Nombre de la Estación Pluviográfica:'
            'Fecha de Inicio (Ej: 24/12/2000):'
            'Hora de Inicio (Ej: 08:00):'
            'Fecha de Término (Ej: 31/12/2000):'
            'Hora de Término (Ej: 08:00):'}, ...
            'Añadir Información de la Imagen', ...
            [1 40], answer_info0);
    else
        % Cuadro de diálogo si se ha ingresado info
        answer_info = inputdlg({ ...
            'Nombre de la Estación Pluviográfica:'
            'Fecha de Inicio (Ej: 24/12/2000):'
            'Hora de Inicio (Ej: 08:00):'
            'Fecha de Término (Ej: 31/12/2000):'
            'Hora de Término (Ej: 08:00):'}, ...
            'Añadir Información de la Imagen', ...
            [1 40], answer_info);
    end

    if ~ isempty(answer_info)

        % Separación de la información
        estacion = answer_info{1};
        fecha_inicio = answer_info{2};
        hora_inicio = answer_info{3};
        fecha_termino = answer_info{4};
        hora_termino = answer_info{5};

        % Cuadros de error en caso de haber definido mal la fecha
        if (isempty(fecha_inicio) == 0  || isempty(fecha_termino) == 0) && ...
            (numel(fecha_inicio) ~= 10 || numel(fecha_termino) ~= 10 || ...
            fecha_inicio(3) ~= '/' || fecha_termino(3) ~= '/' || ...
            fecha_inicio(6) ~= '/' || fecha_termino(6) ~= '/' || ...
            str2double(fecha_inicio(1:2)) > 31 || str2double(fecha_termino(1:2)) > 31 || ...
            str2double(fecha_inicio(4:5)) > 12 || str2double(fecha_termino(4:5)) > 12)
        errordlg('El formato de fecha no es válido o no corresponde al especificado. Vuelva a añadir información.','Error: Fecha ingresada no válida');
        % Cuadros de error en caso de haber definido mal la hora
        elseif (isempty(hora_inicio) == 0  || isempty(hora_termino) == 0) && ...
            (numel(hora_inicio) ~= 5 || numel(hora_termino) ~= 5 || ...
            hora_inicio(3) ~= ':' || hora_termino(3) ~= ':' || ...
            str2double(hora_inicio(1:2)) > 23 || str2double(hora_termino(1:2)) > 23 || ...
            str2double(hora_inicio(4:5)) > 59 || str2double(hora_termino(4:5)) > 59)
        errordlg('El formato de hora no es válido o no corresponde al especificado. Vuelva a añadir información.','Error: Hora ingresada no válida');
        % Cuadro de error en caso de haber definido una fecha de inicio
        % posterior a la de término
        elseif datenum(fecha_inicio,'dd/mm/yyyy') >= ...
            datenum(fecha_termino,'dd/mm/yyyy')
        errordlg('La fecha de inicio es posterior a la fecha de término. Vuelva a añadir información.','Error: Fecha ingresada incorrecta');
        else
            % Mensaje en la ventana de comandos
            disp(['- (1.2) Añadir Información de la Imagen          TERMINADO!        ' datestr(now)])
        end
    end
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de definir márgenes.','Error: Imagen no encontrada')
end