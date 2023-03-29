program ej1p2fod;
const
    valor_alto = 9999;

type
    comisiones = record
        cod: integer;
        nombre: string[20];
        monto: real;
    end;
    archM = file of comisiones;

procedure imprimir (var arch: archM);
var 
    c: comisiones;
begin
    reset(arch);
    while not eof(arch) do begin
        read(arch, c);
        writeln (c.cod);
        writeln (c.nombre);
        writeln (c.monto:5:2);
    end;
    close(arch);
end;

procedure compactar (var arch: archM);

    procedure leer (var arch: archM;var c: comisiones);
    begin  
        if not eof(arch) then
            read(arch, c)
        else
            c.cod:= valor_alto;
    end;

var 
    archC: archM;
    c, auxC: comisiones;
begin
    Assign (arch, 'maestro_uno');
    Assign (archC, 'archC');
    reset(arch);
    rewrite(archC);
    leer(arch, c);
    while c.cod <> valor_alto do begin
        auxC.cod:= c.cod;
        auxC.nombre:= c.nombre;
        auxC.monto:= 0;
        while c.cod = auxC.cod do begin
            auxC.monto:= auxC.monto + c.monto;
            leer(arch,c);
        end;
        write(archC, auxC);
    end;
    close(arch);
    close(archC);
    imprimir(arch);
    writeln('-----------------------------------------');
    imprimir(archC);
end;

    

var
    arch: archM;
begin
    compactar(arch);
end.
