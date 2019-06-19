% MENÚ PRINCIPAL PROGRAMA PLUVIOREADER

close all force

menu_0 = menu({ ...
    'PLUVIOREADER: UN PROGRAMA AUTOMÁTICO PARA'
    'LA DIGITALIZACIÓN DE PLUVIOGRAMAS'
    ''
    'Las opciones con (*) son obligatorias'}, ...
    '(1) Configuración de Imagen (*)', ...
    '(2) Edición de Imagen', ...
    '(3) Reconocimiento de Línea (*)', ...
    '(4) Digitalización de Línea (*)', ...
    '(5) Utilitarios', ...
    'Acerca de', ...
    'Cerrar');

switch menu_0
    case 1
        run('a1_menu_config')
    case 2
        run('a2_menu_edit')
    case 3
        run('a3_menu_reconoc')
    case 4
        run('a4_menu_digit')
    case 5
        run('a5_menu_utilit')
    case 6
        run('a6_acerca_de')
    otherwise
        close all force
end