{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. 
Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}

program ej6p3fod;

const
    nombre = 'maestro.bin';
    nombre_nuevo = 'maestro_actualizado.bin';

type 
    prenda = record
        cod_prenda: integer;
        descripcion: string;
        colores: string;
        tipo_prenda: string;
        stock: integer;
        precio_unitario: real;
    end;
    maestro = file of prenda;
    detalle = file of integer;

procedure crearMaestro (var m: maestro);
var
    txt: Text;
    p: prenda;
begin
    assign(txt, 'maestro.txt');
    assign(m, nombre);
    reset(txt);
    rewrite(m);
    while not eof(txt) do begin
        with p do begin
            readln(txt, cod_prenda, stock, precio_unitario, colores);
            readln(txt, descripcion);
            readln(txt, tipo_prenda);
        end;
        write(m, p);
    end;
    close(txt);
    close(m);
    writeln('Archivo maestro creado.');
end;

procedure mostrarMaestro (var m: maestro);
var 
    p: prenda;
begin
    reset(m);
    writeln('------------------------------------------------------');
    while not eof(m) do begin
        read(m, p);
        with p do begin
            writeln('Cod: ', cod_prenda, '. Stock: ', stock, '. Precio: ', precio_unitario:5:2);
            writeln('Descripcion: ', descripcion, '. Colores: ', colores, '. Tipo de prenda: ', tipo_prenda);
        end;
    end;
    writeln('------------------------------------------------------');
end;

procedure crearDetalle (var d: detalle);
var
    i: integer;
begin
    assign(d, 'detalle.bin');
    rewrite(d);
    for i:= 1 to 10 do begin
        if i mod 2 <> 0 then
            write(d, i);
    end;
    close(d);
    writeln('Archivo detalle creado.');
end;

procedure bajaLogica (var m: maestro; var d: detalle);
var
    p: prenda;
    cod: integer;
    encontre: boolean;
begin
    reset(m);
    reset(d);
    while not eof(d) do begin
        read(d, cod);
        encontre:= False;
        while ((not eof(m)) and (not encontre)) do begin
            read(m, p);
            if (p.cod_prenda = cod) then begin
                p.stock:= p.stock * -1;
                seek(m, filePos(m) - 1);
                write(m, p);
                encontre:= True;
            end;
        end;
        seek(m, 0);
    end;
    close(m);
    close(d);
end;

procedure compactacion (var m: maestro);
var
    p: prenda;
    aux: maestro;
begin
    assign(aux, 'auxiliar.bin');
    rewrite(aux);
    reset(m);
    while not eof(m) do begin
        read(m, p);
        if (p.stock > -1) then
            write(aux, p);
    end;
    close(aux);
    close(m);
    erase(m);
    rename(aux, nombre);
end;

var
    m: maestro;
    d: detalle;
begin
    crearMaestro(m);
    crearDetalle(d);
    mostrarMaestro(m);
    bajaLogica(m, d);
    compactacion(m);
    mostrarMaestro(m);
end.