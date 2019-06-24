menu_2 = menu( ...
    '(2) EDIT IMAGE', ...
    '(2.1) Center Image', ...
    '(2.2) Erase Area', ...
    '(2.3) Draw Line', ...
    'Preview Image', ...
    'Undo Changes', ...
    'Redo Changes', ...
    'Back');

switch menu_2
    case 1
        run('b21_encuadrar_imagen')
        run('a2_menu_edit')
    case 2
        run('b22_eliminar_areas')
        run('a2_menu_edit')
    case 3
        run('b23_trazar_linea')
        run('a2_menu_edit')
    case 4
        run('c3_vista_previa')
        run('a2_menu_edit')
    case 5
        run('c4_deshacer')
        run('a2_menu_edit')
    case 6
        run('c5_rehacer')
        run('a2_menu_edit')
    otherwise
        run('a0_menu_principal')
end