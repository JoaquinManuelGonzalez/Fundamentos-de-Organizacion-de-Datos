program ej6p2fod;

const
    dimF = 5;
    valorAlto = 9999;

type
    registro_detalle = record
        cod_localidad: integer;
        cod_cepa: integer;
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;
    registro_maestro = record
        cod_localidad: integer;
        nombre_localidad: string;
        cod_cepa: integer;
        nombre_cepa: string;
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;
    maestro = file of registro_maestro;
    detalle = file of registro_detalle;
    array_detalle = array[1..dimF] of detalle;
    registros_detalle = array[1..dimF] of registro_detalle;

procedure crearDetalles (var d: array_detalle);
var
    i: integer;
    istring: string;
    texto: Text;
    regD: registro_detalle;
begin
    for i:= 1 to dimF do begin
        str(i, istring);
        assign(texto, 'detalle' + istring + '.txt');
        reset(texto);
        assign(d[i], 'detalle' + istring + '.bin');
        rewrite(d[i]);
        while not eof(texto) do begin
            with regD do readln (texto, cod_localidad, cod_cepa, cant_fallecidos, cant_activos, cant_nuevos, cant_recuperados);
            write(d[i], regD);
        end;
        close(texto);
        close(d[i]);
    end;
end;

procedure mostrarDetalles (var d: array_detalle);
var
    aux: registro_detalle;
    i: integer;
begin
    writeln('===========================DETALLES===========================');
    for i:= 1 to dimF do begin
        reset(d[i]);
        while not eof(d[i]) do begin
            read(d[i], aux);
            with aux do begin
                writeln('Codigo localidad: ', cod_localidad, ', codigo de cepa: ', cod_cepa);
                writeln('Cantidad de casos nuevos: ', cant_nuevos, ', cantidad de casos activos: ', cant_activos);
                writeln('Cantidad de fallecidos: ', cant_fallecidos, ', cantidad de recuperados: ', cant_recuperados);
            end;
            writeln('');
        end;
        close(d[i]);
        writeln('--------------------------------------------------------------');
    end;
end;

procedure crearMaestro (var m: maestro);
var
    texto: Text;
    regM: registro_maestro;
begin
    assign(texto, 'maestro.txt');
    reset(texto);
    assign(m, 'maestro.bin');
    rewrite(m);
    while not eof(texto) do begin
        with regM do begin
            readln (texto, cod_localidad, nombre_localidad);
            readln (texto, cod_cepa, nombre_cepa);
            readln (texto, cant_activos, cant_nuevos, cant_recuperados, cant_fallecidos);
        end;
        write(m, regM);
    end;
    close(texto);
    close(m);
end;

procedure mostrarMaestro (var m: maestro);
var
    aux: registro_maestro;
begin
    writeln('===========================MAESTRO============================');
    reset(m);
    while not eof(m) do begin
        read(m, aux);
        with aux do begin
            writeln('Codigo de localidad: ', cod_localidad, ', nombre de la localidad: ', nombre_localidad);
            writeln('Codigo cepa: ', cod_cepa, ', nombre de la cepa: ', nombre_cepa);
            writeln('Cantidad de casos nuevos: ', cant_nuevos, ', cantidad de casos activos: ', cant_activos);
            writeln('Cantidad de fallecidos: ', cant_fallecidos, ', cantidad de recuperados: ', cant_recuperados);
        end;
        writeln('');
    end;
    close(m);
    writeln('--------------------------------------------------------------');
end;

procedure actualizar (var d: array_detalle; var m: maestro);

    procedure leer (var d: detalle; var regD: registro_detalle);
    begin
        if not eof(d) then
            read(d, regD)
        else begin
            regD.cod_localidad:= valorAlto;
            regD.cod_cepa:= valorAlto;
        end;
    end;

    procedure leerTodos (var d: array_detalle; var regsD: registros_detalle);
    var
        i: integer;
    begin
        for i:= 1 to dimF do begin
            reset(d[i]); leer(d[i], regsD[i]);
        end;
    end;

    procedure minimo (var d: array_detalle; var regsD: registros_detalle; var min: registro_detalle);
    var
        i, pos: integer;
    begin
        min.cod_localidad:= valorAlto;
        min.cod_cepa:= valorAlto;
        for i:= 1 to dimF do begin
            if (regsD[i].cod_localidad < min.cod_localidad) or ((regsD[i].cod_localidad = min.cod_localidad) and (regsD[i].cod_cepa < min.cod_cepa)) then begin
                min:= regsD[i];
                pos:= i;
            end;
        end;
        if (min.cod_localidad <> valorAlto) and (min.cod_cepa <> valorAlto) then begin
            min:= regsD[pos];
            leer(d[pos], regsD[pos]);
        end;
    end;

    var
        regsD: registros_detalle;
        regM: registro_maestro;
        min: registro_detalle;
        i: integer;
    begin
        reset(m);
        leerTodos(d, regsD);
        minimo(d, regsD, min);
        while (min.cod_localidad <> valorAlto) do begin
            read(m, regM);
            while (min.cod_localidad <> regM.cod_localidad) or (min.cod_cepa <> regM.cod_cepa) do
                read(m, regM);
            while (min.cod_cepa = regM.cod_cepa) do begin
                regM.cant_fallecidos:= regM.cant_fallecidos + min.cant_fallecidos;
                regM.cant_recuperados:= regM.cant_recuperados + min.cant_recuperados;
                regM.cant_activos:= min.cant_activos;
                regM.cant_nuevos:= min.cant_nuevos;
                minimo(d, regsD, min)
            end;
            seek(m, filePos(m) - 1);
            write(m, regM);
        end;
        close(m);
        for i:= 1 to dimF do
            close(d[i]);
    end;




var
    detalles: array_detalle;
    master: maestro;
begin
    crearDetalles(detalles);
    mostrarDetalles(detalles);
    crearMaestro(master);
    mostrarMaestro(master);
    actualizar(detalles, master);
    writeln('~~~~~~~~~~~~~~~~~~~~~~MAESTRO-ACTUALIZADO~~~~~~~~~~~~~~~~~~~~~');
    mostrarMaestro(master);
end.
        