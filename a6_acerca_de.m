mymap = [0,0,0; 0,0,0];

myStruct.WindowStyle = 'replace';
myStruct.Interpreter = 'tex';

uiwait(msgbox({
    ''
    '\fontsize{18}\bfPluvioReader'
    '\fontsize{14}\rmVersion 1.4'
    ''
    '\fontsize{12}Developed by Andrés Burboa'
    ''
    '\fontsize{10}andresburboa@udec.cl'
    'andres.burboa@gmail.com'
    ''}, ...
    'About', 'help', 'custom', mymap, myStruct))

run('a0_menu_principal')