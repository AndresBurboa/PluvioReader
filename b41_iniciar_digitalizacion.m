if (exist('BW','var') || exist('BW0','var')) ...
        && exist('x_margen3','var') && exist('x_margen4','var')
    
    if exist('fecha_inicio','var') && exist('hora_inicio','var') ...
        && exist('fecha_termino','var') && exist('hora_termino','var')
    
    close all force
        BW = BW0;
        
        [~, NUM] = bwlabel(BW);
        
        thick = 10;
        
        if NUM == 1 || digitalizar
            
            i_inicial = 1;
            j_inicial = 1;
            while all(BW(:,j_inicial) == 0)
                j_inicial = j_inicial + 1;
            end
            while BW(i_inicial,j_inicial) == 0
                i_inicial = i_inicial + 1;
            end
            i_final = 1;
            j_final = cols;
            while all(BW(:,j_final) == 0)
                j_final = j_final - 1;
            end
            while BW(i_final,j_final) == 0
                i_final = i_final + 1;
            end
            BW(i_inicial,x_margen1:j_inicial) = 1;
            BW(i_final,j_final:x_margen2) = 1;
            if x_margen1 < j_inicial
                j_inicial = x_margen1;
            end
            if x_margen2 > j_final
                j_final = x_margen2;
            end
            
            j_vec = j_inicial:j_final;
            i_up_vec = zeros(size(j_vec));
            i_dw_vec = i_up_vec;
            for k = 1:length(j_vec)
                j = j_vec(k);
                BW_j = BW(:,j);
                if k == 1
                    i_up = i_inicial;
                    i_dw = i_inicial;
                else
                    i_up = i_up_vec(k-1);
                    i_dw = i_dw_vec(k-1);
                end
                while ~ any(BW_j(1:i_up))
                    i_up = i_up + 1;
                end
                while any(BW_j(1:i_up-1))
                    i_up = i_up - 1;
                end
                while ~ any(BW_j(i_dw:rows))
                    i_dw = i_dw - 1;
                end
                while any(BW_j(i_dw+1:rows))
                    i_dw = i_dw + 1;
                end
                i_up_vec(k) = i_up;
                i_dw_vec(k) = i_dw;
            end
            
            i_up_aux = rows - i_up_vec;
            rate_ext = 0.7;
            mph_dw = rate_ext*(max(i_dw_vec) - min(i_dw_vec)) + min(i_dw_vec);
            mph_up = rate_ext*(max(i_up_aux) - min(i_up_aux)) + min(i_up_aux);
            mpd = 0.6*thick;
            [I_inf, J_inf] =    findpeaks(i_dw_vec,'MinPeakHeight',mph_dw,'MinPeakDistance',mpd);
            J_inf = J_inf + j_vec(1) - 1;
            [~, J_sup] =        findpeaks(i_up_aux,'MinPeakHeight',mph_up,'MinPeakDistance',mpd);
            I_sup = i_up_vec(J_sup);
            J_sup = J_sup + j_vec(1) - 1;
            
            dI = 10;
            borrar_IJ = ones(size(I_inf));
            for k = 1:length(I_inf)
                if k == 1
                    ind_k = (j_inicial:J_inf(k)) - j_vec(1) + 1;
                    crit = min(i_dw_vec(ind_k)) < I_inf(k) - dI;
                else
                    ind_k = (J_inf(k-1):J_inf(k)) - j_vec(1) + 1;
                    crit = min(i_dw_vec(ind_k)) < I_inf(k) - dI;
                end
                if crit
                    borrar_IJ(k) = 0;
                end
            end
            I_inf(logical(borrar_IJ)) = [];
            J_inf(logical(borrar_IJ)) = [];
            borrar_IJ = ones(size(I_sup));
            for k = 1:length(I_sup)
                if k == length(I_sup)
                    ind_k = (J_sup(k):j_final) - j_vec(1) + 1;
                    crit = max(i_up_vec(ind_k)) > I_sup(k) + dI;
                else
                    ind_k = (J_sup(k):J_sup(k+1)) - j_vec(1) + 1;
                    crit = max(i_up_vec(ind_k)) > I_sup(k) + dI;
                end
                if crit
                    borrar_IJ(k) = 0;
                end
            end
            I_sup(logical(borrar_IJ)) = [];
            J_sup(logical(borrar_IJ)) = [];
            
            for n = 1:length(J_sup)
                dj = 0;
                while BW(I_sup(n),J_sup(n)+dj+1) == 1
                    dj = dj + 1;
                end
                J_sup(n) = J_sup(n) + round(max(dj - thick/2,dj/2));
            end
            for n = 1:length(J_inf)
                dj = 0;
                while BW(I_inf(n),J_inf(n)+dj+1) == 1
                    dj = dj + 1;
                end
                J_inf(n) = J_inf(n) + round(min(thick/2,dj/2));
            end
            
%             d_elim_if = 10;
%             if (I_inf(1) - i_inicial)^2 + (J_inf(1) - j_inicial)^2 < d_elim_if^2
%                 I_inf(1) = [];
%                 J_inf(1) = [];
%             elseif (I_sup(1) - i_inicial)^2 + (J_sup(1) - j_inicial)^2 < d_elim_if^2
%                 I_sup(1) = [];
%                 J_sup(1) = [];
%             end
%             if (I_inf(end) - i_final)^2 + (J_inf(end) - j_final)^2 < d_elim_if^2
%                 I_inf(end) = [];
%                 J_inf(end) = [];
%             elseif (I_sup(end) - i_final)^2 + (J_sup(end) - j_final)^2 < d_elim_if^2
%                 I_sup(end) = [];
%                 J_sup(end) = [];
%             end

            if numel(I_sup) > numel(I_inf)
                err_sup = zeros(size(I_sup));
                for k = 1:numel(err_sup)
                    err_sup(k) = min(abs(J_inf - J_sup(k)));
                end
                while numel(I_sup) > numel(I_inf)
                    [~, ind_err] = max(err_sup);
                    I_sup(ind_err) = [];
                    J_sup(ind_err) = [];
                    err_sup(ind_err) = [];
                end
            elseif numel(I_inf) > numel(I_sup)
                err_inf = zeros(size(I_inf));
                for k = 1:numel(err_inf)
                    err_inf(k) = min(abs(J_sup - J_inf(k)));
                end
                while numel(I_inf) > numel(I_sup)
                    [~, ind_err] = max(err_inf);
                    I_inf(ind_err) = [];
                    J_inf(ind_err) = [];
                    err_inf(ind_err) = [];
                end
            end

            j_retro = 0;
            if numel(I_sup) == numel(I_inf) && numel(I_sup) ~= 0
                for V = 1:length(I_sup)
                    if J_inf(V) <= J_sup(V)
                        j_retro = j_retro + J_sup(V) - J_inf(V) + 1;
                    end
                end
            end
            
%             figure, imshow(BW), hold on, plot(J_sup,I_sup,'ro'), hold on, plot(J_inf,I_inf,'yo')
            
            dist_vert = mean(y_margen3 - y_margen1, y_margen4 - y_margen2);
            
            sum_pix_vert = sum(BW);
            
            if numel(I_sup) == numel(I_inf)
                num_time = j_final - j_inicial + j_retro + 1;
                time_inicial = datenum([fecha_inicio ' ' hora_inicio],'dd/mm/yyyy HH:MM');
                time_final = datenum([fecha_termino ' ' hora_termino],'dd/mm/yyyy HH:MM');
                time = linspace(time_inicial,time_final,num_time);
                time = time';
                d_time = time(2) - time(1); 

                precip_inst = zeros(num_time,1);
                pluvio = precip_inst;
                
                I_result = zeros(num_time,9);
                
                delta_pp = 10;
                rate_i_inic = 0.98;
                di_max = 0.5*(y_margen34 - y_margen12);
                di_min = 2;
                exp_w = 3;
                thick2 = 2*thick;
%                 di_dw = 10*thick;
%                 di_up = 10*thick;
                dj_dw = thick;
                dj_up = thick;
                
                if numel(I_sup) ~= 0
                    i_ref = i_inicial;
                    i_ant = i_inicial;
                    j = j_inicial;
                    n = 1;
                    n0 = 1;
                    for V = 1:length(I_sup)+1
                        while ( V == 1 && j >= j_inicial && j <= J_sup(V) ) ...
                                || ( V > 1 && V < length(I_sup)+1 && j >= J_inf(V-1) && j <= J_sup(V) ) ...
                                || ( V == length(I_sup)+1 && j <= j_final )
                            
                            ind_i = 1:rows; ind_i = ind_i';
                            
                            i_up = i_up_vec(j - j_vec(1) + 1);
                            i_dw = i_dw_vec(j - j_vec(1) + 1);

                            if V >= 2
                                if j == J_inf(V-1)
                                    i_up = i_dw - thick;
%                                 elseif j <= J_inf(V-1) + dj_dw && i_dw > i_dw_vec(j - j_vec(1) + thick) && ...
%                                         ( ( V <= length(J_sup) && j >= J_sup(V) + dj_up ) || V > length(J_sup) )
                                elseif j <= max(J_inf(V-1),J_sup(V-1)) + dj_dw && i_dw > i_dw_vec(j - j_vec(1) + 1 + thick)
                                    i_up = i_dw_vec(j - j_vec(1) + 1 + thick);
                                end
                            end
                            if V <= length(J_sup)
                                if j == J_sup(V)
                                    i_dw = i_up + thick;
%                                 elseif j >= J_sup(V) - dj_up && i_up < i_up_vec(j - j_vec(1) - thick) && ...
%                                         ( ( V >= 2 && j >= J_inf(V-1) - dj_dw ) || V < 2 )
                                elseif j >= min(J_sup(V),J_inf(V)) - dj_up && i_up < i_up_vec(j - j_vec(1) - 1 - thick)
                                    i_dw = i_up_vec(j - j_vec(1) + 1 - thick);
                                end
                            end
                            
                            if ( (V <= length(J_sup) && j >= J_inf(V) && j <= J_sup(V)) || ...
                                    (V >= 2 && j >= J_inf(V-1) && j <= J_sup(V-1)) ) && ...
                                    i_dw - i_up >= di_max
                                if abs(i_dw - i_ant) < abs(i_up - i_ant)
%                                     i_up = i_dw + thick;
                                    i_up = i_dw - max(0.5*sum_pix_vert(j - j_vec(1) + 1),thick);
                                else
%                                     i_dw = i_up + thick;
                                    i_dw = i_up - max(0.5*sum_pix_vert(j - j_vec(1) + 1),thick);
                                end
                            end
                            
                            if V >= 2 && V <= length(J_sup) && ...
                                    j <= max(J_inf(V-1),J_sup(V-1)) + dj_dw && j >= min(J_sup(V),J_inf(V)) - dj_up
                                i_up = i_up_vec(j - j_vec(1) + 1);
                                i_dw = i_dw_vec(j - j_vec(1) + 1);
                            end
                                
%                             figure, imshow(BW), hold on, plot(j_vec,I_result(:,3:4),'LineWidth',2)

                            ind_i(ind_i < i_up) = 0;
                            ind_i(ind_i > i_dw) = 0;
                            w_pond = double(max(B(:,j)-R(:,j),0) + max(B(:,j)-G(:,j),0) + 1).^exp_w;
                            w_pond(ind_i < i_up) = 0;
                            w_pond(ind_i > i_dw) = 0;
                            i = sum(w_pond.*ind_i.*BW(:,j))/sum(w_pond.*BW(:,j));
                            
                            precip_inst(n) = max(-(i - i_ref),0);
                            
                            if V > 1 && j == J_inf(V-1)
                                precip_inst(n) = 0;
                            end
                            
                            if i_ref > i
                                i_ref = i;
                            end
                            I_result(n,1:6) = [precip_inst(n), i, i_up, i_dw, i_ref, j];
                            i_ant = i;
                            j = j + 1;
                            n = n + 1;
                        end
                        if V == 1
                            if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                                di_precip = delta_pp/sum(precip_inst(n0:n-1));
                            else
                                di_precip = delta_pp*(i_inicial - y_margen1)/dist_vert/sum(precip_inst(n0:n-1));
                            end
                        elseif V == length(I_sup)+1
                            di_precip = delta_pp*(y_margen4 - i_final)/dist_vert/sum(precip_inst(n0:n-1));
                        else
                            di_precip = delta_pp/sum(precip_inst(n0:n-1));
                        end
                        precip_inst(n0:n-1) = di_precip*precip_inst(n0:n-1);
                        if V == 1
                            if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                                pp_ini = 0;
                            else
                                pp_ini = delta_pp*(y_margen3 - i_inicial)/dist_vert;
                            end
                            pluvio(n0:n-1) = cumsum(precip_inst(n0:n-1)) + pp_ini;
                        elseif V == length(I_sup)+1
                            pluvio(n0:n-1) = cumsum(precip_inst(n0:n-1));
                        else
                            pluvio(n0:n-1) = cumsum(precip_inst(n0:n-1));
                        end
                        if V <= length(I_sup)
                            if j > J_sup(V) && j < J_inf(V)
                                n = n + J_inf(V) - J_sup(V) - 1;
                            end
                            j = J_inf(V);
                            i_ref = I_inf(V);
                            i_ant = i_ref;
                            n0 = n;
                        end
                    end
                    
                else
                    i_ref = i_inicial;
                    i_ant = i_inicial;
                    j = j_inicial;
                    n = 1;
                    n0 = 1;
                    while j <= j_final
                        ind_i = 1:rows; ind_i = ind_i';

                        i_up = 1;
                        while BW(i_up,j) == 0
                            i_up = i_up + 1;
                        end
                        i_dw = rows;
                        while BW(i_dw,j) == 0
                            i_dw = i_dw - 1;
                        end
                        
                        ind_i(ind_i < i_up) = 0;
                        ind_i(ind_i > i_dw) = 0;
                        w_pond = double(max(B(:,j)-R(:,j),0) + max(B(:,j)-G(:,j),0) + 1).^exp_w;
                        w_pond(ind_i < i_up) = 0;
                        w_pond(ind_i > i_dw) = 0;
                        i = sum(w_pond.*ind_i.*BW(:,j))/sum(w_pond.*BW(:,j));
                        
                        precip_inst(n) = max(-(i - i_ref),0);
                        if i_ref > i
                            i_ref = i;
                        end
                        I_result(n,1:6) = [precip_inst(n), i, i_up, i_dw, i_ref, j];
                        i_ant = i;
                        j = j + 1;
                        n = n + 1;
                    end
                    if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                        di_precip = delta_pp*(y_margen4 - i_final)/dist_vert/sum(precip_inst);
                    else
                        di_precip = delta_pp*(i_inicial - i_final)/dist_vert/sum(precip_inst);
                    end
                    precip_inst = di_precip*precip_inst;
                    if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                        pp_ini = 0;
                    else
                        pp_ini = delta_pp*(y_margen3 - i_inicial)/dist_vert;
                    end
                    pluvio = cumsum(precip_inst) + pp_ini;
                end
                x_linea = I_result(1:end-1,6);
                y_linea = I_result(1:end-1,2);
                for n = 1:length(y_linea)
                    if y_linea(n) == 0
                        n2 = n + 1;
                        while y_linea(n2) == 0
                            n2 = n2 + 1;
                        end
                        x_linea(n:n2-1) = x_linea(n2)-(n2-n):x_linea(n2)-1;
                        y_linea(n:n2-1) = y_linea(n2);
                    end
                end
                
                precip_acum = cumsum(precip_inst);
                figure, subplot(2,1,1), imshow(RGB), hold on, plot(x_linea,y_linea,'r','LineWidth',1), hold off
%                         subplot(2,1,2), plot(time,pluvio),
%                                         datetick('x','dd-mmm-yy HH:MM','keepticks'),
%                                         axis([time_inicial, time_final, -0.1*delta_pp, 1.1*delta_pp])
                        subplot(2,1,2), imshow(imcomplement(BW)), hold on, plot(x_linea,y_linea,'r'), hold off
                        set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8])
                figure, subplot(2,1,1), plot(time,precip_inst),
                                        datetick('x','dd-mmm-yy HH:MM','keepticks'),
                                        axis([time_inicial, time_final, 0, 1.1*max(precip_inst)])
                        subplot(2,1,2), plot(time,precip_acum), grid on,
                                        datetick('x','dd-mmm-yy HH:MM','keepticks'),
                                        axis([time_inicial, time_final, 0, 1.1*precip_acum(end)])
                                        xlabel('Time [days]')
                                        ylabel('Rainfall depth [mm]')
                        set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8])
                        
                        % debug
%                         figure, imshow(BW), hold on, plot(I_result(:,6),I_result(:,3:4),'LineWidth',2)
%                         figure, imshow(imcomplement(BW)), hold on,
%                         plot(J_sup, I_sup, 'ro', 'LineWidth', 2), hold on,
%                         plot(J_inf, I_inf, 'ro', 'LineWidth', 2)
                        
                disp(['- (4.1) Start Line Digitization                   COMPLETED!' datestr(now)])
                                        
            else
                figure, imshow(imcomplement(BW)), hold on,
                        plot(J_sup, I_sup, 'ro', 'LineWidth', 2), hold on,
                        plot(J_inf, I_inf, 'ro', 'LineWidth', 2)
                errordlg('The software does not find as many maxima as minima in the image.','Error: Extreme values not found')
            end
        else
            [LAB_ext, NUM_ext] = bwlabel(BW);
            PROPS = regionprops(LAB_ext, 'All');

            menu_ini_dig = menu({ ...
                '(4.1) ERROR: START LINE DIGITIZATION'
                '_______________________________________'
                ''
                'IN ORDER TO DIGITIZE THERE MUST BE A SINGLE CONTINUOUS LINE'
                '(or its segments must not present empty columns).'
                [num2str(NUM_ext) ' SEGMENTS ARE FOUND']
                '_______________________________________'
                ''
                '(We recommend you join the line, either automatically or manually.'
                'Click OK or close this window in order to continue)'}, ...
                'OK');
            close
        end
    else
        errordlg('You must input information about start and end date/time for the image.','Error: Undefined Information')
    end
    
elseif ~ exist('x_margen3','var') && ~ exist('x_margen4','var') && exist('RGB','var')
    errordlg('You must define the margins before digitizing it.','Error: Undefined Margins')
elseif exist('RGB','var') && ~ exist('BW','var') && ~ exist('BW0','var')
    errordlg('You must identify the line before digitizing it.','Error: Line not identified')
else
    errordlg('You must select an image before digitizing line.','Error: Image not found')
end