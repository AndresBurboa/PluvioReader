% (4.1) INICIAR DIGITALIZACI�N

if (exist('BW','var') || exist('BW0','var')) ...
        && exist('x_margen3','var') && exist('x_margen4','var')
    
    if exist('fecha_inicio','var') && exist('hora_inicio','var') ...
        && exist('fecha_termino','var') && exist('hora_termino','var')
    
    close all force
        % Redefinir BW (para quitar sugerencia de prealojar la imagen)
        BW = BW0;
        
        % Etiquetar imagen
        [~, NUM] = bwlabel(BW);
        
        % Grosor medio de linea
        thick = 10;
        
        if NUM == 1 || digitalizar
            
            % DEFINIR �NDICE INICIAL Y FINAL, EXTENDER LINEA HASTA LOS
            % M�RGENES IZQUIERDO Y DERECHO
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
            % Alargar l�nea hasta el margen izquierdo y derecho (de ser
            % necesario)
            BW(i_inicial,x_margen1:j_inicial) = 1;
            BW(i_final,j_final:x_margen2) = 1;
            if x_margen1 < j_inicial
                j_inicial = x_margen1;
            end
            if x_margen2 > j_final
                j_final = x_margen2;
            end
            
            % DELIMITAR LA PARTE SUPERIOR E INFERIOR DE LA L�NEA
            j_vec = j_inicial:j_final;
            i_up_vec = zeros(size(j_vec));
            i_dw_vec = i_up_vec;
            for k = 1:length(j_vec)
                % Columna j y vector asociado a BW
                j = j_vec(k);
                BW_j = BW(:,j);
                % Valores iniciales
                if k == 1
                    i_up = i_inicial;
                    i_dw = i_inicial;
                else
                    i_up = i_up_vec(k-1);
                    i_dw = i_dw_vec(k-1);
                end
                % Delimitaci�n superior
                while ~ any(BW_j(1:i_up))
                    i_up = i_up + 1;
                end
                while any(BW_j(1:i_up-1))
                    i_up = i_up - 1;
                end
                % Delimitaci�n inferior
                while ~ any(BW_j(i_dw:rows))
                    i_dw = i_dw - 1;
                end
                while any(BW_j(i_dw+1:rows))
                    i_dw = i_dw + 1;
                end
                % Valor final
                i_up_vec(k) = i_up;
                i_dw_vec(k) = i_dw;
            end
            
            % OBTENER LOS PEAKS DE LOS VECTORES DE DELIMITACI�N
            % Variable auxiliar de i_up_vec, ya que sus puntos m�s altos
            % corresponden a m�nimos
            i_up_aux = rows - i_up_vec;
            % Altura m�nima de los peaks
            rate_ext = 0.7;
            mph_dw = rate_ext*(max(i_dw_vec) - min(i_dw_vec)) + min(i_dw_vec);
            mph_up = rate_ext*(max(i_up_aux) - min(i_up_aux)) + min(i_up_aux);
            % Y separaci�n m�nima
            mpd = 0.6*thick;
            % C�lculo de peaks inferiores
            [I_inf, J_inf] =    findpeaks(i_dw_vec,'MinPeakHeight',mph_dw,'MinPeakDistance',mpd);
            J_inf = J_inf + j_vec(1) - 1;
            % Y peaks superiores, con correcci�n debido al uso de i_up_aux
            [~, J_sup] =        findpeaks(i_up_aux,'MinPeakHeight',mph_up,'MinPeakDistance',mpd);
            I_sup = i_up_vec(J_sup);
            J_sup = J_sup + j_vec(1) - 1;
            
            % ELIMINAR PEAKS QUE NO CORRESPONDEN A LOS PUNTOS DE
            % VACIAMIENTO
            % Se define como peaks que no son vaciamientos a los que no
            % poseen un valor bajo entre el peak y el peak anterior, y
            % entre el peak y el peak siguiente
            dI = 10;          % valor bajo definido
            % Recorrer los PEAKS INFERIORES
            borrar_IJ = ones(size(I_inf));
            for k = 1:length(I_inf)
                % Intervalos entre peaks y criterio que define un punto de
                % vaciamiento
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
            % Y borrar
            I_inf(logical(borrar_IJ)) = [];
            J_inf(logical(borrar_IJ)) = [];
            % Recorrer los PEAKS SUPERIORES
            borrar_IJ = ones(size(I_sup));
            for k = 1:length(I_sup)
                % Intervalos entre peaks y criterio que define un punto de
                % vaciamiento
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
            % Y borrar
            I_sup(logical(borrar_IJ)) = [];
            J_sup(logical(borrar_IJ)) = [];
            
            % Corregir J_sup y J_inf al seleccionar el primero de varios
            % elementos extremos
            % Correcci�n J_sup
            for n = 1:length(J_sup)
                dj = 0;
                while BW(I_sup(n),J_sup(n)+dj+1) == 1
                    dj = dj + 1;
                end
                J_sup(n) = J_sup(n) + round(max(dj - thick/2,dj/2));
            end
            % Correcci�n J_inf
            for n = 1:length(J_inf)
                dj = 0;
                while BW(I_inf(n),J_inf(n)+dj+1) == 1
                    dj = dj + 1;
                end
                J_inf(n) = J_inf(n) + round(min(thick/2,dj/2));
            end
            
%             % Eliminar extremos que correspondan al inicio y final
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

            % ELIMINAR PEAKS SI NO COINCIDE LA CANTIDAD DE PEAKS SUPERIORES
            % E INFIERIORES seg�n criterio de peaks con �ndice j lejano
            % Si la cantidad de peaks superiores es mayor
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
            % Si la cantidad de peaks inferiores es mayor
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

            % Calcular longitud total del retroceso para los �ndices
            % inferiores que se encuentran antes de sus superiores
            j_retro = 0;
            if numel(I_sup) == numel(I_inf) && numel(I_sup) ~= 0
                for V = 1:length(I_sup)
                    if J_inf(V) <= J_sup(V)
                        j_retro = j_retro + J_sup(V) - J_inf(V) + 1;
                    end
                end
            end
            
%             figure, imshow(BW), hold on, plot(J_sup,I_sup,'ro'), hold on, plot(J_inf,I_inf,'yo')
            
            % Distancia vertical media entre m�rgenes
            dist_vert = mean(y_margen3 - y_margen1, y_margen4 - y_margen2);
            
            % Suma vertical de BW
            sum_pix_vert = sum(BW);
            
            if numel(I_sup) == numel(I_inf)
                % Tiempo inicial, final y vector asociado
                num_time = j_final - j_inicial + j_retro + 1;
                time_inicial = datenum([fecha_inicio ' ' hora_inicio],'dd/mm/yyyy HH:MM');
                time_final = datenum([fecha_termino ' ' hora_termino],'dd/mm/yyyy HH:MM');
                time = linspace(time_inicial,time_final,num_time);
                time = time';
                d_time = time(2) - time(1); 

                % Vectores de almacenamiento de precipitaci�n instantanea
                % (precip_inst) y precipitaci�n tal como el pluviograma
                % (pluvio)
                precip_inst = zeros(num_time,1);
                pluvio = precip_inst;
                
                % Matriz de almacenamiento de resultados de digitalizaci�n,
                % �til para revisar errores
                I_result = zeros(num_time,9);
                
                % Variables para digitalizaci�n
                % Cantidad de precipitaci�n necesaria para vaciar el
                % instrumento
                delta_pp = 10;
                % Porcentaje de pixeles con que se considera que el inicio
                % es cero
                rate_i_inic = 0.98;
                % Variables de diferencia umbral entre �ndices i de la
                % imagen, para correcciones
                di_max = 0.5*(y_margen34 - y_margen12);
                di_min = 2;
                % Exponente de coef de ponderaci�n para obtener i
                % representativo de la l�nea
                exp_w = 10;
                % Variable auxiliar de grosor, en caso de encontrarse
                % exactamente en un extremo
                thick2 = 2*thick;
                % Variables para evitar errores de estimaci�n en los
                % extremos
%                 di_dw = 10*thick;
%                 di_up = 10*thick;
                dj_dw = thick;
                dj_up = thick;
                
                % CASO 1: HAY M�S DE delta_pp DE PRECIPITACI�N (el
                % pluviograma presenta 1 o m�s vaciamientos)
                if numel(I_sup) ~= 0
                    % Recorrer imagen y almacenar valores
                    i_ref = i_inicial;
                    i_ant = i_inicial;
                    j = j_inicial;
                    n = 1;
                    n0 = 1;
                    for V = 1:length(I_sup)+1
                        % Recorrer pixeles de la imagen
                        while ( V == 1 && j >= j_inicial && j <= J_sup(V) ) ...
                                || ( V > 1 && V < length(I_sup)+1 && j >= J_inf(V-1) && j <= J_sup(V) ) ...
                                || ( V == length(I_sup)+1 && j <= j_final )
                            
                            % �ndices i para cada j
                            ind_i = 1:rows; ind_i = ind_i';
                            
                            % �ndices superior e inferior
                            i_up = i_up_vec(j - j_vec(1) + 1);
                            i_dw = i_dw_vec(j - j_vec(1) + 1);

                            % Corregir �ndices i en los extremos
                            % superior e inferior
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
                            
                            % Correcci�n en vaciamientos con retroceso
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
                            
                            % Reseteo de las correcciones si j est� entre
                            % dos vaciamientos muy cercanos
                            if V >= 2 && V <= length(J_sup) && ...
                                    j <= max(J_inf(V-1),J_sup(V-1)) + dj_dw && j >= min(J_sup(V),J_inf(V)) - dj_up
                                i_up = i_up_vec(j - j_vec(1) + 1);
                                i_dw = i_dw_vec(j - j_vec(1) + 1);
                            end
                                
%                             figure, imshow(BW), hold on, plot(j_vec,I_result(:,3:4),'LineWidth',2)

                            % Restricci�n de los �ndices de la columna
                            ind_i(ind_i < i_up) = 0;
                            ind_i(ind_i > i_dw) = 0;
                            % Evaluaci�n de coeficientes de ponderaci�n y
                            % restricci�n de �stos
                            w_pond = double(max(B(:,j)-R(:,j),0) + max(B(:,j)-G(:,j),0) + 1).^exp_w;
                            w_pond(ind_i < i_up) = 0;
                            w_pond(ind_i > i_dw) = 0;
                            % Evaluaci�n definitiva del �ndice i
                            % representativo de la columna
                            i = sum(w_pond.*ind_i.*BW(:,j))/sum(w_pond.*BW(:,j));
                            
                            % Escritura preliminar de precip_inst
                            % (escritura de su valor en �ndices i)
                            precip_inst(n) = max(-(i - i_ref),0);
                            
                            % Correcci�n para el 1� elemento
                            if V > 1 && j == J_inf(V-1)
                                precip_inst(n) = 0;
                            end
                            
                            % Actualizaci�n de �ndices (1)
                            if i_ref > i
                                i_ref = i;
                            end
                            % Almacenamiento resultados (2)
                            I_result(n,1:6) = [precip_inst(n), i, i_up, i_dw, i_ref, j];
                            % Actualizaci�n de �ndices (2)
                            i_ant = i;
                            j = j + 1;
                            n = n + 1;
                        end
                        % Definir valor de precipitaci�n de cada pixel, en
                        % cada intervalo
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
                        % ESCRITURA DE precip_inst
                        precip_inst(n0:n-1) = di_precip*precip_inst(n0:n-1);
                        % ESCRITURA DE pluvio
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
                        % Actualizaci�n de �ndices
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
                    
                % CASO 2: NO HAY M�S DE delta_pp DE PRECIPITACI�N (no se
                % vac�a el instrumento)
                else
                    % Recorrer imagen y almacenar valores
                    i_ref = i_inicial;
                    i_ant = i_inicial;
                    j = j_inicial;
                    n = 1;
                    n0 = 1;
                    % Recorrer pixeles de la imagen
                    while j <= j_final
                        % �ndices i para cada j
                        ind_i = 1:rows; ind_i = ind_i';

                        % �ndices superior e inferior
                        i_up = 1;
                        while BW(i_up,j) == 0
                            i_up = i_up + 1;
                        end
                        i_dw = rows;
                        while BW(i_dw,j) == 0
                            i_dw = i_dw - 1;
                        end
                        
                        % Restricci�n de los �ndices de la columna
                        ind_i(ind_i < i_up) = 0;
                        ind_i(ind_i > i_dw) = 0;
                        % Evaluaci�n de coeficientes de ponderaci�n y
                        % restricci�n de estos
                        w_pond = double(max(B(:,j)-R(:,j),0) + max(B(:,j)-G(:,j),0) + 1).^exp_w;
                        w_pond(ind_i < i_up) = 0;
                        w_pond(ind_i > i_dw) = 0;
                        % Evaluaci�n definitiva de �ndice
                        % representativo de la columna
                        i = sum(w_pond.*ind_i.*BW(:,j))/sum(w_pond.*BW(:,j));
                        
                        % Escritura preliminar de precip_inst
                        precip_inst(n) = max(-(i - i_ref),0);
                        % Actualizaci�n �ndices (1)
                        if i_ref > i
                            i_ref = i;
                        end
                        % Almacenamiento resultados (2)
                        I_result(n,1:6) = [precip_inst(n), i, i_up, i_dw, i_ref, j];
                        % Actualizaci�n �ndices (2)
                        i_ant = i;
                        j = j + 1;
                        n = n + 1;
                    end
                    % Definir valor de precipitaci�n de cada pixel, en
                    % cada intervalo
                    if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                        di_precip = delta_pp*(y_margen4 - i_final)/dist_vert/sum(precip_inst);
                    else
                        di_precip = delta_pp*(i_inicial - i_final)/dist_vert/sum(precip_inst);
                    end
                    % ESCRITURA DE precip_inst
                    precip_inst = di_precip*precip_inst;
                    % ESCRITURA DE pluvio
                    if (i_inicial - y_margen1)/dist_vert >= rate_i_inic
                        pp_ini = 0;
                    else
                        pp_ini = delta_pp*(y_margen3 - i_inicial)/dist_vert;
                    end
                    pluvio = cumsum(precip_inst) + pp_ini;
                end
                % L�nea digitalizada, como coordenadas en la imagen
                x_linea = I_result(1:end-1,6);
                y_linea = I_result(1:end-1,2);
                % Correcci�n de valores igual a cero en x_linea e y_linea
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
                
                % ESCRITURA DE PRECIPITACI�N ACUMULADA precip_acum
                precip_acum = cumsum(precip_inst);
                % Gr�ficos de Resultados
                % Comparaci�n entre imagen del pluviograma y grafica del
                % pluviograma digitalizado
                figure, subplot(2,1,1), imshow(RGB), hold on, plot(x_linea,y_linea,'r','LineWidth',1), hold off
%                         subplot(2,1,2), plot(time,pluvio),
%                                         datetick('x','dd-mmm-yy HH:MM','keepticks'),
%                                         axis([time_inicial, time_final, -0.1*delta_pp, 1.1*delta_pp])
                        subplot(2,1,2), imshow(imcomplement(BW)), hold on, plot(x_linea,y_linea,'r'), hold off
                        set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8])
                % "Hietograma" (en realidad no es un gr�fico de barras) y
                % precipitaci�n acumulada
                figure, subplot(2,1,1), plot(time,precip_inst),
                                        datetick('x','dd-mmm-yy HH:MM','keepticks'),
                                        axis([time_inicial, time_final, 0, 1.1*max(precip_inst)])
                        subplot(2,1,2), plot(time,precip_acum), grid on,
                                        datetick('x','dd-mmm-yy HH:MM','keepticks'),
                                        axis([time_inicial, time_final, 0, 1.1*precip_acum(end)])
                                        xlabel('Tiempo [dias]')
                                        ylabel('Precipitaci�n [mm]')
                        set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8])
                        
                        % debug
%                         figure, imshow(BW), hold on, plot(I_result(:,6),I_result(:,3:4),'LineWidth',2)
%                         figure, imshow(imcomplement(BW)), hold on,
%                         plot(J_sup, I_sup, 'ro', 'LineWidth', 2), hold on,
%                         plot(J_inf, I_inf, 'ro', 'LineWidth', 2)
                        
                % Mensaje en la ventana de comandos
                disp(['- (4.1) Iniciar Digitalizaci�n                   TERMINADO!        ' datestr(now)])
                                        
            else
                % Ventana de error en caso de no encontrar tantos m�nimos
                % como m�ximos
                figure, imshow(imcomplement(BW)), hold on,
                        plot(J_sup, I_sup, 'ro', 'LineWidth', 2), hold on,
                        plot(J_inf, I_inf, 'ro', 'LineWidth', 2)
                errordlg('El programa no encuentra tantos m�ximos como m�nimos en la imagen.','Error: Extremos no encontrados')
            end
        else
            % VENTANA DE ERROR POR IMAGEN CON M�S DE UN ELEMENTO
            % Calcular todas las propiedades
            [LAB_ext, NUM_ext] = bwlabel(BW);
            PROPS = regionprops(LAB_ext, 'All');

            % Ventana junto a la gr�fica
            menu_ini_dig = menu({ ...
                '(4.1) ERROR: INICIAR DIGITALIZACI�N'
                '_______________________________________'
                ''
                'PARA DIGITALIZAR DEBE HABER UNA SOLA L�NEA CONTINUA,'
                ['SE OBSERVAN ' num2str(NUM_ext) ' SEGMENTOS']
                '_______________________________________'
                ''
                '(Se recomienda unir la l�nea, de forma autom�tica o manual.'
                'Haga click en OK o cierre esta ventana para continuar)'}, ...
                'OK');
            close
        end
    else
        % Cuadro de error en caso de no haber definido fecha y hora, de
        % inicio y t�rmino, de la imagen
        errordlg('Debe definir la informaci�n de fecha y hora (de inicio y t�rmino) de la imagen.','Error: Informaci�n no Definida')
    end
    
elseif ~ exist('x_margen3','var') && ~ exist('x_margen4','var') && exist('RGB','var')
    % Cuadro de error en caso de no haber definido los m�rgenes de registro
    errordlg('Debe definir los m�rgenes de registro antes de unir y eliminar elementos.','Error: M�rgenes no Definidos')
elseif exist('RGB','var') && ~ exist('BW','var') && ~ exist('BW0','var')
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la l�nea antes de unir y eliminar elementos.','Error: Linea no Identificada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de unir y eliminar elementos.','Error: Imagen no encontrada')
end