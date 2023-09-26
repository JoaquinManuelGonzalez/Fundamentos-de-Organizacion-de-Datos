program ej2p2fod;
const
    valor_alto = 999;

type
    alumnos = record
        cod: integer;
        apellido: string[20];
        nombre: string[20];
        aprobadas: integer;
        promocionadas: integer;
    end;
    alum_detalle = record
        cod: integer;
        aprobo_final: integer;
    end;
    master = file of alumnos;
    detalle = file of alum_detalle;

procedure menu (var archM: master; var archD: detalle);

    function otraOpcion(): integer;
    var 
        aux: integer;
    begin
        writeln('Ingrese 1 si quiere volver al menu, sino, ingrese 2');
        readln(aux);
        otraOpcion:= aux;
    end;

    procedure creacion (var archM: master; var archD: detalle);

        procedure CrearArchivoDetalle(var archD:detalle);
        var
            carga: text;
            alum: alum_detalle;
        begin
            assign(archD,'detalle.data');
            assign(carga, 'detalleEJ2P2.txt');
            rewrite(archD);
            reset(carga);
            while(not  eof(carga)) do 
            begin
                with alum do readln(carga, cod, aprobo_final);
                write(archD, alum);
            end;
            writeln('Archivo cargado.');
            close(archD);
        end;

        procedure CrearArchivoMaestro(var archM:master);
        var
            carga: text;
            alum: alumnos;
        begin
            assign(archM,'maestro.data');
            assign(carga, 'masterEJ2P2.txt');
            rewrite(archM);
            reset(carga);
            while(not  eof(carga)) do 
            begin
                readln(carga, alum.cod);
                readln(carga, alum.apellido);
                readln(carga, alum.nombre);
                readln(carga, alum.aprobadas);
                ReadLn(carga, alum.promocionadas);
                write(archM, alum);
            end;
            writeln('Archivo cargado.');
            close(archM); 
        end;
    
    begin
        CrearArchivoMaestro(archM);
        CrearArchivoDetalle(archD);
    end;

    procedure incisoA (var archM: master; var archD: detalle);

    {i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
    ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.}

        procedure leer(var archD: detalle; var a: alum_detalle);
        begin
            if not eof(archD) then
                read(archD, a)
            else
                a.cod:= valor_alto;
        end;

    var
        a: alumnos;
        actual: alum_detalle;
        totalPromo, totalFinal: integer;
    begin
        reset(archM);
        reset(archD);
        leer (archD, actual);
        while actual.cod <> valor_alto do begin
            totalPromo:= 0;
            totalFinal:= 0;
            read(archM, a);
            while (actual.cod <> a.cod) do
                read(archM, a);
            while actual.cod = a.cod do begin
                if actual.aprobo_final = 1 then
                    totalFinal:= totalFinal + 1
                else
                    totalPromo:= totalPromo + 1;
                leer(archD, actual);
            end;
            seek(archM, filepos(archM) - 1);
            a.aprobadas:= a.aprobadas + totalFinal;
            a.promocionadas:= a.promocionadas + totalPromo;
            write(archM, a);
        end;
        close(archM);
        close(archD);
        if otraOpcion() = 1 then
            menu(archM, archD)
    end;

    procedure incisoB (var archM: master);

    {Listar en un archivo de texto los alumnos que tengan más de cuatro materias
    con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.}

        procedure imprimir(a: alumnos);
        begin
            write ('Nombre: ');
            writeln(a.nombre);
            write ('Apellido: ');
            writeln(a.apellido);
            write('Codigo: ');
            writeln(a.cod);
            write('Cantidad sin final: ');
            writeln(a.aprobadas);
            write('Cantidad promocionadas: ');
            writeln(a.promocionadas);
        end;
    
    var
        a: alumnos;
    begin   
        reset(archM);
        while not eof(archM) do begin
            read(archM, a);
            if a.promocionadas > 4 then
                imprimir(a);
        end;
        if otraOpcion() = 1 then
            menu(archM, archD)
    end;

    procedure imprimir2 (var archM: master; var archD: detalle);
    var 
        a: alumnos;
        a2: alum_detalle;
    begin
        reset (archM);
        reset (archD);
        while not eof (archM) do begin
            read(archM, a);
            write ('Nombre: ');
            writeln(a.nombre);
            write ('Apellido: ');
            writeln(a.apellido);
            write('Codigo: ');
            writeln(a.cod);
            write('Cantidad sin final: ');
            writeln(a.aprobadas);
            write('Cantidad promocionadas: ');
            writeln(a.promocionadas);
        end;
        writeln ('------------------------------');
        while not eof (archD) do begin
            read(archD, a2);
            write('Codigo: ');
            writeln(a2.cod);
            write('Cantidad con o sin final? ');
            writeln(a2.aprobo_final);
        end;
        close(archM);
        close(archD);
    end;

var
    opcion: char;
begin
    writeln('A. Creacion de los Archivos');
    writeln('B. Inciso A');
    writeln('C. Inciso B');
    writeln('Q. salir del menu');
    readln(opcion);
    case opcion of
        'A': begin
            creacion(archM, archD);
            imprimir2(archM, archD);
            if otraOpcion() = 1 then
                menu(archM, archD)
        end;
        'B': incisoA(archM, archD);
        'C': incisoB(archM);
        'Q': writeln('Ha salido con exito.');
    end;
end;

var
    archM: master;
    archD: detalle;
begin
    menu(archM, archD);
end.

