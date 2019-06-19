% SUBMEN� EDICI�N DE IMAGEN

menu_2 = menu( ...
    '(2) EDICI�N DE IMAGEN', ...
    '(2.1) Encuadrar Imagen', ...
    '(2.2) Eliminar �reas', ...
    '(2.3) Trazar L�nea', ...
    'Vista Previa', ...
    'Deshacer Cambios', ...
    'Rehacer Cambios', ...
    'Atr�s');

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