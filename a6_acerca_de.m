% INFORMACI�N ACERCA DE

mymap = [0,0,0; 0,0,0];

myStruct.WindowStyle = 'replace';
myStruct.Interpreter = 'tex';

uiwait(msgbox({
    ''
    '\fontsize{18}\bfPluvioReader'
    '\fontsize{14}\rmVersi�n 1.4'
    ''
    '\fontsize{12}Creado por Andr�s Burboa'
    ''
    '\fontsize{10}andresburboa@udec.cl'
    'andres.burboa@gmail.com'
    ''}, ...
    'Acerca de', 'help', 'custom', mymap, myStruct))

%run('a0_menu_principal')