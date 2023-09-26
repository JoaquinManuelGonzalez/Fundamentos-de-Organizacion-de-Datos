program ej10p2fod;

const
    dimF = 15;
    valorAlto = 999;

type
    empleado = record
        departamento: integer;
        division: integer;
        num_empleado: integer;
        categoria: integer;
        cant_horas: integer;
    end;
    monto_hora = record
        categoria: integer;
        monto: real;
    end;
    montos = array[1..dimF] of real;
    maestro = file of empleado;

procedure asignacion(var m: maestro);
begin
    assign(m, 'empleados.bin');
end;

procedure cargarMontos (var m: montos);
var
    texto: Text;
    aux: monto_hora;
begin
    assign(texto, 'montos.txt');
    reset(texto);
    while not eof(texto) do begin
        with aux do readln(texto, categoria, monto);
        m[aux.categoria]:= aux.monto;
    end;
    close(texto);
end;

procedure crearBin (var m: maestro);
var
    texto: Text;
    aux: empleado;
begin
    assign(texto, 'empleados.txt');
    assign(m, 'empleados.bin');
    reset(texto);
    rewrite(m);
    while not eof(texto) do begin
        with aux do readln (texto, departamento, division, categoria, num_empleado, cant_horas);
        write(m, aux)
    end;
    close(texto);
    close(m);
end;

procedure leer (var m: maestro; var e: empleado);
begin
    if not eof(m) then
        read(m, e)
    else
        e.departamento:= valorAlto;
end;

procedure formato (var m: maestro; monto: montos);
var
    total_horas_emp, total_horas_div, total_horas_depto: integer;
    emp, act: empleado;
    monto_a_cobrar, total_division, total_depto: real;
begin
    reset(m);
    leer(m, emp);
    while emp.departamento <> valorAlto do begin
        total_horas_depto:= 0; total_depto:= 0;
        act.departamento:= emp.departamento;
        writeln('Departamento: ', act.departamento);
        writeln('');
        while emp.departamento = act.departamento do begin
            act.division:= emp.division;
            total_division:= 0; total_horas_div:= 0;
            writeln('Division: ', act.division);
            writeln('');
            while (emp.departamento = act.departamento) and (emp.division = act.division) do begin
                act.num_empleado:= emp.num_empleado;
                total_horas_emp:= 0; monto_a_cobrar:= 0;
                while  (emp.departamento = act.departamento) and (emp.division = act.division) and (emp.num_empleado = act.num_empleado) do begin
                    total_horas_emp:= total_horas_emp + emp.cant_horas;
                    leer(m, emp);
                end;
                monto_a_cobrar:= monto[emp.categoria] * total_horas_emp;
                writeln('Numero de empleado: ', act.num_empleado, '. Total de horas: ', total_horas_emp, '. Importe a cobrar: $', monto_a_cobrar:5:2);
                total_division:= total_division + monto_a_cobrar;
                total_horas_div:= total_horas_div + total_horas_emp;
            end;
            total_depto:= total_depto + total_division;
            total_horas_depto:= total_horas_depto + total_horas_div;
            writeln('');
            writeln('Total de horas division: ', total_horas_div);
            writeln('Monto total por division: $', total_division:5:2);
            writeln('');
        end;
        writeln('Total horas departamento: ', total_horas_depto);
        writeln('Monto total departamento: $', total_depto:5:2);
        writeln('');
    end;
    close(m);
end;


var
    m: maestro;
    monto: montos;
begin
    cargarMontos(monto);
    //crearBin(m);
    asignacion(m);
    formato(m, monto);
end.