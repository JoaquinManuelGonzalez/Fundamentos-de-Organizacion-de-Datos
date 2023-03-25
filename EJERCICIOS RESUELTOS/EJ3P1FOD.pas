program EJ3FOD;

type
	strings = string[20];
	empleados = record
		num : integer;
		apellido: strings;
		nombre: strings;
		edad: integer;
		dni: integer;
	end;
	arch_emp = file of empleados;


procedure menu (var arch: arch_emp; var nomF: strings; var creado: boolean);

	procedure asignacionText (var texto: Text; var nombreF: strings);
	begin
		writeln ('Ingrese el nombre del Archivo de texto: ');
		readln (nombreF);
		Assign (texto, nombreF);
	end;

	function otraOpcion (): integer;
	var
		otraop: integer;
	begin
		writeln ('Si desea realizar otra opcion escriba 1 y volvera al menu principal.');
		writeln ('Si desea salir escriba 2 y cerrara el menu.');
		readln (otraop);
		otraOpcion:= otraop;
	end;
	
	procedure imprimir (e: empleados);
	begin
		writeln (e.num);
		writeln (e.apellido);
		writeln (e.nombre);
		writeln (e.edad);
		writeln (e.dni);
	end;

	procedure asignacion (var arch: arch_emp; var nomF: strings);
	begin
		writeln ('Ingrese el nombre del archivo de Empleados');
		readln (nomF);
		Assign(arch, nomF);
	end;
	
	procedure leer (var e: empleados);
	begin
		writeln ('Ingrese el apellido del Empleado: ');
		readln(e.apellido);
		if (e.apellido <> 'fin') then begin
			writeln ('Ingrese el numero de Empleado: ');
			readln (e.num);
			writeln ('Ingrese el nombre del Empleado: ');
			readln (e.nombre);
			writeln ('Ingrese la edad del Empleado: ');
			readln (e.edad);
			writeln ('Ingrese el DNI del Empleado: ');
			readln (e.dni);
		end;
	end;

	procedure lectura (var arch: arch_emp; var nomF: strings;var creado:boolean);

	var
		e: empleados;
	begin
		rewrite(arch);
		leer(e);
		while e.apellido <> 'fin' do begin
			write(arch, e);
			leer(e);
		end;
		close(arch);
		creado:= true;
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;

	procedure busquedaNomOAp (var arch: arch_emp; var nomF: strings; var creado:boolean);

		function eleccion(): integer;
		var
			elecc: integer;
		begin
			writeln ('Si desea buscar los datos de los empleados por nombre, Ingrese 1. Si desea buscar los datos de los empleados por apellido, Ingrese 2.');
			readln(elecc);
			eleccion:= elecc;
		end;
	
	var
		texto: strings;
		e: empleados;
		existe: boolean;
	begin
		existe:= false;
		reset(arch);
		if eleccion() = 1 then begin
			writeln ('Ingrese el nombre que desea utilizar como parametro: ');
			readln(texto);
			while not eof(arch) do begin
				read(arch, e);
				if e.nombre = texto then begin
					imprimir (e);
					existe:= true;
				end;
			end;
			if not existe then
				writeln ('No existen empleados con ese nombre.');
		end else begin
			writeln ('Ingrese el apellido que desea utilizar como parametro: ');
			readln(texto);
			while not eof(arch) do begin
				read(arch, e);
				if e.apellido = texto then
					imprimir (e);
					existe:= true;
			end;
			if not existe then
				writeln ('No existen empleados con ese apellido.');
		end;
		close(arch);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;

	procedure deAUno (var arch: arch_emp; var nomF: strings; creado:boolean);
	var
		e: empleados;
	begin
		reset(arch);
		while not eof(arch) do begin
			read(arch, e);
			writeln('Nombre: ',e.nombre,' .Apellido: ', e.apellido, ' .DNI: ', e.dni, ' .Edad: ', e.edad, ' .Numero de Empleado: ', e.num);
		end;
		close (arch);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;

	procedure mayores(var arch: arch_emp; var nomF: strings; creado:boolean);
	var
		e: empleados;
		existe: boolean;
	begin
		existe:= false;
		reset (arch);
		while not eof(arch) do begin
			read(arch, e);
			if e.edad > 70 then begin
				imprimir(e);
				existe:= true;
			end;
		end;
		if not existe then
			writeln ('No existen empleados con mas de 70 años');
		close (arch);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;

	procedure aniadir (var arch: arch_emp; var nomF: strings;var creado: boolean);
	
		procedure agregar (var arch: arch_emp; e: empleados; var creado: boolean);
		var
			emp_arch: empleados;
			coincidencia: boolean;
		begin
			coincidencia:= false;
			reset (arch);
			while (not eof (arch) AND not coincidencia) do begin
				read (arch, emp_arch);
				if e.num = emp_arch.num then begin
					writeln ('Ya existe un empleado con ese numero.');
					coincidencia:= true;
				end;
			end;
			if not coincidencia then begin
				seek (arch, fileSize(arch));
				write (arch, e);
			end;
			close(arch);
			creado:= true;
		end;
		
	var
		e: empleados;
	begin
		asignacion(arch, nomF);
		leer(e);
		while e.apellido <> 'fin' do begin
			agregar (arch, e, creado);
			leer(e);
		end;
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;
			
	procedure edades (var arch: arch_emp; nomF: strings; creado: boolean);
	
		procedure seleccionCant (var selec: integer; var num: integer);
		begin
			writeln ('Ingrese un 1 si quiere modificar la edad de un solo empleado o un 2 si quiere modificar la edad de todos.');
			readln (selec);
			if selec = 1 then begin
				writeln ('Ingrese el numero del empleado al que quiere modificar su edad.');
				readln (num);
			end;
		end;
		
		procedure aUno (var arch: arch_emp; num: integer);
		var
			edadN: integer;
			e: empleados;
			existeEmp: boolean;
		begin
			existeEmp:= false;
			reset(arch);
			while (not eof(arch) AND not existeEmp) do begin
				read (arch, e);
				if e.num = num then begin
					existeEmp:= true;
					writeln ('Ingrese la nueva edad a insertar: ');
					readln (edadN);
					e.edad:= edadN;
					Seek (arch, filepos(arch) - 1);
					write(arch,e);
				end;
			end;
			if not existeEmp then
				writeln ('No existe empleado con el numero insertado');
			close(arch);
		end;
		
		procedure aTodos (var arch: arch_emp);
		var
			edadN: integer;
			e: empleados;
		begin
			reset(arch);
			while not eof(arch) do begin
				read(arch, e);
				writeln ('Ingrese la nueva edad a insertar: ');
				readln (edadN);
				e.edad:= edadN;
				Seek (arch, filepos(arch) - 1);
				write(arch,e);
			end;
			close(arch);
		end;
		
	var
		selec, num: integer;
	begin
		seleccionCant(selec, num);
		if selec = 1 then
			aUno(arch, num)
		else
			aTodos(arch);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;
	
	procedure exportarATexto (var arch: arch_emp; var nomF: strings; creado: boolean);
		
		procedure exportacion (var arch: arch_emp; var texto: Text);
		var
			e: empleados;
		begin
			reset (arch);
			rewrite (texto);
			while not eof(arch) do begin
				read (arch, e);
				with e do writeln (num:5, edad:5, dni:5, nombre:5);
				with e do writeln (apellido:5);
				with e do writeln(texto,'   ',num,'   ',edad,'   ',dni,'   ',nombre,'   ',apellido);
			end;
			close (arch);
			close (texto);
		end;
		
	var
		texto: Text;
		nombreF: strings;
	begin
		asignacionText (texto, nombreF);
		writeln ('¿De donde sacara la informacion?');
		asignacion (arch, nomF);
		exportacion (arch, texto);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;
		
	procedure exportarATextoDNI (var arch: arch_emp; var nomF: strings; creado: boolean);
	
		procedure exportacionDNI (var arch: arch_emp; var texto: Text);
		var
			e: empleados;
		begin
			reset (arch);
			rewrite (texto);
			while not eof (arch) do begin
				read (arch, e);
				if e.dni = 00 then begin
					with e do writeln (num:5, edad:5, dni:5, nombre:5);
					with e do writeln(apellido:5);
					with e do writeln(texto,'   ',num,'   ',edad,'   ',dni,'   ',nombre,'   ',apellido);
				end;
			end;
			close (arch);
			close (texto);
		end;
	
	var
		nombreF: strings;
		textoDNI: Text;
	begin
		asignacionText(textoDNI, nombreF);
		writeln ('Elija el Archivo del que quiere extraer la informacion');
		asignacion (arch, nomF);
		exportacionDNI(arch, textoDNI);
		if otraOpcion() = 1 then
			menu(arch, nomF, creado);
	end;
var
	opcion: char;
begin
	writeln ('Ingrese el caracter necesario para realizar las siguientes acciones: ');
	writeln ('A. Creacion de archivo de empleados.');
	writeln ('B. Listar en pantalla los datos de empleados que tengan un nombre o apellido especifico.');
	writeln ('C. Listar en pantalla los empleados de auno por linea de texto.');
	writeln ('D. Listar en pantalla los datos de los empleados proximos a jubilarse.');
	writeln ('E. Aniadir uno o mas empleados al final de un archivo ya creado.');
	writeln ('F. Modificar edad de uno o mas empleados.');
	writeln ('H. Exportar la informacion de un archivo binario de empleados a uno de texto.');
	writeln ('I. Exportar a un archivo de texto la informacion de los empleados con DNI nulo, es decir, 00');
	writeln ('Q. Salir del menu.');
	readln (opcion);
	case opcion of
		'A': begin
			asignacion (arch, nomF);
			lectura (arch, nomF, creado);
		end;
		'B': begin
			if creado then
				busquedaNomOAp (arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'C': begin
			if creado then
				deAUno (arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'D': begin
			if creado then
				mayores (arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'E': aniadir(arch, nomF, creado);
		'F': begin
			if creado then
				edades(arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'H': begin
			if creado then
				exportarATexto(arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'I': begin
			if creado then
				exportarATextoDNI(arch, nomF, creado)
			else begin
				writeln ('No es posible realizar la accion debido a que no se creo un Archivo.');
				if otraOpcion() = 1 then
					menu(arch, nomF, creado);
			end;
		end;
		'Q': writeln ('Ha salido con exito.');
	end;
end;

var
	arch: arch_emp;
	nomF: strings;
	creado: boolean;
begin
	creado:= false;
	menu (arch, nomF, creado);
end.
