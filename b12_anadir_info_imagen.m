if exist('RGB','var')
    
    answer_info0 = {'','06/01/2020','08:00','12/01/2020','08:00'};
    
    if ~ exist('answer_info','var') || isempty(answer_info)
        answer_info = inputdlg({ ...
            'Name of Weather Station:'
            'Beginning Date (Ex: 24/12/2000):'
            'Beginning Time (Ex: 08:00):'
            'End Date (Ex: 31/12/2000):'
            'End Time (Ex: 08:00):'}, ...
            'Add Information about this Image', ...
            [1 40], answer_info0);
    else
        answer_info = inputdlg({ ...
            'Name of Weather Station:'
            'Beginning Date (Ex: 24/12/2000):'
            'Beginning Time (Ex: 08:00):'
            'End Date (Ex: 31/12/2000):'
            'End Time (Ex: 08:00):'}, ...
            'Add Information about this Image', ...
            [1 40], answer_info);
    end

    if ~ isempty(answer_info)

        estacion = answer_info{1};
        fecha_inicio = answer_info{2};
        hora_inicio = answer_info{3};
        fecha_termino = answer_info{4};
        hora_termino = answer_info{5};

        if (isempty(fecha_inicio) == 0  || isempty(fecha_termino) == 0) && ...
            (numel(fecha_inicio) ~= 10 || numel(fecha_termino) ~= 10 || ...
            fecha_inicio(3) ~= '/' || fecha_termino(3) ~= '/' || ...
            fecha_inicio(6) ~= '/' || fecha_termino(6) ~= '/' || ...
            str2double(fecha_inicio(1:2)) > 31 || str2double(fecha_termino(1:2)) > 31 || ...
            str2double(fecha_inicio(4:5)) > 12 || str2double(fecha_termino(4:5)) > 12)
        errordlg('Date is not valid or else date format is not DD/MM/YYYY as requested. Please input Start Date again.','Error: Start Date is not valid');
        elseif (isempty(hora_inicio) == 0  || isempty(hora_termino) == 0) && ...
            (numel(hora_inicio) ~= 5 || numel(hora_termino) ~= 5 || ...
            hora_inicio(3) ~= ':' || hora_termino(3) ~= ':' || ...
            str2double(hora_inicio(1:2)) > 23 || str2double(hora_termino(1:2)) > 23 || ...
            str2double(hora_inicio(4:5)) > 59 || str2double(hora_termino(4:5)) > 59)
        errordlg('Time is not valid or else time format is not HH:MM as requested. Please input Start Time again.','Error: Start Time is not valid');
        elseif datenum(fecha_inicio,'dd/mm/yyyy') >= ...
            datenum(fecha_termino,'dd/mm/yyyy')
        errordlg('Start Date is after End Date. Please input Date again.','Error: Date is wrong');
        else
            disp(['- (1.2) Add information about this Image          COMPLETED!        ' datestr(now)])
        end
    end
else
    errordlg('You must select an image before defining margins.','Error: Image not found')
end