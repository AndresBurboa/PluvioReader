% SUBMENÚ CONFIGURACIÓN DE IMAGEN

menu_1 = menu({ ...
    '(1) CONFIGURACIÓN DE IMAGEN'
    ''
    'Las opciones con (*) son obligatorias'}, ...
    '(1.1) Seleccionar Imagen (*)', ...
    '(1.2) Añadir Información de la Imagen (*)', ...
    '(1.3) Definir márgenes de la Imagen (*)', ...
    'Atrás');

switch menu_1
    case 1
        run('b11_seleccionar_imagen')
        run('a1_menu_config')
    case 2
        run('b12_anadir_info_imagen')
        run('a1_menu_config')
    case 3
        run('b13_definir_margenes')
        run('a1_menu_config')
    otherwise
        run('a0_menu_principal')
end
