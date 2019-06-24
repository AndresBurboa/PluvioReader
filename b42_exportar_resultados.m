if (exist('BW','var') || exist('BW0','var')) ...
        && exist('precip_inst','var') && exist('precip_acum','var')
    
    answer_export = inputdlg( ...
        ['Please input the desired temporal resolution (time step) for results (min).' ...
        '                     ' ...
        'For weekly pluviograms, we suggest not going below 5 min:'], ...
        'Export Results', ...
        [1 45], {'5'});
    
    if ~ isempty(answer_export)
        
        d_TIME_str = answer_export{1};
        d_TIME = str2double(d_TIME_str)/24/60;
        
        TIME = time_inicial:d_TIME:time_final;
        TIME = TIME';
        
        PRECIP_INST = zeros(length(TIME),1);
        
        if d_TIME >= d_time && mod(time_final-time_inicial,d_TIME) == 0
            
            n2 = 1;
            n1 = 1;
            for N = 2:length(TIME)
                while n2+1 <= length(time) && TIME(N) > time(n2+1)
                    n2 = n2 + 1;
                end
                PRECIP_INST(N) = sum(precip_inst(n1+1:n2)) + ...
                    (TIME(N) - time(n2))/d_time*precip_inst(n2+1) + ...
                    (time(n1) - TIME(N-1))/d_time*precip_inst(n1);
                n1 = n2 + 1;
            end
            PRECIP_ACUM = cumsum(PRECIP_INST);
            
            if exist('estacion','var') && ~ isempty(estacion)
                [file_export, path_export] = uiputfile({'*.*','All Files'},'Export Results', ...
                    ['Pluviogram ' estacion ' ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            else
                [file_export, path_export] = uiputfile({'*.*','All Files'},'Export Results', ...
                    ['Pluviogram Station ' datestr(datenum(fecha_inicio,'dd/mm/yyyy')) '.xlsx']);
            end
            
            if ischar(file_export) && ischar(path_export)
                DATE = datestr(TIME,'dd/mm/yyyy HH:MM');
                Result = [{'DATE (dd/mm/yyyy HH:MM)', 'RAINFALL DEPTH (mm)', 'CUMULATIVE RAINFALL (mm)'}; ...
                    num2cell(DATE,2), num2cell([PRECIP_INST, PRECIP_ACUM])];
                
                stat_exp1 = xlswrite([path_export file_export], Result, 1, 'A3');
                stat_exp2 = xlswrite([path_export file_export], {['RAINFALL VALUES BETWEEN ' fecha_inicio ' AND ' fecha_termino]}, 1, 'A1');
                
                if stat_exp1 && stat_exp2
                    uiwait(msgbox({'Operation Completed.','The spreadsheets with the results have been created.'},'Export Results','modal'));
                    disp(['- (4.2) Export Results                      COMPLETED!' datestr(now)])
                end
            end
                
        elseif d_TIME < d_time
            errordlg(['You must select a time resolution (time step) larger than ' num2str(d_time*24*60) ' min, '...
                'as this is the minimum resolution for this image.'],'Error: Invalid Time Resolution')
        elseif mod(time_final-time_inicial,d_TIME) ~= 0
            errordlg(['You must choose a temporal resolution (time step) that is an exact divisor of one week. ' ...
                'Preferently, use integer multiples of 5 min.'],'Error: Invalid time resolution')
        end
    end
    
        
elseif (exist('BW','var') || exist('BW0','var')) && ~ exist('hieto','var')
    errordlg('You must digitize before exporting results.','Error: Digitization not completed')
elseif exist('RGB','var') && ~ exist('BW','var') && ~ exist('BW0','var')
    errordlg('You must identify the line before exporting results.','Error: Line not identified')
else
    errordlg('You must select an image before exporting results.','Error: Image not found')
end