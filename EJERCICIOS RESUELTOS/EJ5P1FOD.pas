program ej5p1fod;

type
    strings = string[30];
    celulares = record
        cod: integer;
        nom: strings;
        descrip: strings;
        marca: strings;
        precio: double;
        stockM: integer;
        stockD: integer;
    end;
    arch_cel = file of celulares;

procedure menu (var arch: arch_cel; var creado: boolean);

    procedure imprimir (c: celulares);
    begin
        writeln('ENTRE IMPRIMIR');
        writeln ('Codigo: ', c.cod, '. Nombre: ', c.nom, '. Descripcion: ', c.descrip, '. Marca: ', c.marca, '. Precio: ', c.precio, '. Stock Disponible: ', c.stockD, '. Stock Minimo: ', c.stockM);
    end;

    procedure imprimirArchB (var arch: arch_cel);
    var
        c: celulares;
    begin
        reset(arch);
        while not eof(arch) do begin
            read(arch, c);
            imprimir(c);
        end;
        close(arch);
    end;

    function otraOpcion (): integer;
	var
		otraop: integer;
	begin
		writeln ('Si desea realizar otra opcion escriba 1 y volvera al menu principal.');
		writeln ('Si desea salir escriba 2 y cerrara el menu.');
		readln (otraop);
		otraOpcion:= otraop;
	end;

    procedure asignacionT (var texto: Text; var nomT: strings); 
    begin
        writeln ('Ingrese el nombre del Archivo de Texto: ');
        readln (nomT);
        Assign (texto, nomT);
    end;

    procedure incisoA(var arch: arch_cel; var creado: boolean);

        procedure asignacionB (var arch: arch_cel; var nomF: strings);
        begin
            writeln ('Ingrese el nombre del Archivo Binario: ');
            readln (nomF);
            Assign (arch, nomF);
        end;

        procedure creacionB (var arch: arch_cel; var texto: Text);
        var
            cel: celulares;
        begin
            rewrite(arch);
            reset(texto);
            while not eof(texto) do begin  
                with cel do readln(texto, cod, precio, marca);
                with cel do readln(texto, stockD, stockM, descrip);
                with cel do readln(texto, nom);
                write(arch, cel);
            end;
            writeln('Archivo Binario cargado.');
            close(arch);
            close(texto);
        end;
                
    var
        texto: Text;
        nomT, nomF: strings;
    begin  
        asignacionB(arch, nomF);
        asignacionT(texto, nomT);
        creacionB(arch, texto);
        creado:= True;
        if otraOpcion() = 1 then
            menu(arch, creado);
    end;

    procedure incisoB (var arch: arch_cel; creado: boolean);
    var
        c: celulares;
    begin
        reset(arch);
        while not eof(arch) do begin
            read(arch, c);
            if c.stockD < c.stockM then 
                imprimir(c);
        end;
        close(arch);
        if otraOpcion() = 1 then
            menu(arch, creado);
    end;

    procedure incisoC (var arch: arch_cel; creado: boolean);

        procedure leerDescrip(var busq: strings);
        begin
            writeln('Ingrese la descripcion que desea utilizar como indice de busqueda: ');
            readln(busq);
        end;

        procedure busqueda (var arch: arch_cel; busq: strings);
        var
            c: celulares;
        begin   
            reset(arch);
            while not eof(arch) do begin    
                read(arch, c);
                writeln('ENTRE AL WHILE');
                if c.descrip = busq then begin
                    writeln('ENTRE IF BUSQUEDA');
                    imprimir(c);
                end;
            end;
            close(arch);
        end;

    var 
        busq: strings;
    begin
        imprimirArchB(arch);
        leerDescrip(busq);
        busqueda(arch, busq);
        if otraOpcion() = 1 then
            menu(arch, creado);
    end;

    procedure incisoD(var arch: arch_cel; creado: boolean);

        procedure exportacion (var arch: arch_cel; var texto: Text);
        var
            c: celulares;
        begin
            reset(arch);
            rewrite(texto);
            while not eof(arch) do begin
                read(arch, c);
                with c do writeln(cod:5, precio:5:2, marca:5);
                with c do writeln(stockD:5, stockM:5, descrip:5);
                with c do writeln(nom:5);
                with c do writeln(texto,' ',cod,' ',precio:5:2,' ',marca,' ');
                with c do writeln(texto,' ',stockD,' ',stockM,' ',descrip,' ');
                with c do writeln(texto,' ',nom);
            end;
            close(arch);
            close(texto);
        end;

    var 
        texto: Text;
        nomT: strings;
    begin
        asignacionT(texto, nomT);
        exportacion(arch, texto);
        if otraOpcion() = 1 then
            menu(arch, creado);
    end;

var 
    opcion: char;
begin
    writeln('Ingrese los siguientes caracteres para realizar estas distintas acciones: ');
    writeln('A. Creacion de un Archivo Binario de celulares a partir de la informacion de un Archivo de texto.');
    writeln('B. Listar en pantalla la informacion de aquellos celulares que tengan un stock disponible menor al minimo.');
    writeln('C. Listar en pantalla la informacion de aquellos celulares que coincidan con una decripcion ingresada por teclado.');
    writeln('D. Exportar la informacion de un Archivo Binario de celulares a un Archivo de Texto.');
    writeln('Q. Salir del menu.');
    readln(opcion);
    case opcion of
        'A': incisoA(arch, creado);
        'B': begin
            if creado then  
                incisoB(arch, creado)
            else begin
                writeln('No se puede realizar esta accion porque no hay ningun Archivo Binario creado.');
                if otraOpcion() = 1 then
                    menu(arch, creado)
            end;
        end;
        'C': begin
            if creado then  
                incisoC(arch, creado)
            else begin
                writeln('No se puede realizar esta accion porque no hay ningun Archivo Binario creado.');
                if otraOpcion() = 1 then
                    menu(arch, creado)
            end;
        end;
        'D': begin
            if creado then  
                incisoD(arch, creado)
            else begin
                writeln('No se puede realizar esta accion porque no hay ningun Archivo Binario creado.');
                if otraOpcion() = 1 then
                    menu(arch, creado)
            end;
        end;
        'Q': writeln('Usted ha salido con exito.');
    end;
end;

var
    creado: boolean;
    arch: arch_cel;
begin
    creado:= False;
    menu(arch, creado);
end.



    
    

