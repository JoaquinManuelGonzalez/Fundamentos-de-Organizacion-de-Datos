{Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:

i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario}

program ej3p3fod;

const 
    valorAlto = 999;

type
    novela = record
        codigo: integer;
        genero: string;
        nombre: string;
        duracion: integer;
        director: string;
        precio: integer;
    end;
    novelas = file of novela;

procedure menu (var n: novelas);

    procedure leerArch (var n: novelas; var novel: novela);
    begin
        if not eof(n) then
            read(n, novel)
        else
            novel.codigo:= valorAlto;
    end;

    procedure leer (var novel: novela);
    begin
        writeln ('Ingrese el codigo de la novela: ');
        readln(novel.codigo);
        if novel.codigo <> valorAlto then begin
            writeln ('Ingrese el nombre de la pelicula: ');
            readln(novel.nombre);
            writeln ('Ingrese el genero de la pelicula: ');
            readln(novel.genero);
            writeln ('Ingrese el nombre del director: ');
            readln(novel.director);
            novel.precio:= random(1400);
            novel.duracion:= random (200);
        end;
    end;

    procedure creacionBinaria (var n: novelas);
    var
        novel: novela;
        nom: string;
    begin
        writeln ('Ingrese el nombre del archivo a crear: ');
        readln(nom);
        assign(n, nom);
        rewrite(n);
        novel.codigo:= 0;
        write(n, novel);
        leer(novel);
        while novel.codigo <> valorAlto do begin
            write(n, novel);
            leer(novel);
        end;
        close(n);
        writeln('Archivo Cargado, volviendo al menu.');
        menu(n);
    end;

    procedure mantenimiento(var n: novelas);

        procedure alta(var n: novelas);
        var
            cabecera, novel: novela;
            indice: integer;
        begin
            reset(n);
            leer(novel);
            read(n, cabecera); //LEO EN LA POS 0 DEL ARCHIVO
            indice:= cabecera.codigo * -1; //CALCULO DONDE ESTÁ EL LUGAR LIBRE
            seek(n, indice);
            read(n, cabecera); //LEO EL CODIGO NEGATIVO QUE ESTÁ EN EL LUGAR LIBRE
            seek(n, indice);
            write(n, novel); //COMO AL HACER EL READ ANTERIOR ME PASE POR UNO DE DONDE DEBO ESCRIBIR, VUELVO CON EL SEEK Y ESCRIBO
            seek(n, 0);
            write(n, cabecera); //ACTUALIZO LA CABECERA CON EL NUEVO INDICE NEGATIVO
            close(n);
            writeln('Volviendo al menu de modificaciones');
            mantenimiento(n);
        end;

        procedure eliminacion(var n: novelas);
        var
            cod, pos: integer;
            novel, cabecera: novela;            
            encontre: boolean;
        begin
            reset(n);
            read(n, cabecera); //LEO EN CABECERA EL REGISTRO DE LA POS 0 DEL ARCHIVO
            encontre:= False;
            writeln('Ingrese el codigo a eliminar: ');
            readln(cod);
            leerArch(n, novel); //AHORA VA A EMPEZAR LA BUSQUEDA DEL ELEMENTO A ELIMINAR
            while (novel.codigo <> valorAlto) and (not encontre) do begin
                if novel.codigo = cod then begin //SI ES EL ELEMENTO QUE QUIERO ELIMINAR HAGO LO SIGUIENTE:
                    seek(n, filePos(n) - 1);
                    pos:= filePos(n) * -1; //CON EL SEEK ANTERIOR VUELVO A LA POS DEL ELEM PORQUE LEYENDO ME PASE POR UNO Y ME GUARDO EL INDICE NEGATIVO
                    write(n, cabecera); //ESCRIBO EN EL ELEM LO QUE HAY EN LA CABECERA
                    seek(n, 0);
                    novel.codigo:= pos;
                    write(n, novel); //ESCRIBO EN LA CABECERA LA POS NEGATIVA DEL ELEM
                    encontre:= True;
                end else
                    leerArch(n, novel); //COMO NO ENCONTRÉ, SIGO LEYENDO
            end;
            close(n);
            writeln('Volviendo al menu de modificaciones');
            mantenimiento(n);
        end;

        procedure modificacion (var n: novelas);
        var
            novel, aux: novela;
            encontre: boolean;
        begin
            encontre:= False;
            leer(novel);
            reset(n);
            while ((not eof(n)) and (encontre = False)) do begin
                read(n, aux);
                if novel.codigo = aux.codigo then begin
                    aux.genero:= novel.genero;
                    aux.duracion:= novel.duracion;
                    aux.nombre:= novel.nombre;
                    aux.director:= novel.director;
                    aux.precio:= novel.precio;
                    seek(n, filePos(n) - 1);
                    write(n, aux);
                    encontre:= True;
                end;
            end;
            close(n);
            writeln('Volviendo al menu de modificaciones');
            mantenimiento(n);
        end;


    var
        opcion, nom: string;
    begin
        writeln('Ingrese el nombre del archivo a abrir: ');
        readln(nom);
        assign(n, nom);
        writeln('Ingrese alguna de las siguientes opciones: ');
        writeln('A. Dar de alta una novela a partir de informacion ingresada por teclado.');
        writeln('B. Modificar los datos de una novela ingresano los datos por teclado.');
        writeln('C. Eliminar una novela cuyo codigo es ingresado por teclad.');
        writeln('EXIT. Volver al menu principal.');
        readln(opcion);
        case opcion of
            'A': alta(n);
            'B': modificacion(n);
            'C': eliminacion(n);
            'EXIT': menu(n);
        end;
    end;

    procedure exportacion (var n: novelas);
    var
        texto: Text;
        novel: novela;
    begin
        assign(texto, 'novelas.txt');
        reset(n);
        rewrite(texto);
        seek(n, 1);
        while not eof (n) do begin
            read(n, novel);
            with novel do begin
                writeln(texto, ' ', codigo, ' ', genero);
                writeln(texto, ' ', duracion, ' ', nombre);
                writeln(texto, ' ', precio, ' ', director);
            end;
        end;
        close(texto);
        close(n);
        writeln('Archivo Cargado, volviendo al menu.');
        menu(n);
    end;


var
    opcion: string;
begin
    writeln('Ingrese la opcion a realizar: ');
    writeln('A. Creacion de un archivo de novelas.');
    writeln('B. Apertura de menu de mantenimiento.');
    writeln('C. Exportar a texto la informacion de todas las novelas.');
    writeln('EXIT. Cierre del menu.');
    readln(opcion);
    case opcion of
        'A': creacionBinaria(n);
        'B': mantenimiento(n);
        'C': exportacion(n);
        'EXIT': writeln('Gracias por usar el menu.');
    end;
end;

var
    n: novelas;
begin
    menu(n);
end.
