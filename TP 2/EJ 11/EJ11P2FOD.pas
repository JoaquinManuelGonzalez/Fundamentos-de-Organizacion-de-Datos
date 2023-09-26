program ej11p2fod;

const
    valorAlto = 'ZZZ';

type
    registro_maestro = record
        nombre_provincia: string;
        cant_personas_alfabetizadas: integer;
        total_encuestados: integer;
    end;
    registro_detalle = record
        nombre_provincia: string;
        cod_localidad: integer;
        cant_personas_alfabetizadas: integer;
        total_encuestados: integer;
    end;
    maestro = file of registro_maestro;
    detalle = file of registro_detalle;

procedure asignacion (var m: maestro; var d1: detalle; var d2: detalle);
begin
    assign(m, 'maestro.bin');
    assign(d1, 'detalle1.bin');
    assign(d2, 'detalle2.bin');
end;

procedure crearDetalles (var d1: detalle; var d2: detalle);
var
    t1, t2: Text;
    aux: registro_detalle;
begin
    assign(d1, 'detalle1.bin');
    assign(d2, 'detalle2.bin');
    assign(t1, 'detalle1.txt');
    assign(t2, 'detalle2.txt');
    reset(t1);
    reset(t2);
    rewrite(d1);
    rewrite(d2);
    while not eof(t1) do begin
        with aux do readln (t1, cod_localidad, cant_personas_alfabetizadas, total_encuestados, nombre_provincia);
        write (d1, aux);
    end;
    while not eof(t2) do begin
        with aux do readln (t2, cod_localidad, cant_personas_alfabetizadas, total_encuestados, nombre_provincia);
        write (d2, aux);
    end;
    close(t1);
    close(t2);
    close(d1);
    close(d2);
end;

procedure crearMaestro (var m: maestro);
var
    t: Text;
    aux: registro_maestro;
begin
    assign(t, 'maestro.txt');
    assign(m, 'maestro.bin');
    reset(t);
    rewrite(m);
    while not eof(t) do begin
        with aux do readln(t, cant_personas_alfabetizadas, total_encuestados, nombre_provincia);
        write(m, aux);
    end;
    close(t);
    close(m);
end;

procedure verContenido (var d1: detalle; var d2: detalle; var m: maestro);
var
    regD: registro_detalle;
    regM: registro_maestro;
begin
    reset(d1);
    reset(d2);
    reset(m);
    writeln('=========================================DETALLE 1========================================');
    while not eof(d1) do begin
        read(d1, regD);
        writeln ('Nombre de la provincia: ', regD.nombre_provincia, '. Cant alfabetizados: ', regD.cant_personas_alfabetizadas, '. Cant encuestados: ', regD.total_encuestados);
        writeln('------------------------------------------------------------------------------------------');
    end;
    writeln('=========================================DETALLE 2========================================');
    while not eof(d2) do begin
        read(d2, regD);
        writeln ('Nombre de la provincia: ', regD.nombre_provincia, '. Cant alfabetizados: ', regD.cant_personas_alfabetizadas, '. Cant encuestados: ', regD.total_encuestados);
        writeln('------------------------------------------------------------------------------------------');
    end;
    writeln('==========================================MAESTRO=========================================');
    while not eof(m) do begin
        read(m, regM);
        writeln ('Nombre de la provincia: ', regM.nombre_provincia, '. Cant alfabetizados: ', regM.cant_personas_alfabetizadas, '. Cant encuestados: ', regM.total_encuestados);
        writeln('------------------------------------------------------------------------------------------');
    end;
    close(d1);
    close(d2);
    close(m);
end;

procedure actualizar (var m: maestro; var d1: detalle; var d2: detalle);

    procedure leer (var d: detalle; var r: registro_detalle);
    begin
        if not eof(d) then
            read(d, r)
        else
            r.nombre_provincia:= valorAlto;
    end;

    procedure minimo (var d1: detalle; var d2: detalle; var r1: registro_detalle; var r2: registro_detalle; var min: registro_detalle);
    begin
        if (r1.nombre_provincia < r2.nombre_provincia) then begin
            min:= r1;
            leer(d1, r1);
        end else begin
            min:= r2;
            leer(d2, r2);
        end;
    end;

var
    r1, r2, min: registro_detalle;
    regM: registro_maestro;
begin
    reset(d1);
    reset(d2);
    reset(m);
    leer(d1, r1);
    leer(d2, r2);
    minimo(d1, d2, r1, r2, min);
    while min.nombre_provincia <> valorAlto do begin
        read(m, regM);
        while min.nombre_provincia <> regM.nombre_provincia do
            read(m, regM);
        while (min.nombre_provincia = regM.nombre_provincia) do begin
            regM.cant_personas_alfabetizadas:= regM.cant_personas_alfabetizadas + min.cant_personas_alfabetizadas;
            regM.total_encuestados:= regM.total_encuestados + min.total_encuestados;
            minimo(d1, d2, r1, r2, min);
        end;
        seek (m, filePos(m) - 1);
        write(m, regM);
    end;
    close(d1);
    close(d2);
    close(m);
end;


var
    m: maestro;
    d1, d2: detalle;
begin
    //crearDetalles(d1, d2);
    //crearMaestro(m);
    asignacion(m, d1, d2);
    verContenido(d1, d2, m);
    writeln('');
    writeln('===================================VALORES ACTUALIZADOS===================================');
    writeln('');
    actualizar(m, d1, d2);
    verContenido(d1, d2, m);
end.