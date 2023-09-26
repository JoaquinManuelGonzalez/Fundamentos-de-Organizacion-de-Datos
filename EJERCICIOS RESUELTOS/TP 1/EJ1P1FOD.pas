program EJ1FOD;

type
	arch_int = file of integer;

procedure crearArch (var arch_int: arch_int; var nomF: string);
begin
	writeln('Ingrese el nombre del archivo: ');
	read(nomF);
	assign (arch_int, nomF);
	rewrite(arch_int);
end;

procedure agregarDatos (var arch_int: arch_int);
var
	num: integer;
begin
	writeln('Ingrese un numero a agregar al Archivo');
	read(num);
	while num <> 30000 do begin
		write(arch_int, num);
		writeln('Ingrese un numero a agregar al Archivo');
		read(num);
	end;
	close(arch_int);
end;

var
	archNum: arch_int;
	nomF: string[20];
begin
	crearArch(archNum, nomF);
	agregarDatos(archNum);
end.
