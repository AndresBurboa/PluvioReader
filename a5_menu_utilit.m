menu_5 = menu( ...
    '(5) TOOLS', ...
    '(5.1) Export Image (RGB or BW)', ...
    '(5.2) Merge Spreadsheets with Exported Results', ...
    'Back');

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