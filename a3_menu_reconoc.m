% SUBMEN� RECONOCIMIENTO DE L�NEA

menu_3 = menu({ ...
    '(3) RECONOCIMIENTO DE LINEA'
    ''
    'Las opciones con (*) son obligatorias'}, ...
    '(3.1) Identificar L�nea (conversi�n a imagen binaria) (*)', ...
    '(3.2) Unir y Eliminar segmentos identificados (autom�tico) (*)', ...
    '(3.3) Eliminar �reas (manual)', ...
    '(3.4) Unir elementos (manual)', ...
    'Vista Previa', ...
    'Deshacer Cambios', ...
    'Rehacer Cambios', ...
    'Atr�s');

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