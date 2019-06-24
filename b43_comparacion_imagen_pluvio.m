if exist('C','var')
    
    figure, subplot(2,1,1), image(RGB(:,j_inicial:j_final,:)),
            subplot(2,1,2), plot(time,pluvio),
                            datetick('x','dd-mmm-yy HH:MM','keepticks'),
                            axis([time_inicial, time_final, -0.1*delta_pp, 1.1*delta_pp])
            set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.8])

else
    errordlg('You must digitize the image before comparing results.','Error: Digitization not found')
end