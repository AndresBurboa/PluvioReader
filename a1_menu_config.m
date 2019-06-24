menu_1 = menu({ ...
    '(1) CONFIGURE IMAGE'
    ''
    'Options marked (*) are mandatory'}, ...
    '(1.1) Select Image (*)', ...
    '(1.2) Add Image Information (*)', ...
    '(1.3) Define Image Margins (*)', ...
    'Back');

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
