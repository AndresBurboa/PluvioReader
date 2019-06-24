close all force

menu_0 = menu({ ...
    'PLUVIOREADER: AN AUTOMATIC SOFTWARE FOR'
    'DIGITIZING PLUVIOGRAPH STRIP CHARTS'
    ''
    'Options marked (*) are mandatory'}, ...
    '(1) Configure Image (*)', ...
    '(2) Edit Image', ...
    '(3) Define Line (*)', ...
    '(4) Digitize Line (*)', ...
    '(5) Tools', ...
    'About', ...
    'Close');

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