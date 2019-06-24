menu_4 = menu({ ...
    '(4) DIGITIZE LINE'
    ''
    'Options marked (*) are mandatory'}, ...
    '(4.1) Start Digitizing (*)',...
    '(4.2) Export Results (*)', ...
    'Compare Image to Original Pluviogram', ...
    'Back');

switch menu_4
    case 1
        run('b41_iniciar_digitalizacion')
        run('a4_menu_digit')
    case 2
        run('b42_exportar_resultados')
        run('a4_menu_digit')
    case 3
        run('b43_comparacion_imagen_pluvio')
        run('a4_menu_digit')
    otherwise
        run('a0_menu_principal')
end