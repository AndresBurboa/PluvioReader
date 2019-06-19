% (3.2) UNIR Y ELIMIAR ELEMENTOS AUTOMÁTICAMENTE BW

if (exist('BW','var') || exist('BW0','var')) && (exist('BW0','var') && numel(size(BW0)) == 2) ...
        && exist('x_margen','var')
    
    tic
    % Redefinir BW (solo para quitar sugerencia de prealojar la imagen)
    BW = BW0;
    
    % Etiquetar imagen
    [LAB, ~] = bwlabel(BW);
    
    % Definir márgenes representativos
    x_margen13 = min(x_margen1,x_margen3);
    x_margen24 = max(x_margen2,x_margen4);
    y_margen12 = min(y_margen1,y_margen2);
    y_margen34 = max(y_margen3,y_margen4);
    
    % ELIMINAR ELEMENTOS EN BORDES (SUPERIOR E INFERIOR) DE IMAGEN (1)
    lab_edge = unique(nonzeros([LAB(1,:), LAB(rows,:)]));
    BW(ismember(LAB, lab_edge)) = 0;

    % ELIMINAR ELEMENTOS FUERA DE LA EXTENSIÓN ÚTIL (IZQUIERDA Y DERECHA)
    % DE LA IMAGEN (2)
    for i = 1:rows
        j_izq0 = x_margen13 - 1;
        j_der0 = x_margen24 + 1;
        while j_izq0 > 1 && BW(i,j_izq0)
            j_izq0 = j_izq0 - 1;
        end
        while j_der0 < cols && BW(i,j_der0)
            j_der0 = j_der0 + 1;
        end
        BW(i,1:max(1,j_izq0)) = 0;
        BW(i,min(cols,j_der0):cols) = 0;
    end
    
    % ELIMINAR ELEMENTOS DE LA LÍNEA VERTICAL QUE SE ENCUENTRA (A VECES) AL
    % INICIO DEL PLUVIOGRAMA (3)
    [LAB, ~] = bwlabel(BW);
    PROPS = regionprops(LAB,'BoundingBox','Eccentricity','Orientation');
    dj_borrar0 = 50;
    ecc_umb = 0.98;
    orient_umb = 88;
    lab_edge = unique(nonzeros(LAB(:,x_margen13:x_margen13+dj_borrar0)));
    for n = lab_edge'
        if PROPS(n).BoundingBox(2) + PROPS(n).BoundingBox(4) < 0.98*y_margen34
            if PROPS(n).Eccentricity > ecc_umb && abs(PROPS(n).Orientation) > orient_umb
                BW(LAB == n) = 0;
            end
        end
    end
    
    % ETIQUETAR IMAGEN Y OBTENER INDICES EXTREMOS DE CADA ELEMENTO (I,J)
    [LAB, NUM] = bwlabel(BW);
    PROPS = regionprops(LAB, 'Extrema');
    I = zeros(8*NUM,1);
    J = I;
    m2 = 0;
    for n = 1:NUM
        m1 = m2 + 1;
        m2 = m2 + 8;
        I(m1:m2) = [ceil(PROPS(n).Extrema(1,2)); ceil(PROPS(n).Extrema(2,2)); ...
            ceil(PROPS(n).Extrema(3,2)); floor(PROPS(n).Extrema(4,2)); ...
            floor(PROPS(n).Extrema(5,2)); floor(PROPS(n).Extrema(6,2)); ...
            floor(PROPS(n).Extrema(7,2)); ceil(PROPS(n).Extrema(8,2))];
        J(m1:m2) = [ceil(PROPS(n).Extrema(1,1)); floor(PROPS(n).Extrema(2,1)); ...
            floor(PROPS(n).Extrema(3,1)); floor(PROPS(n).Extrema(4,1)); ...
            floor(PROPS(n).Extrema(5,1)); ceil(PROPS(n).Extrema(6,1)); ...
            ceil(PROPS(n).Extrema(7,1)); ceil(PROPS(n).Extrema(8,1))];
    end
    % Eliminar índices extremos que estén repetidos
    IJ = [I, J];
    IJ = unique(IJ,'rows');
    I = IJ(:,1);     J = IJ(:,2);
    
    % DEFINIR MÁRGENES SUPERIOR E INFERIOR QUE DELIMITAN A LA LÍNEA,
    % distintos a los márgenes de la grilla
    sum_pix_horz = sum(BW,2);
    i_sup = round(rows/2);
    i_inf = i_sup;
    di_sup_inf = 5;
    sum_horz_max = 500;
    while i_sup - di_sup_inf >= 1 && ~ all(sum_pix_horz(i_sup-di_sup_inf:i_sup) == 0)
        i_sup = i_sup - 1;
    end
    while i_inf + di_sup_inf <= rows && ~ all(sum_pix_horz(i_inf:i_inf+di_sup_inf) == 0)
        i_inf = i_inf + 1;
    end
%     if abs(i_sup - y_margen12) > abs(i_sup - (y_margen34 - y_margen12)/2) || any(sum_pix_horz(y_margen12:i_sup) > sum_horz_max) || i_sup == 5
%         i_sup = round((y_margen12 - 0.25*(y_margen12 - 1)));
%     end
%     if abs(i_inf - y_margen34) > abs(i_inf - (y_margen34 - y_margen12)/2) || any(sum_pix_horz(i_inf:y_margen34) > sum_horz_max) || i_inf == rows - 5;
%         i_inf = round((y_margen34 + 0.5*(rows - y_margen34)));
%     end
        
    % DEFINIR ETIQUETA DE PRIMER Y ÚLTIMO ELEMENTO DE LÍNEA (según criterio
    % de etiqueta con mayor área)
    area_umb = 2;
    % Versión sparse de LAB
    LAB_sparse = sparse(LAB);
    % Primer elemento
    dx_buscar_area_inicial = 20;
    num_inicial = unique(nonzeros(LAB(i_sup:i_inf,x_margen13:x_margen13 + dx_buscar_area_inicial)));
    area_inicial = area_umb;
    for n = num_inicial'
        if full(nnz(LAB_sparse == n)) > area_inicial
            NUM_inicial = n;
            area_inicial = nnz(LAB == n);
        end
    end
    % Último elemento
    dx_buscar_area_final = 25;
    num_final = unique(nonzeros(LAB(i_sup:i_inf,x_margen24 - dx_buscar_area_final:x_margen24)));
    area_final = area_umb;
    for n = num_final'
        if full(nnz(LAB_sparse == n)) > area_final
            NUM_final = n;
            area_final = nnz(LAB == n);
        end
    end
    % En caso de no haber encontrado el primer o últmo elemento
    if isempty(num_inicial) || area_inicial <= area_umb
        j = x_margen13 + dx_buscar_area_inicial;
        while ~ any(BW(i_sup:i_inf,j)) || area_inicial <= area_umb
            j = j + 1;
            if any(BW(i_sup:i_inf,j))
                num_inicial = unique(nonzeros(LAB(i_sup:i_inf,j)));
                area_inicial = area_umb;
                for n = num_inicial'
                    if nnz(LAB == n) > area_inicial
                        NUM_inicial = n;
                        area_inicial = nnz(LAB == n);
                    end
                end
            end
        end
    end
    if isempty(num_final) || area_final <= area_umb
        j = x_margen24 - dx_buscar_area_final;
        while ~ any(BW(i_sup:i_inf,j)) || area_final <= area_umb
            j = j - 1;
            if any(BW(i_sup:i_inf,j))
                num_final = unique(nonzeros(LAB(i_sup:i_inf,j)));
                area_final = area_umb;
                for n = num_final'
                    if nnz(LAB == n) > area_final
                        NUM_final = n;
                        area_final = nnz(LAB == n);
                    end
                end
            end
        end
    end
    
    % DEFINIR ÍNDICE INICIAL Y FINAL (CORRESPONDIENTES AL PRIMER Y ÚLTIMO
    % ELEMENTO)
    i_inicial = 1;
    j_inicial = 1;
    while ~ any(LAB(:,j_inicial) == NUM_inicial)
        j_inicial = j_inicial + 1;
    end
    while LAB(i_inicial,j_inicial) ~= NUM_inicial
        i_inicial = i_inicial + 1;
    end
    i_final = 1;
    j_final = cols;
    while ~ any(LAB(:,j_final) == NUM_final)
        j_final = j_final - 1;
    end
    while LAB(i_final,j_final) ~= NUM_final
        i_final = i_final + 1;
    end
    
    % DEFINIR MÁRGENES IZQUIERDO Y DERECHO, DONDE SE UNIRÁN ELEMENTOS
    j_izq = j_inicial;
    j_der = j_final;
    while any(LAB(:,j_izq) == NUM_inicial)
        j_izq = j_izq + 1;
    end
    j_izq = j_izq - 1;
    while any(LAB(:,j_der) == NUM_final)
        j_der = j_der - 1;
    end
    j_der = j_der + 1;
    % Distancia de resguardo para no borrar elementos en exceso
    dj_izq = 15;
    dj_der = 15;
    j_izq = max(j_izq - dj_izq,j_inicial);
    j_der = min(j_der + dj_der,j_final);
    
    % Eliminar índices fuera de los márgenes izquierdo y derecho
    I((J < j_izq) | (J > j_der)) = [];
    J((J < j_izq) | (J > j_der)) = [];
    % Eliminar índices fuera de los márgenes superior e inferior
    J((I > i_inf) | (I < i_sup)) = [];
    I((I > i_inf) | (I < i_sup)) = [];
    
    % UNIR ELEMENTOS DE MANERA HORIZONTAL, VERTICAL U OBLICUA (parte 1;
    % separados solo por 1 pixel)
    for k = 1:length(I)
        i = I(k);
        j = J(k);
        cambios = 0;
        if i + 2 <= rows && j + 2 <= cols ...
                && i - 2 >= 1 && j - 2 >= 1
            if any(BW(i-1:i+1,j+2)) && all(LAB(i,j) ~= LAB(i-1:i+1,j+2))
                BW(i,j+1) = 1;
                LAB(i-1:i+1,j+2) = LAB(i,j);
                cambios = 1;
            elseif any(BW(i-2,j:j+1)) && all(LAB(i,j) ~= LAB(i-2,j:j+1))
                BW(i-1,j) = 1;
                LAB(i-2,j:j+1) = LAB(i,j);
                cambios = 1;
            elseif any(BW(i+2,j:j+1)) && all(LAB(i,j) ~= LAB(i+2,j:j+1))
                BW(i+1,j) = 1;
                LAB(i+2,j:j+1) = LAB(i,j);
                cambios = 1;
            end
        end
    end
    % Actualizar etiquetas
    [LAB, ~] = bwlabel(BW);
    
    % - UNIR ELEMENTOS DE MANERA HORIZONTAL, VERTICAL U OBLICUA (parte 2) -
    % (separados por 2 o más pixeles)
    
    % Distancia de partida, distancia de aumento y distancia máxima en que
    % se unirán elementos
    dist_ij = 2;
    delta_dist = 1;
    dist_ij_max = 1/3*(y_margen34 - y_margen12);
    % Variables de restricción de unión horizontal entre elementos
    % verticales
    sum_vert_max = 0.2*rows;
    dj_sum_vert = 5;
    % Variable para permitir uniones oblicuas
    sum_vert_min = 0.1*rows;
    % Variables para definir vecindades a los índices cuando se une y
    % elimina elementos
    di_unir_v = 5;
    dj_unir_v = 5;
    dj_unir_h = 15;
    di_borrar_v = 15;
    dj_borrar_h = dj_unir_h;
    dj_borrar_h2 = 50;
    
    % Suma vertical de pixeles
    sum_pix_vert = sum(BW(i_sup:i_inf,:));
    % Ángulo umbral para uniones oblicuas cercanas a 90°
    theta_umb = 80/180*pi;
    % Valores iniciales para lis índices izq y der
    i_izq = i_inicial;  j_izq = j_inicial;
    i_der = i_final;    j_der = j_final;
    % Variables inferior y superior para permitir ciertas uniones oblícuas
    % en los extremos
    di_sup = 20;
    di_inf = 50;
    
    while dist_ij <= dist_ij_max && j_izq < j_der - 1
        % Variables para la eliminación de índices que no deben unirse
        ind_IJ = 1:length(I);   ind_IJ = ind_IJ';
        borrar_IJ = zeros(length(I),1);
        cont_b = 1;
        unir_linea = 1;
        for k = 1:length(I)
            cambios = 0;
            i = I(k);
            j = J(k);
            if ~ any(LAB(i,j) == LAB(:,j + dj_unir_h)) ...
                && i + di_unir_v <= rows ...
                && j + dj_unir_h <= cols && j + dj_unir_v <= cols %...
                %&& any( LAB(sub2ind(size(BW),I,J)) ~= LAB(i,j) )%& (I - i).^2 + (J - j).^2 <= (dist_ij + 1).^2 )
                % Índices ij de unión
                % Unión vertical y semi vertical hacia arriba
                i2 = i-dist_ij-1;
                j2 = j;
                i21 = i-dist_ij-1;
                j21 = j+1;
                % Unión semi horizontal hacia arriba, horizontal y semi
                % horizontal hacia abajo
                i31 = i-1;
                j31 = j+dist_ij+1;
                i3 = i;
                j3 = j+dist_ij+1;
                i32 = i+1;
                j32 = j+dist_ij+1;
                % Unión semi vertical y vertical hacia abajo
                i41 = i+dist_ij+1;
                j41 = j+1;
                i4 = i+dist_ij+1;
                j4 = j;
                % UNIÓN VERTICAL hacia arriba
                if i2 >= i_sup && BW(i2, j2) && LAB(i, j) ~= LAB(i2, j2) && ~ all(BW(i2+1:i-1, j)) ...
                        && ~ any(LAB(i2, j2) == LAB(i2 + di_unir_v, j2:j2+dj_unir_v)) %...
%                         && all(LAB(i2,j2) ~= LAB(i+di_unir2,j-dj_unir2:j+dj_unir2)) ...
%                         && all(LAB(i,j) ~= LAB(i2-di_unir2,j2-dj_unir2:j2+dj_unir2))
                    BW(i2+1:i-1,j2) = 1;
                    cambios = 1;
                % UNIÓN SEMI VERTICAL hacia arriba
                elseif i21 >= i_sup && BW(i21,j21) && LAB(i,j) ~= LAB(i21,j21) && ~ all(BW(i21+1:i-1,j21)) ...
                        && ~ any(LAB(i21, j21) == LAB(i21 + di_unir_v, j21:j21+dj_unir_v))
                    BW(i21+1:i-1,j21) = 1;
                    cambios = 1;
                % UNIÓN SEMI HORIZONTAL hacia arriba
                elseif j31 <= j_der && BW(i31,j31) && LAB(i,j) ~= LAB(i31,j31) && ~ all(BW(i,j+1:j31-1)) ...
                        && ~ any(LAB(i31,j31) == LAB(:,j31 - dj_unir_h)) ...
                        && all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ...
                        && all(sum_pix_vert(j31-dj_sum_vert:j31+dj_sum_vert) < sum_vert_max) %...
%                         && ~ any(LAB(i,j) == LAB(i-di_unir,j-dj_unir:j+dj_unir)) && ~ any(LAB(i,j) == LAB(i+di_unir,j-dj_unir:j+dj_unir)) ...
%                         && ~ any(LAB(i31,j31) == LAB(i31-di_unir,j31-dj_unir:j31+dj_unir)) && ~ any(LAB(i31,j31) == LAB(i31+di_unir,j31-dj_unir:j31+dj_unir))
                    BW(i,j+1:j31-1) = 1;
                    cambios = 1;
                % UNIÓN HORIZONTAL
                elseif j3 <= j_der && BW(i3,j3) && LAB(i,j) ~= LAB(i3,j3) && ~ all(BW(i,j+1:j3-1)) ...
                        && ~ any(LAB(i3,j3) == LAB(:,j3 - dj_unir_h)) ...
                        && all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ...
                        && all(sum_pix_vert(j3-dj_sum_vert:j3+dj_sum_vert) < sum_vert_max)% || i <= i_min_unir_h ) ...
%                         && ~ any(LAB(i,j) == LAB(i-di_unir,j-dj_unir:j+dj_unir)) && ~ any(LAB(i,j) == LAB(i+di_unir,j-dj_unir:j+dj_unir)) ...
%                         && ~ any(LAB(i3,j3) == LAB(i3-di_unir,j3-dj_unir:j3+dj_unir)) && ~ any(LAB(i3,j3) == LAB(i3+di_unir,j3-dj_unir:j3+dj_unir))
                    BW(i,j+1:j3-1) = 1;
                    cambios = 1;
                % UNIÓN SEMI HORIZONTAL hacia abajo
                elseif j32 <= j_der && BW(i32,j32) && LAB(i,j) ~= LAB(i32,j32) && ~ all(BW(i,j+1:j32-1)) ...
                        && ~ any(LAB(i32,j32) == LAB(:,j32 - dj_unir_h)) ...
                        && all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ...
                        && all(sum_pix_vert(j32-dj_sum_vert:j32+dj_sum_vert) < sum_vert_max) %...
%                         && ~ any(LAB(i,j) == LAB(i-di_unir,j-dj_unir:j+dj_unir)) && ~ any(LAB(i,j) == LAB(i+di_unir,j-dj_unir:j+dj_unir)) ...
%                         && ~ any(LAB(i32,j32) == LAB(i32-di_unir,j32-dj_unir:j32+dj_unir)) && ~ any(LAB(i32,j32) == LAB(i32+di_unir,j32-dj_unir:j32+dj_unir)) ...
                    BW(i,j+1:j32-1) = 1;
                    cambios = 1;
                % UNIÓN SEMI VERTICAL hacia abajo
                elseif i41 <= i_inf && BW(i41,j41) && LAB(i,j) ~= LAB(i41,j41) && ~ all(BW(i+1:i41-1,j)) ...
                        && ~ any(LAB(i41,j41) == LAB(i41 - di_unir_v,:))
                    BW(i+1:i41-1,j) = 1;
                    cambios = 1;
                % UNIÓN VERTICAL hacia abajo
                elseif i4 <= i_inf && BW(i4, j4) && LAB(i, j) ~= LAB(i4, j4) && ~ all(BW(i+1:i4-1, j)) ...
                        && ( ~ any(LAB(i4, j4) == LAB(i4-di_unir_v, j4:j4+dj_unir_v)) || i4 + di_inf > i_inf )%...
%                         && all(LAB(i,j) ~= LAB(i4+di_unir2,j4-dj_unir2:j4+dj_unir2)) ...
%                         && all(LAB(i4,j4) ~= LAB(i-di_unir2,j-dj_unir2:j+dj_unir2))
                    BW(i+1:i4-1,j4) = 1;
                    cambios = 1;
                % UNIÓN OBLICUA
                elseif  i - di_unir_v >= 1 && i + di_unir_v <= rows ...
                        && ~ any(LAB(i,j) == LAB(i-di_unir_v:i+di_unir_v,j+1)) %|| i >= i_max_unir
                    % UNIÓN ENTRE -45° y 45°
                    unir_linea = 1;
                    for i5 = [i-round(dist_ij/sqrt(2))-1:i-2 i+2:i+round(dist_ij/sqrt(2))+1]
                        theta = asin((i5 - i)/(dist_ij + 1));
                        j5 = round(j + (dist_ij + 1)*cos(theta));
                        if i5 <= i_inf && i5 >= i_sup && i ~= i5 && j ~= j5 && j5 <= cols && abs(theta) <= pi/4 ...
                                && BW(i5,j5) && LAB(i,j) ~= LAB(i5,j5) ...
                                && ~ any(LAB(i5,j5) == LAB(:,j5 - dj_unir_h)) ...
                                && ( all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ) ...
                                && ( (i < i_sup + di_sup && theta < 0) || all(sum_pix_vert(j5-dj_sum_vert:j5+dj_sum_vert) < sum_vert_max) )
                            y1 = i;
                            x1 = j;
                            y2 = i5;
                            x2 = j5;
                            x = x1+1:x2-1;
                            y = round((y2 - y1)/(x2 - x1)*(x - x1) + y1);
                            for m = 1:length(x)
                                if LAB(y(m),x(m)) ~= LAB(y1,x1) && LAB(y(m),x(m)) ~= LAB(y2,x2) && LAB(y(m),x(m)) ~= 0
                                    unir_linea = 0;
                                    break
                                end
                            end
                            if unir_linea == 1
                                for m = 1:length(x)
                                    BW(y(m),x(m)) = 1;
                                end
                                cambios = 1;
                                break
                            end
                        end
                    end
                    % UNIÓN ENTRE 45° y 90° (y entre -45° y -90°)
                    unir_linea = 1;
                    for j5 = j+2:j+round(dist_ij/sqrt(2))+1
                        theta = acos((j5 - j)/(dist_ij + 1));
                        i51 = round(i - (dist_ij + 1)*sin(theta));
                        i52 = round(i + (dist_ij + 1)*sin(theta));
                        % Parte 1, entre 45° y 90°
                        if i51 >= i_sup && i ~= i51 && j ~= j5 && j5 <= cols && abs(theta) >= pi/4 ...
                                && BW(i51, j5) && LAB(i, j) ~= LAB(i51, j5) ...
                                && ( ~ any(LAB(i51, j5) == LAB(i+di_unir_v, j:j5+dj_unir_v)) || any(sum_pix_vert(j5-dj_sum_vert:j5+dj_sum_vert) > sum_vert_min) ) ...
                                && ~ any(LAB(i51, j5) == LAB(:, j5-dj_unir_h)) ...
                                && ( all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ...
                                || ( theta >= theta_umb || all(sum_pix_vert(j-dj_sum_vert:j5+dj_sum_vert) < sum_vert_max) ) )
                            y1 = i;
                            x1 = j;
                            y2 = i51;
                            x2 = j5;
                            y = y2+1:y1;
                            x = round((y - y1)*(x2 - x1)/(y2 - y1) + x1);
                            
%                             if j == 3008 && length(x) > 50
%                                 [i j i51 j5]
%                                 j+2:j+round(dist_ij/sqrt(2))+1
%                                 x
%                                 y
%                             end
                            
                            for m = 1:length(y)
                                if LAB(y(m),x(m)) ~= LAB(y1,x1) && LAB(y(m),x(m)) ~= LAB(y2,x2) && LAB(y(m),x(m)) ~= 0
                                    unir_linea = 0;
                                    break
                                end
                            end
                            if unir_linea == 1
                                for m = 1:length(y)
                                    BW(y(m),x(m)) = 1;
                                end
                                cambios = 1;
                                break
                            end
                        % Parte 2, entre -45° y -90°
                        elseif i52 <= i_inf && i ~= i52 && j ~= j5 && j5 <= cols && abs(theta) >= pi/4 ...
                                && BW(i52,j5) && LAB(i,j) ~= LAB(i52,j5) ...
                                && ~ any(LAB(i,j) == LAB(i + di_unir_v,:)) ...
                                && ~ any(LAB(i52,j5) == LAB(i52 - di_unir_v,:)) ...
                                && ~ any(LAB(i52,j5) == LAB(:,j5 - dj_unir_h)) ...
                                && ( all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ...
                                || ( theta >= theta_umb || all(sum_pix_vert(j-dj_sum_vert:j5+dj_sum_vert) < sum_vert_max) ) )
%                                 && ( theta >= theta_umb || all(sum_pix_vert(j-dj_sum_vert:j+dj_sum_vert) < sum_vert_max) ) ...
%                                 && ( theta >= theta_umb || all(sum_pix_vert(j5-dj_sum_vert:j5+dj_sum_vert) < sum_vert_max) )
                            y1 = i;
                            x1 = j;
                            y2 = i52;
                            x2 = j5;
                            y = y1+1:y2-1;
                            x = round((y - y1)*(x2 - x1)/(y2 - y1) + x1);
                            for m = 1:length(y)
                                if LAB(y(m),x(m)) ~= LAB(y1,x1) && LAB(y(m),x(m)) ~= LAB(y2,x2) && LAB(y(m),x(m)) ~= 0
                                    unir_linea = 0;
                                    break
                                end
                            end
                            if unir_linea == 1
                                for m = 1:length(y)
                                    BW(y(m),x(m)) = 1;
                                end
                                cambios = 1;
                                break
                            end
                        end
                    end
                end
            end
            % Borrar índices intermedios en un mismo elemento, en el eje
            % horizontal
            if any(LAB(i,j) == LAB(:,j + dj_borrar_h)) && any(LAB(i,j) == LAB(:,j - dj_borrar_h))
                borrar_IJ = borrar_IJ | ((I == i) & (J == j));
            end
            % Borrar índices intermedios en un mismo elemento, en el eje
            % vertical
            if i + di_borrar_v <= rows && i - di_borrar_v >= 1 ...
                    && any(LAB(i,j) == LAB(i + di_borrar_v,j-dj_unir_v:j+dj_unir_v)) ...
                    && any(LAB(i,j) == LAB(i - di_borrar_v,j-dj_unir_v:j+dj_unir_v)) ...
                    && i_inf < i + 50
                borrar_IJ = borrar_IJ | ((I == i) & (J == j));
            end
            % Borrar índices intermedios a otros elementos, en el eje
            % horizontal
            if cambios == 0 && j - dj_borrar_h2 >= 1 && j + dj_borrar_h2 <= cols
                lab1 = nonzeros(LAB(i_sup:i_inf,j - dj_borrar_h2));
                lab2 = nonzeros(LAB(i_sup:i_inf,j + dj_borrar_h2));
                if any( ismember(lab1, lab2) )
                    borrar_IJ = borrar_IJ | ((I == i) & (J == j));
                end
            end
            % Borrar índices oblicuos utilizados al unir (o que era
            % posible utilizar pero cruzaron otra línea)
            if cambios == 1 || unir_linea == 0
                borrar_aux = (I == i) & (J == j);
                ind_no = ind_IJ(borrar_aux);    ind_no = ind_no(end);
                borrar_aux(ind_no) = 0;
                borrar_IJ = borrar_IJ | borrar_aux;
            end
        end
        
        % Actualizar distancia y etiquetas
        dist_ij = dist_ij + delta_dist;
%         [LAB, ~] = bwlabel(BW);
%         LAB_sparse = sparse(LAB);
        CC = bwconncomp(BW);
        LAB = labelmatrix(CC);
        
        % Actualizar etiquetas izquierda y derecha
        NUM_izq = LAB(i_izq,j_izq);
        NUM_der = LAB(i_der,j_der);
        
        % Actualizar j_izq y j_der
        while j_izq > 1 && j_izq < cols && any(LAB(:,j_izq) == NUM_izq)
            j_izq = j_izq + 1;
        end
        j_izq = j_izq - 1;
        i_izq = rows;
        while LAB(i_izq,j_izq) ~= NUM_izq %|| LAB(i_izq,j_izq) == 0
            i_izq = i_izq - 1;
        end
        while j_der > 1 && j_der < cols && any(LAB(:,j_der) == NUM_der)
            j_der = j_der - 1;
        end
        j_der = j_der + 1;
        i_der = 1;
        while LAB(i_der,j_der) ~= NUM_der %|| LAB(i_der,j_der) == 0
            i_der = i_der + 1;
        end
        
        % Avanzar j_izq incluso cuando hay una bajada de 10 a 0 mm, que no
        % esté unida por una línea vertical, pero esté superpuesta en las
        % columnas
        a = 0;
        area_min = i_inf - i_sup;
        area_izq2 = area_min + 1;
        area_der2 = area_izq2;
        lab_izq = unique(nonzeros(LAB(i_sup:i_inf,j_izq)));
        while numel(lab_izq) == 2 && area_izq2 > area_min %|| sum(sum(ismember(LAB, lab_izq))) < area_min
            % Valor de la otra etiqueta y actualización de area_izq2
            if lab_izq(1) == NUM_izq
                num_izq2 = lab_izq(2);
            else
                num_izq2 = lab_izq(1);
            end
            a = a + 1;
            area_izq2 = nnz(LAB == num_izq2);
%             area_izq2 = full(nnz(LAB_sparse == num_izq2));
            if area_izq2 > area_min
                % Búsqueda de elemento más a la derecha de j_izq
                while any(LAB(:,j_izq) == num_izq2)
                    j_izq = j_izq + 1;
                end
                j_izq = j_izq - 1;
                i_izq = rows;
                while LAB(i_izq,j_izq) ~= num_izq2
                    i_izq = i_izq - 1;
                end
                % Actualización de NUM_izq y lab_izq
                NUM_izq = LAB(i_izq,j_izq);
                lab_izq = unique(nonzeros(LAB(i_sup:i_inf,j_izq)));
            end
        end
        
        % Avanzar j_der para el caso análogo al anterior
        lab_der = unique(nonzeros(LAB(i_sup:i_inf,j_der)));
        while numel(lab_der) == 2 && area_der2 > area_min
            % Valor de la otra etiqueta y actualización de j_izq2
            if lab_der(1) == NUM_der
                num_der2 = lab_der(2);
            else
                num_der2 = lab_der(1);
            end
            area_der2 = nnz(LAB == num_der2);
%             area_der2 = full(nnz(LAB_sparse == num_der2));
            if area_der2 > area_min
                % Búsqueda de elemento más a la izquierda de j_der
                while any(LAB(:,j_der) == num_der2)
                    j_der = j_der - 1;
                end
                j_der = j_der + 1;
                i_der = 1;
                while LAB(i_der,j_der) ~= num_der2
                    i_der = i_der + 1;
                end
                % Actualización de NUM_der y lab_der
                NUM_der = LAB(i_der,j_der);
                lab_der = unique(nonzeros(LAB(i_sup:i_inf,j_der)));
            end
        end
        
        % Actualizar etiquetas izquierda y derecha (2)
        NUM_izq = LAB(i_izq,j_izq);
        NUM_der = LAB(i_der,j_der);
        
        % Distancia de resguardo del margen
        if j_izq < j_der - 1
            % Margen izquierdo
            j_izq = j_izq - dj_izq;
            while all(LAB(:,j_izq) ~= NUM_izq)
                j_izq = j_izq + 1;
            end
            i_izq = rows;
            while LAB(i_izq,j_izq) ~= NUM_izq
                i_izq = i_izq - 1;
            end
            % Margen derecho
            j_der = j_der + dj_der;
            while all(LAB(:,j_der) ~= NUM_der)
                j_der = j_der - 1;
            end
            i_der = 1;
            while LAB(i_der,j_der) ~= NUM_der
                i_der = i_der + 1;
            end
        end

        % Eliminar índices intermedios a elementos
%         borrar_IJ(borrar_IJ == 0) = [];
        I(logical(borrar_IJ)) = [];
        J(logical(borrar_IJ)) = [];

        % Eliminar índices a la izquierda y derecha
        I((J < j_izq | J > j_der)) = [];
        J((J < j_izq | J > j_der)) = [];
        
        % Actualizar sum_pix_vert
        sum_pix_vert = sum(BW(i_sup:i_inf,:));
    end
    toc
    
    % Definir variable para indicar que se puede digitalizar la imagen
    digitalizar = 0;
    if j_izq >= j_der - 1
        digitalizar = 1;
    end
    
    % ---------- REDIBUJAR LÍNEA ----------
    % Etiquetas iniciales
    [LAB0, ~] = bwlabel(BW);
    % Eliminar segmentos que no sean suficientemente grandes
    area_umb = round(1.2*(i_inf - i_sup));
    BW = bwareaopen(BW,area_umb);
    % Eliminar elementos que esten completamente fuera del margen superior
    % o inferior
    [LAB, NUM] = bwlabel(BW);
    PROPS = regionprops(LAB, 'BoundingBox');
    for n = 1:NUM
        if PROPS(n).BoundingBox(2) + PROPS(n).BoundingBox(4) < i_sup
            BW(LAB == n) = 0;
        elseif PROPS(n).BoundingBox(2) > i_inf
            BW(LAB == n) = 0;
        end
    end
    % Eliminar elementos que se encuentren en una posición intermedia a
    % otros elementos más grandes (que están alineados en una misma
    % columna)
    [LAB, NUM] = bwlabel(BW);
    PROPS = regionprops(LAB, 'BoundingBox');
    LAB_sparse = sparse(LAB);
    for n = 1:NUM
        lab1 = unique(nonzeros(LAB(:,floor(PROPS(n).BoundingBox(1)))));
        lab2 = unique(nonzeros(LAB(:,ceil(PROPS(n).BoundingBox(1) + PROPS(n).BoundingBox(3)))));
        kk = 1;
        while kk <= length(lab1)
            if any(lab1(kk) == lab2)
                BW(LAB_sparse == n) = 0;
                break
            end
            kk = kk + 1;
        end
    end    
    % Incluir segmentos del inicio y final (en caso de haberlos borrado)
    [LAB, ~] = bwlabel(BW);
    if LAB(i_inicial,j_inicial) == LAB(i_final,j_final) ...
            && LAB(i_inicial,j_inicial) ~= 0
        BW = LAB == LAB(i_final,j_final);
    else
        if LAB0(i_inicial,j_inicial) == 0
            BW = BW | LAB0 == LAB0(i_final,j_final);
        elseif LAB0(i_final,j_final) == 0
            BW = BW | LAB0 == LAB0(i_inicial,j_inicial);
        else
            BW = BW | LAB0 == LAB0(i_inicial,j_inicial) | LAB0 == LAB0(i_final,j_final);
        end
    end
    % ---------- FIN REDIBUJAR LÍNEA ----------
    
    % Calcular todas las propiedades (solo con fines de depurar errores,
    % otros casos es necesario el BoundingBox)
    [LAB, NUM] = bwlabel(BW);
    PROPS = regionprops(LAB, 'BoundingBox', 'Centroid');
    
    % Gráfica de los elementos unidos
    warning off all
    figure, imshow(imcomplement(BW)),
    for n = 1:NUM
        rectangle('Position',[PROPS(n).BoundingBox(1),PROPS(n).BoundingBox(2),PROPS(n).BoundingBox(3),PROPS(n).BoundingBox(4)], ...
            'EdgeColor','b','LineWidth',2,'LineStyle','--'),
        text(PROPS(n).Centroid(1),PROPS(n).Centroid(2),num2str(n), ...
            'HorizontalAlignment','Center','FontWeight','bold','FontSize',12,'Color','b')
        hold on
    end
    if j_izq < j_der - 1
        rectangle('Position',[j_izq, i_sup, j_der-j_izq, i_inf-i_sup], ...
            'EdgeColor','r','LineWidth',2,'LineStyle','--'),
    end
    set(gcf,'Name','Vista Previa de elementos de línea unidos automáticamente','NumberTitle','off')
    warning on all
    
    % Ventana junto a la gráfica
    if NUM == 1 || digitalizar
        uiwait(msgbox({'OPERACIÓN COMPLETADA. LA LÍNEA PUEDE SER DIGITALIZADA'
            ''
            'La línea en la imagen es única, o sus segmentos no presentan columnas vacías.'
            '_______________________________________________________'
            ''
            'Se recomienda revisar posibles errores en la unión de la línea.'
            ''
            'Haga click en OK o cierre esta ventana para continuar'}, ...
            '(3.2) UNIR Y ELIMINAR ELEMENTOS (AUTOMÁTICO)', 'help'));
    else
        uiwait(msgbox({'OPERACIÓN COMPLETADA. LA LÍNEA NO PUEDE SER DIGITALIZADA'
            ''
            'Los segmentos de línea en la imagen presentan columnas vacías.'
            '_______________________________________________________'
            ''
            'Si la línea se unió de forma incorrecta no guarde cambios, una la parte incorrecta de forma manual y vuelva a realizar la unión automática.'
            ''
            'Haga click en OK o cierre esta ventana para continuar'}, ...
            '(3.2) UNIR Y ELIMINAR ELEMENTOS (AUTOMÁTICO)', 'error'));
    end
    close
    
    % Comparación antes y después de la imagen. Guardar Cambios, junto con
    % versión anterior de la imagen
    run('c2_guardar_cambios_bw')

    if menu_guardar == 1
        % Mensaje en la ventana de comandos
        disp(['- (3.2) Unir y Eliminar elementos (auto)         TERMINADO!        ' datestr(now)])
    end
    
elseif ( ~ exist('x_margen3','var') || ~ exist('x_margen4','var') ) && exist('RGB','var')
    % Cuadro de error en caso de no haber definido los márgenes de registro
    errordlg('Debe definir los márgenes de registro antes de unir y eliminar elementos.','Error: Márgenes no Definidos')
elseif exist('RGB','var') && ((~ exist('BW','var') && ~ exist('BW0','var')) || (exist('BW0','var') && numel(size(BW0)) ~= 2))
    % Cuadro de error en caso de no haber reconocido la linea
    errordlg('Debe identificar la línea antes de unir y eliminar elementos.','Error: Linea no Identificada')
else
    % Cuadro de error en caso de no haber seleccionado la imagen
    errordlg('Debe seleccionar una imagen antes de unir y eliminar elementos.','Error: Imagen no encontrada')
end