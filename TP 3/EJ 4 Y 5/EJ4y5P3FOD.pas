program ej4Y5p3fod;

type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;
    archFlores = file of reg_flor;

procedure alta (var f: archFlores; flor: reg_flor);
var
    cabecera: flor;
    indice: integer;
begin
    reset(f);
    read(f, cabecera);
    if (cabecera.codigo = 0) then begin
        seek(f, FileSize(f));
        write(f, flor);
    end else begin
        indice:= cabecera.codigo * -1;
        seek(f, indice);
        read(f, cabecera);
        seek(f, indice);
        write(f, flor);
        seek(f, 0);
        write(f, cabecera);
    close(f);
end;

procedure eliminacion (var f: archFlores; var flor: reg_flor);
var 
    cabecera, aux: reg_flor;
    indice: integer;
    encontre: boolean;
begin
    reset(f);
    read(f, cabecera);
    encontre:= False;
    while (not eof(f)) and (not encontre) do begin
        read(f, aux);
        if (aux.codigo = flor.codigo) then begin
            indice:= (filePos(f) - 1) * -1;
            seek(f, filePos(f) - 1);
            write(f, cabecera);
            seek(f, 0);
            cabecera.codigo:= indice;
            write(f, cabecera);
            encontre:= True;
        end;
    end;
    if not encontre then
        writeln('No existe la flor');
    else
        writeln('Eliminada');
end;

procedure mostrar (var f: archFlores);
var
    flor: reg_flor;
begin
    reset(f);
    seek(f, 1)
    while not eof(f) do begin
        read(f, flor);
        if flor.codigo > 0 then
            writeln (flor.codigo, flor.nombre);
    end;
end;