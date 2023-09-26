program ej4p2fod;

const
    dimF = 3;
    valorAlto = 9999;

type
    regM = record
        cod: integer;
        fecha: integer;
        tiempoTotal: integer;
    end;
    regD = record
        cod: integer;
        fecha: integer;
        tiempo: integer;
    end;
    detalle = file of regD;
    maestro = file of regM;
    detalles = array[1..dimF] of detalle;
    registros = array[1..dimF] of regD;

procedure verBinarios(var d: detalles);
var
    aux: regD;
    i: integer;
begin
    for i:= 1 to dimF do begin
        reset(d[i]);
        while not eof(d[i]) do begin
            read(d[i], aux);
            writeln('cod: ',aux.cod, ' fecha: ',aux.fecha, ' Tiempo: ', aux.tiempo);
        end;
        close(d[i]);
        writeln('------------------');
    end;
end;

procedure creacionDetalles (var d: detalles);
var
    aux: regD;
    i: integer;
    istring: string;
    texto: Text;
begin
    for i:= 1 to dimF do begin
        str(i, istring);
        assign(texto, 'detalle' + istring +'.txt');
        assign(d[i], 'detalle' + istring +'.bin');
        reset(texto);
        rewrite(d[i]);
        while not eof(texto) do begin
            with aux do readln(texto, cod, fecha, tiempo);
            write(d[i], aux);
        end;
        close(d[i]);
        close(texto);
    end;
end;

procedure merge (var m: maestro; var d: detalles; var r: registros);

    procedure leer (var d: detalle; var r: regD);
    begin
        if not eof(d) then
            read(d, r)
        else begin
            r.cod:= valorAlto;
            r.fecha:= valorAlto;
        end;
    end;

    procedure leerTodos (var d: detalles; var r: registros);
    var
        i: integer;
    begin
        for i:= 1 to dimF do begin
            reset(d[i]);
            leer(d[i], r[i]);
        end;
    end;

    procedure minimo (var d: detalles; var r: registros; var min: regD);
    var
        i, pos: integer;
    begin
        min.cod:= valorAlto;
        min.fecha:= valorAlto;
        for i:= 1 to dimF do begin
            if (r[i].cod < min.cod) or ((r[i].cod = min.cod) and (r[i].fecha <= min.fecha)) then begin
                min:= r[i];
                pos:= i;
            end;
        end;
        if (min.cod <> valorAlto) then begin
            min:= r[pos];
            leer(d[pos], r[pos]);
        end;
        with min do
            writeln('cod: ',cod, ' fecha: ',fecha, ' Tiempo: ', tiempo);
    end;

    var
        min: regD;
        actual: regM;
        i: integer;
    begin
        assign(m, 'maestroBin');
        rewrite(m);
        leerTodos(d, r);
        minimo(d, r, min);
        while min.cod <> valorAlto do begin
            actual.cod:= min.cod;
            actual.tiempoTotal:= 0;
            while actual.cod = min.cod do begin
                actual.fecha:= min.fecha;
                while actual.fecha = min.fecha do begin
                    actual.tiempoTotal:= actual.tiempoTotal + min.tiempo;
                    minimo(d, r, min);
                end;
            end;
            write(m, actual);
        end;
        for i:= 1 to dimF do
            close(d[i]);
        close(m);
    end;

var
    d: detalles;
    r: registros;
    m: maestro;
    aux: regM;
begin
    creacionDetalles(d);
    merge(m, d, r);
    reset (m);
    //verBinarios(d);
    while (not eof(m)) do begin
        read(m, aux);
        writeln(aux.cod);
        writeln(aux.fecha);
        writeln(aux.tiempoTotal);
    end;
    close(m);
end.
        