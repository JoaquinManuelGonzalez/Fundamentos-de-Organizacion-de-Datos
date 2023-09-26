program ej12p2fod;

const
    valorAlto = 9999;

type
    usuarios = record
        anio: integer;
        mes: integer;
        dia: integer;
        usuario: integer;
        tiempo: integer;
    end;
    maestro = file of usuarios;

procedure crearBin (var m: maestro);
var
    u: usuarios;
    t: Text;
begin
    assign(t, 'maestro.txt');
    assign(m, 'maestro.bin');
    reset(t);
    rewrite(m);
    while not eof(t) do begin
        with u do readln(t, anio, mes, dia, tiempo, usuario);
        write(m, u);
    end;
    close(t);
    close(m);
end;

procedure leer (var m: maestro; var u: usuarios);
begin
    if not eof(m) then
        read(m, u)
    else
        u.anio:= valorAlto;
end;

procedure informe (var m: maestro);
var
    anio, tiempo_dia, tiempo_usuario, tiempo_mes, tiempo_anio: integer;
    u, actual: usuarios;
begin
    writeln('Ingrese el anio a procesar: ');
    readln(anio);
    reset(m);
    leer(m, u);
    tiempo_anio:= 0;
    while (u.anio <> valorAlto) and (u.anio <> anio) do
        leer(m, u);
    if u.anio = valorAlto then
        writeln('No existe el anio.')
    else begin
        writeln('Anio: ', u.anio);
        while (u.anio = anio)  do begin
            actual.mes:= u.mes;
            tiempo_mes:= 0;
            writeln('   Mes: ', actual.mes);
            while (u.anio = anio) and (u.mes = actual.mes) do begin
                tiempo_dia:= 0;
                actual.dia:= u.dia;
                writeln('       Dia: ', actual.dia);
                while  (u.anio = anio) and (u.mes = actual.mes) and (u.dia = actual.dia) do begin
                    tiempo_usuario:= 0;
                    actual.usuario:= u.usuario;
                    while (u.anio = anio) and (u.mes = actual.mes) and (u.dia = actual.dia) and (u.usuario = actual.usuario) do begin
                        tiempo_usuario:= tiempo_usuario + u.tiempo;
                        leer(m, u);
                    end;
                    writeln('           idUsuario: ', actual.usuario, ' Tiempo total de acceso en el dia ', actual.dia, ' mes ', actual.mes, ': ', tiempo_usuario);
                    tiempo_dia:= tiempo_dia + tiempo_usuario;
                end;
                writeln('       Tiempo total acceso dia ', actual.dia, ' mes ', actual.mes, ': ', tiempo_dia);
                tiempo_mes:= tiempo_mes + tiempo_dia;
            end;
            writeln('   Total tiempo de acceso mes ', actual.mes, ': ', tiempo_mes);
            tiempo_anio:= tiempo_anio + tiempo_mes;
        end;
        writeln('Total tiempo de acceso anio ', anio, ': ', tiempo_anio);
    end;
    close(m);
end;

var
    m: maestro;
begin
    crearBin(m);
    informe(m);
end.