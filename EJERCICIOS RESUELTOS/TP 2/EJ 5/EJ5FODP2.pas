program ej5p2fod;

const
    dimF = 3;
    valorAlto = 9999;

type
    direccion_detallada = record
        nro_calle: integer;
        piso: integer;
        depto: integer;
        ciudad: string;
    end;
    nacimientoD = record
        nro_partida: integer;
        nombre: string;
        apellido: string;
        direccion: direccion_detallada;
        matricula_dr: integer;
        nombre_madre: string;
        apellido_madre: string;
        dni_madre: integer;
        nombre_padre: string;
        apellido_padre: string;
        dni_padre: integer;
    end;
    fallecimientoD = record
        nro_partida: integer;
        dni: integer;
        nombre: string;
        apellido: string;
        matricula_dr: integer;
        fecha: integer;
        hora: integer;
        lugar: string;
    end;
    registro_maestro = record
        nro_partida: integer;
        dni: integer;
        nombre: string;
        apellido: string;
        direccion: direccion_detallada;
        matricula_dr: integer;
        nombre_madre: string;
        apellido_madre: string;
        dni_madre: integer;
        nombre_padre: string;
        apellido_padre: string;
        dni_padre: integer;
        fecha: integer;
        hora: integer;
        lugar: string;
        fallecio: boolean;
    end;
    detalle_nacimiento = file of nacimientoD;
    detalle_fallecimiento = file of fallecimientoD;
    array_nacimiento = array[1..dimF] of detalle_nacimiento;
    array_fallecimiento = array[1..dimF] of detalle_fallecimiento;
    registros_nacimientos = array[1..dimF] of nacimientoD;
    registros_fallecimientos = array[1..dimF] of fallecimientoD;
    maestro = file of registro_maestro;

procedure verBinarios(var dN: array_nacimiento; var dF: array_fallecimiento);
var
    aux1: nacimientoD;
    aux2: fallecimientoD;
    i: integer;
begin
    writeln ('==========================Nacimientos==========================');
    for i:= 1 to dimF do begin
        reset(dN[i]);
        while not eof(dN[i]) do begin
            read(dN[i], aux1);
            writeln('partida: ',aux1.nro_partida, ', nombre: ', aux1.nombre, ', apellido: ', aux1.apellido);
            writeln('direccion: (nro calle: ', aux1.direccion.nro_calle, ', piso: ', aux1.direccion.piso, ', depto: ', aux1.direccion.depto, ', ciudad: ', aux1.direccion.ciudad, ')');
            writeln('nombre madre: ', aux1.nombre_madre, ', apellido madre: ', aux1.apellido_madre, ', dni madre: ', aux1.dni_madre);
            writeln('nombre padre: ', aux1.nombre_padre, ', apellido padre: ', aux1.apellido_padre, ', dni padre: ', aux1.dni_padre);
            writeln('matricula dr: ', aux2.matricula_dr)
        end;
        close(dN[i]);
        writeln('----------------------------------------------------------------');
    end;
        writeln ('=================Fallecimientos================');
    for i:= 1 to dimF do begin
        reset(dF[i]);
        while not eof(dF[i]) do begin
            read(dF[i], aux2);
            writeln('partida: ',aux2.nro_partida, ', nombre: ', aux2.nombre, ', apellido: ', aux2.apellido);
            writeln('lugar: ', aux2.lugar, ', fecha: ', aux2.fecha, ', hora: ', aux2.hora);
            writeln('matricula dr: ', aux2.matricula_dr)
        end;
        close(dF[i]);
        writeln('-----------------------------------------------');
    end;
end;

procedure crearDetalles (var dN: array_nacimiento; var dF: array_fallecimiento);
var
    i: integer;
    istring: string;
    textoN, textoF: Text;
    regN: nacimientoD;
    regF: fallecimientoD;
begin
    for i:= 1 to dimF do begin
        str (i, istring);
        assign (dN[i], 'detalle_nacimiento' + istring + '.bin');
        assign (dF[i], 'detalle_fallecimiento' + istring + '.bin');
        assign (textoN, 'detalleNacimiento' + istring + '.txt');
        assign (textoF, 'detalleFallecimiento' + istring + '.txt');
        rewrite (dN[i]);
        rewrite (dF[i]);
        reset (textoN);
        reset (textoF);
        while not eof(textoN) do begin
            with regN do begin
                readln (textoN, nombre);
                readln (textoN, apellido);
                readln (textoN, nro_partida, direccion.nro_calle, direccion.piso, direccion.depto, direccion.ciudad);
                readln (textoN, matricula_dr, dni_madre, dni_padre);
                readln (textoN, nombre_madre);
                readln (textoN, apellido_madre);
                readln (textoN, nombre_padre);
                readln (textoN, apellido_padre);
                write(dN[i], regN);
            end;
        end;
        while not eof(textoF) do begin
            with regF do begin
                readln (textoF, nombre);
                readln (textoF, apellido);
                readln (textoF, nro_partida, dni, lugar);
                readln (textoF, matricula_dr, fecha, hora);
                write(dF[i], regF);
            end;
        end;
        close(dN[i]);
        close(dF[i]);
        close(textoN);
        close(textoF);
    end;
end;

procedure merge (var dN: array_nacimiento; var dF: array_fallecimiento; var master: maestro);

    procedure leerN (var N: detalle_nacimiento; var regN: nacimientoD);
    begin
        if not eof(N) then 
            read(N, regN)
        else
            regN.nro_partida:= valorAlto;
    end;

    procedure leerF (var F: detalle_fallecimiento; var regF: fallecimientoD);
    begin
        if not eof(F) then 
            read(F, regF)
        else
            regF.nro_partida:= valorAlto;
    end;

    procedure leerTodos (var N: array_nacimiento; var regsN: registros_nacimientos; var F: array_fallecimiento; var regsF: registros_fallecimientos);
    var
        i: integer;
    begin
        for i:= 1 to dimF do begin
            reset(N[i]); reset(F[i]);
            read(N[i], regsN[i]); read(F[i], regsF[i]);
        end;
    end;

    procedure minimoNacimiento (var regsN: registros_nacimientos; var d: array_nacimiento; var min: nacimientoD);
    var
        i, pos: integer;
    begin
        min.nro_partida:= valorAlto;
        for i:=1 to dimF do begin
            if (regsN[i].nro_partida < min.nro_partida) then begin
                min:= regsN[i];
                pos:= i;
            end;
        end;
        if (min.nro_partida <> valorAlto) then begin
            min:= regsN[pos];
            leerN(d[pos], regsN[pos]);
        end;
    end;

    procedure minimoFallecimiento (var regsF: registros_fallecimientos; var d: array_fallecimiento; var min: fallecimientoD);
    var
        i, pos: integer;
    begin
        min.nro_partida:= valorAlto;
        for i:=1 to dimF do begin
            if (regsF[i].nro_partida < min.nro_partida) then begin
                min:= regsF[i];
                pos:= i;
            end;
        end;
        if (min.nro_partida <> valorAlto) then begin
            min:= regsF[pos];
            leerF(d[pos], regsF[pos]);
        end;
    end;

var
    minN: nacimientoD;
    minF: fallecimientoD;
    regsN: registros_nacimientos;
    regsF: registros_fallecimientos;
    regM: registro_maestro;
    i: integer;
begin
    assign (master, 'master.bin');
    rewrite(master);
    leerTodos (dN, regsN, dF, regsF);
    minimoNacimiento (regsN, dN, minN);
    minimoFallecimiento (regsF, dF, minF);
    while (minN.nro_partida <> valorAlto) do begin
        if (minN.nro_partida <> minF.nro_partida) then
            regM.fallecio:= False
        else begin
            with regM do begin
                fallecio:= True;
                matricula_dr:= minF.matricula_dr;
                fecha:= minF.fecha;
                hora:= minF.hora;
                lugar:= minF.lugar;
            end;
            minimoFallecimiento(regsF, dF, minF);
        end;
        with regM do begin
            nro_partida:= minN.nro_partida;
            nombre:= minN.nombre;
            apellido:= minN.apellido;
            direccion.nro_calle:= minN.direccion.nro_calle;
            direccion.piso:= minN.direccion.piso;
            direccion.depto:= minN.direccion.depto;
            direccion.ciudad:= minN.direccion.ciudad;
            matricula_dr:= minN.matricula_dr;
            nombre_madre:= minN.nombre_madre;
            apellido_madre:= minN.apellido_madre;
            dni_madre:= minN.dni_madre;
            nombre_padre:= minN.nombre_padre;
            apellido_padre:= minN.apellido_padre;
            dni_padre:= minN.dni_padre;
        end;
        write(master, regM);
        minimoNacimiento(regsN, dN, minN);
    end;
    for i:= 1 to dimF do begin
        close(dN[i]); close(dF[i]);
    end;
    close(master);
end;

procedure mostrarMaestro (var m: maestro);
var
    aux: registro_maestro;
begin
    reset(m);
    writeln('=============================MAESTRO============================');
    while not eof(m) do begin
        read(m, aux);
        writeln('partida: ',aux.nro_partida, ', nombre: ', aux.nombre, ', apellido: ', aux.apellido);
        writeln('direccion: (nro calle: ', aux.direccion.nro_calle, ', piso: ', aux.direccion.piso, ', depto: ', aux.direccion.depto, ', ciudad: ', aux.direccion.ciudad, ')');
        writeln('nombre madre: ', aux.nombre_madre, ', apellido madre: ', aux.apellido_madre, ', dni madre: ', aux.dni_madre);
        writeln('nombre padre: ', aux.nombre_padre, ', apellido padre: ', aux.apellido_padre, ', dni padre: ', aux.dni_padre);
        writeln('matricula dr: ', aux.matricula_dr);
        if aux.fallecio then
            writeln('fallecio: ', aux.fallecio,', lugar: ', aux.lugar, ', fecha: ', aux.fecha, ', hora: ', aux.hora)
        else
            writeln('No fallecio.');
        writeln('---------------------------------------------------------------');
    end;
    close(m);
end;

procedure exportacion (var m: maestro);
var
    texto: Text;
    aux: registro_maestro;
begin
    reset(m);
    assign(texto, 'personas.txt');
    rewrite(texto);
    while not eof(m) do begin
        read(m, aux);
        with aux do begin
            writeln(texto,' ', nombre);
            writeln(texto,' ', apellido);
            writeln(texto,' ', dni,' ', nro_partida,' ', dni_madre,' ', dni_padre,' ', direccion.nro_calle,' ', direccion.piso,' ', direccion.depto, ' ',direccion.ciudad,' ', fecha, ' ', hora, ' ', lugar);
            writeln(texto, ' ', nombre_madre);
            writeln(texto,' ', apellido_madre);
            writeln(texto,' ', nombre_padre);
            writeln(texto,' ', apellido_padre);
            writeln(texto,' ', fallecio);
        end;
    end;
end;


var
    nacimientos: array_nacimiento;
    fallecimientos: array_fallecimiento;
    master: maestro;
begin
    crearDetalles(nacimientos, fallecimientos);
    verBinarios(nacimientos, fallecimientos);
    merge(nacimientos, fallecimientos, master);
    mostrarMaestro(master);
    exportacion(master);
end.