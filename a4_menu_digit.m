% SUBMEN� DIGITALIZACI�N DE L�NEA

menu_4 = menu({ ...
    '(4) DIGITALIZACI�N DE L�NEA'
    ''
    'Las opciones con (*) son obligatorias'}, ...
    '(4.1) Iniciar Digitalizaci�n (*)',...
    '(4.2) Exportar Resultados (*)', ...
    'Ver Comparaci�n Imagen y Pluviograma', ...
    'Atr�s');

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