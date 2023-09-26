program ej3p2;

const
    dimF = 3;
    valorAlto = 999;

type
    productoM = record
        cod: integer;
        nombre: string[30];
        descrip: string[30];
        stockD: integer;
        stockM: integer;
        precio: integer;
    end;
    productoD = record
        cod: integer;
        vendidos: integer;
    end;
    maestro = file of productoM;
    detalle = file of productoD;
    productos = array[1..dimF] of detalle;
    regDetalle = array[1..dimF] of productoD;

procedure creacionMaestro (var master: maestro);
var
    texto: Text;
    p: productoM;
begin
    Assign(master, 'maestroBin');
    Assign(texto, 'maestro.txt');
    reset(texto);
    rewrite(master);
    while not eof(texto) do begin
        with p  do begin
            readln(texto, cod, stockD, stockM, precio, nombre);
            readln(texto, descrip);
        end;
        write(master, p);
    end;
    writeln('Archivo Cargado');
    close(master);
    close(texto);
end;

procedure conversionBinaria ();
var
    texto: Text;
    p: productoD;
    binn: detalle;
begin
    assign(texto, 'detalle.txt');
    assign(binn, 'detalleBin');
    reset(texto);
    rewrite(binn);
    while not eof(texto) do begin
        with p do readln (texto, cod, vendidos);
        write(binn, p);
    end;
    writeln('Archivo Cargado');
    close(binn);
    close(texto);
end;

procedure creacionDetalles (var produc: productos);
var
    i: integer;
    istring: string;
begin
    for i:= 1 to dimF do begin
        str(i, istring);
        Assign(produc[i], ('detalleBin - copia (' + istring+ ')'));
    end;
end;

procedure leer (var detail: detalle; var dato: productoD);
begin
    if not eof(detail) then
        read(detail, dato)
    else
        dato.cod:= valorAlto;
end;

procedure actualizar (var master: maestro; var produc: productos; var regs: regDetalle);


    procedure leerTodos (var regs: regDetalle; var deta: productos);
    var
        i: integer;
    begin
        for i:= 1 to dimF do begin
            reset(deta[i]);
            leer(deta[i], regs[i]);
        end;
    end;

    procedure minimo (var regs: regDetalle; var min: productoD; var deta: productos);
    var
        i, pos: integer;
    begin
        min.cod:= valorAlto;
        for i:= 1 to dimF do begin 
            if (regs[i].cod < min.cod) then begin
                min:= regs[i];
                pos:= i;
            end;
        end;
        if (min.cod <> valorAlto) then begin
            min:= regs[pos];
            leer(deta[pos], regs[pos]);
        end;
    end;
var
    min, actual: productoD;
    regM: productoM;
    i: integer;
begin
    reset(master);
    leerTodos(regs, produc);
    minimo(regs, min, produc);
    while min.cod <> valorAlto do begin
        read(master, regM);
        actual.cod:= min.cod;
        actual.vendidos:= 0;
        while (actual.cod <> regM.cod) do
            read(master, regM);
        while actual.cod = min.cod do begin
            actual.vendidos:= actual.vendidos + min.vendidos;
            minimo(regs, min, produc);
        end;
        seek(master, filePos(master) - 1);
        regM.stockD:= regM.stockD - actual.vendidos;
        write(master, regM);
    end;
    close(master);
    for i:= 1 to dimf do
        close(produc[i]);
end;

procedure exportacion (var master: maestro);
var
    texto: Text;
    p: productoM;
begin
    reset(master);
    assign(texto, 'noHayStock.txt');
    rewrite(texto);
    while not eof(master) do begin
        read(master, p);
        if (p.stockD < p.stockM) then begin
            with p do writeln(texto, stockD,' ',precio,' ', nombre);
            with p do writeln(texto, descrip);
        end;
    end;
    close(master);
    close(texto);
    writeln('TERMINE');
end;

var
    master: maestro;
    produc: productos;
    regs: regDetalle;
begin
    creacionMaestro(master);
    conversionBinaria();
    creacionDetalles(produc);
    actualizar(master, produc, regs);
    exportacion(master);
end.



