% SUBMENÚ UTILITARIOS

menu_5 = menu( ...
    '(5) UTILITARIOS', ...
    '(5.1) Exportar Imagen (RGB o BW)',...
    '(5.2) Unir Planillas con Resultados Exportados', ...
    'Atrás');

switch menu_5
    case 1
        run('b51_exportar_imagen')
        run('a5_menu_utilit')
    case 2
        run('b52_unir_planillas')
        run('a5_menu_utilit')
    otherwise
        run('a0_menu_principal')
end