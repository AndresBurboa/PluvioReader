menu_3 = menu({ ...
    '(3) DEFINE LINE'
    ''
    'Options marked (*) are mandatory'}, ...
    '(3.1) Identify Line (convert to binary image) (*)', ...
    '(3.2) Join and Remove Segments Automatically (*)', ...
    '(3.3) Remove Elements (manually)', ...
    '(3.4) Join Elements (manually)', ...
    'Preview Image', ...
    'Undo Changes', ...
    'Redo Changes', ...
    'Back');

switch menu_3
    case 1
        run('b31_identificar_linea')
        run('a3_menu_reconoc')
    case 2
        run('b32_unir_y_eliminar_auto')
        run('a3_menu_reconoc')
    case 3
        run('b33_eliminar_bw')
        run('a3_menu_reconoc')
    case 4
        run('b34_unir_bw')
        run('a3_menu_reconoc')
    case 5
        run('c3_vista_previa')
        run('a3_menu_reconoc')
    case 6
        run('c4_deshacer')
        run('a3_menu_reconoc')
    case 7
        run('c5_rehacer')
        run('a3_menu_reconoc')
    otherwise
        run('a0_menu_principal')
end