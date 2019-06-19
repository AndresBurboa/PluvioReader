% MEN� PRINCIPAL PROGRAMA PLUVIOREADER

close all force

menu_0 = menu({ ...
    'PLUVIOREADER: UN PROGRAMA AUTOM�TICO PARA'
    'LA DIGITALIZACI�N DE PLUVIOGRAMAS'
    ''
    'Las opciones con (*) son obligatorias'}, ...
    '(1) Configuraci�n de Imagen (*)', ...
    '(2) Edici�n de Imagen', ...
    '(3) Reconocimiento de L�nea (*)', ...
    '(4) Digitalizaci�n de L�nea (*)', ...
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