program EJ2FOD;

type
	arch_int = file of integer;
	nombre = string[20];
	
procedure asignacion (var arch: arch_int; var nomF: nombre);
begin
	writeln ('Ingrese el nombre del archivo que dese abrir');
	read (nomF);
	Assign (arch, nomF);
end;

procedure recorrido (var arch: arch_int);
var
	menores, cant, suma, dato: integer;
	prom: real;
begin
	reset(arch);
	menores:= 0;
	cant:= 0;
	suma:= 0;
	while not eof(arch) do begin
		read(arch, dato);
		if dato < 1500 then
			menores:= menores + 1;
		cant:= cant + 1;
		suma:= suma + dato;
	end;
	prom:= suma/cant;
	writeln ('La cantidad de datos menores a 1500 es de: ', menores);
	writeln ('El promedido de los datos es de: ', prom:2:1);
	close(arch);
end;

procedure impresion (var arch: arch_int);
var
	dato: integer;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch, dato);
		writeln (dato);
	end;
	close(arch);
end;

var
	arch: arch_int;
	nomF: nombre;
begin
	asignacion(arch, nomF);
	recorrido(arch);
	impresion(arch);
end.
