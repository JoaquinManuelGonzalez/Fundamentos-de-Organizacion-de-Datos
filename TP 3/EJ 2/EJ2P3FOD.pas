program ej2p3fod;

const
    marca_eliminacion = '@';
    valorAlto = 'ZZZ';

type
    asistente = record
        nro_asistente: integer;
        apellido: string;
        nombre: string;
        email: string;
        telefono: longInt;
        dni: longInt;
    end;
    congreso = file of asistente;

procedure cargaArchivo (var arch: congreso);

    procedure leerAsistente (var a: asistente);
    begin
        writeln('Ingrese el apellido del asistente: ');
        readln (a.apellido);
        if a.apellido <> valorAlto then begin
            writeln('Ingrese el nombre del asistente: ');
            readln (a.nombre);
            writeln('Ingrese el numero del asistente: ');
            readln (a.nro_asistente);
            writeln('Ingrese el email del asistente: ');
            readln (a.email);
            writeln('Ingrese el telefono del asistente: ');
            readln (a.telefono);
            writeln('Ingrese el DNI del asistente: ');
            readln (a.dni);
        end;
    end;

var
    a: asistente;
    nom: string;
begin
    writeln('Ingrese el nombre que le quiere dar al archivo: ');
    readln(nom);
    assign(arch, nom);
    rewrite(arch);
    leerAsistente(a);
    while a.apellido <> valorAlto do begin
        write(arch, a);
        leerAsistente(a);
    end;
    writeln('Carga completada');
    close(arch);
end;

procedure eliminacion (var arch: congreso);

    procedure leer(var arch: congreso; var a: asistente);
    begin
        if not eof(arch) then
            read(arch, a)
        else
            a.apellido:= valorAlto;
    end;

var
    a: asistente;
begin
    reset(arch);
    leer(arch, a);
    while a.apellido <> valorAlto do begin
        if (a.nro_asistente < 1000) then begin
            a.apellido:= marca_eliminacion + a.apellido;
            seek(arch, filePos(arch) - 1);
            write(arch, a);
        end;
        leer(arch, a);
    end;
    close(arch);
end;

procedure deAUno (var arch: congreso);
var
	a: asistente;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch, a);
        if (Pos(marca_eliminacion, a.apellido) = 0) then
		    writeln('Nombre: ',a.nombre,' .Apellido: ', a.apellido, ' .DNI: ', a.dni, ' .Email: ', a.email, ' .Numero de Asistente: ', a.nro_asistente, ' .Telefono: ': a.telefono);
	end;
	close (arch);
end;


var
    arch: congreso;
begin
    cargaArchivo(arch);
    //assign(arch, 'congreso.bin');
    deAUno(arch);
    writeln('===================================VALORES ACTUALIZADOS===================================');
    eliminacion(arch);
    deAUno(arch);
end.



