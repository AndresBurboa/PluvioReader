if exist('RGB','var') && exist('fecha_inicio','var') && exist('fecha_termino','var')
    
    if round( datenum(fecha_termino,'dd/mm/yyyy') - datenum(fecha_inicio,'dd/mm/yyyy') ) == 7
        num_div_v = 14;
        pos_first8 = 2;
        pos_last8 = 86;
        mpd_v = round(0.01*cols);
        mpd_h = round(0.08*rows);
    elseif round( datenum(fecha_termino,'dd/mm/yyyy') - datenum(fecha_inicio,'dd/mm/yyyy') ) == 1
        num_div_v = 12;
        pos_first8 = 5;
        pos_last8 = 101;
        mpd_v = round(0.01*cols);
        mpd_h = round(0.08*rows);
    end
    
    RR = double(R);
    GG = double(G);
    BB = double(B);
    
    RGB_min = min(RGB,[],3);
    
    num_umb = 5;
    d_umb = 1;
    umb = (0:num_umb-1)*d_umb + (255 - num_umb + 1);
    
    rate = zeros(size(umb));
    for k = 1:num_umb
        rate(k) = sum(sum(RGB_min <= umb(k)))/(rows*cols);
    end
    slope = abs(diff(rate))/d_umb;
    slope2 = abs(diff(slope))/d_umb;
    
    rate_max = 0.5;
    slope_max = 1e-2;
    slope2_max = 0.5e-3;
    while any(rate > rate_max) || any(slope > slope_max) || any(slope2 > slope2_max)
        umb = umb - d_umb;
        rate(2:end) = rate(1:end-1);
        rate(1) = sum(sum(RGB_min <= umb(1)))/(rows*cols);
        slope(2:end) = slope(1:end-1);
        slope(1) = abs(rate(1) - rate(2))/d_umb;
        slope2(2:end) = slope2(1:end-1);
        slope2(1) = abs(slope(1) - slope(2))/d_umb;
        umb_grid = umb(end-1);
    end
    BW_grid = RGB_min <= umb_grid;
    sum_vert = sum(BW_grid);
    sum_horz = sum(BW_grid,2);
    
    mph_v = mean(sum_vert);
    mph_h = mean(sum_horz);
    [peaks_v, ind_v] = findpeaks(sum_vert,'MinPeakHeight',mph_v,'MinPeakDistance',mpd_v);
    [peaks_h, ind_h] = findpeaks(sum_horz,'MinPeakHeight',mph_h,'MinPeakDistance',mpd_h);
    
    d_umb_edge = 20;
    while ind_v(1) < d_umb_edge
        ind_v(1) = [];
        peaks_v(1) = [];
    end
    while ind_v(end) < d_umb_edge
        ind_v(end) = [];
        peaks_v(end) = [];
    end
    while ind_h(1) < d_umb_edge
        ind_h(1) = [];
        peaks_h(1) = [];
    end
    while ind_h(end) < d_umb_edge
        ind_h(end) = [];
        peaks_h(end) = [];
    end
    
    diff_ind_v = diff(ind_v);
    for n = 1:numel(diff_ind_v)
        if diff_ind_v(n) > 1.5*mean(diff_ind_v)
            ind_v = [ind_v(1:n), round((ind_v(n) + ind_v(n+1))/2), ind_v(n+1:end)];
            peaks_v = [peaks_v(1:n), sum_vert(ind_v(n+1)), peaks_v(n+1:end)];
        end
    end
    diff_ind_h = diff(ind_h);
    for n = 1:numel(diff_ind_h)
        if diff_ind_h(n) > 1.5*mean(diff_ind_h)
            ind_h = [ind_h(1:n), round((ind_h(n) + ind_h(n+1))/2), ind_h(n+1:end)];
            peaks_h = [peaks_h(1:n), sum_horz(ind_h(n+1)), peaks_h(n+1:end)];
        end
    end
    
    xx = [ind_v(pos_first8), ind_v(pos_last8), ind_v(pos_first8), ind_v(pos_last8)];
    yy = [ind_h(1), ind_h(1), ind_h(end), ind_h(end)];
    
    Crit_corr = double(RGB_min);
    Crit_corr(~ BW_grid) = 1e3;
    dx = 10; 
    dy = 20; 
    di1 = 20;       
    dj1 = 1;        
    di2 = 2;        
    dj2 = 20;       
    cruz1 = zeros(2*di1 + 1, 2*dj2 + 1);
    cruz1((-di2:di2) + di1 + 1, :) = 1;
    cruz1(:, (-dj1:dj1) + dj2 + 1) = 1;
    cruz2 = cruz1;
    cruz2(di1 + di2 + 2:end,:) = 0;
    xx_corr = zeros(1,4);
    yy_corr = xx_corr;
    for n = 1:4
        if n == 1 || n == 2
            cruz_grid = cruz1;
        elseif n == 3 || n == 4
            cruz_grid = cruz2;
        end
        min_sum_corr = Inf;
        for i = round(max(yy(n)-dy,dj1+1)):round(min(yy(n)+dy,rows-dj1))
            for j = round(max(xx(n)-dx,dj1+1)):round(min(xx(n)+dx,cols-dj1))
                i1 = (-di1:di1) + i;
                j1 = (-dj2:dj2) + j;
                sum_corr = sum(sum(Crit_corr(i1,j1).*cruz_grid));
                if sum_corr < min_sum_corr
                    xx_corr(n) = j;
                    yy_corr(n) = i;
                    min_sum_corr = sum_corr;
                end
            end
        end
    end
    
    d_umb_p3 = 10;
    dy = 2;
    dij = 25;
    if (xx_corr(1) - xx_corr(3))^2 + (yy_corr(4) - yy_corr(3))^2 > d_umb_p3^2
        x_aux = xx_corr(1);
        y_aux = yy_corr(4);
        min_sum_corr = Inf;
        for i = (-dy:dy) + y_aux
            for j = (-dy:dy) + x_aux
                i0 = (-dy:dy) + i;
                j0 = (-dy:dy) + j;
                i1 = i0 - dij;
                j1 = j0 - dij;
                j2 = j0 + dij;                
                sum_corr = sum(sum(Crit_corr(i1,j0) + Crit_corr(i0,j1) + Crit_corr(i0,j2)));
                if sum_corr < min_sum_corr
                    xx_corr(3) = j;
                    yy_corr(3) = i;
                    min_sum_corr = sum_corr;
                end
            end
        end
    end
    
    warning off all
    figure, imshow(RGB), hold on,
    plot(xx_corr, yy_corr, 'r+', 'LineWidth', 2, 'MarkerSize', 30), hold on,
    plot(xx_corr, yy_corr, 'ro', 'LineWidth', 2, 'MarkerSize', 15)
    set(gcf,'Color','w','units','normalized','Position',[0.05 0.1 0.9 0.7])
    warning on all
    
    menu_marg1 = menu({ ...
        '(1.3) DEFINE IMAGE MARGINS'
        'AUTOMATIC DEFINITION OF MARGINS'
        '________________________'
        ''
        'The software has identified automatically the four corner points'
        'that frame the area of interest for this pluviogram.'
        ''
        'If the four points are indeed located at the intersection of the line'
        'segments that frame the plotting area for this pluviogram, please click'
        ' "Accept".'
        ''
        'Please check each one of the four points. If any of them were not correctly'
        'located, click "Correct Points" in order to'
        'select their location manually.'
        ''
        'If you wish to leave the DEFINE IMAGE MARGINS routine'
        'please click "Cancel".'}, ...
        '        Accept        ', ...
        'Correct Points', ...
        'Cancel');
    
    switch menu_marg1
        case 1
            x_margen1 = xx_corr(1); x_margen2 = xx_corr(2); x_margen3 = xx_corr(3); x_margen4 = xx_corr(4);
            y_margen1 = yy_corr(1); y_margen2 = yy_corr(2); y_margen3 = yy_corr(3); y_margen4 = yy_corr(4);
            x_margen = xx_corr;
            y_margen = yy_corr;
            
            disp(['- (1.3) Define image margins                         COMPLETED!        ' datestr(now)])
            
        case 2
            run('b13_definir_margenes_pt2')
            
        otherwise
            close            
    end
      
elseif ~ (exist('fecha_inicio','var') || exist('fecha_termino','var'))
    errordlg('You must input the Start and End Date and Time for this image.','Error: Missing Information','Error: Información no Definida')
else
    errordlg('You must select an image before defining margins.','Error: Image not found')
end