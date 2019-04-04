/*exceptii- erori care duc la intreruperea executiei unui program. situatii anormale.
pot fi de mai multe feluri:
-predefinite, acestea au o denumire data de SGBD. sunt destul de des intalnite. ele nu necesita definite in sectiunea declare.
 	exemple: TOO_MANY_ROWS
		 NO_DATA_FOUND
		 ZERO_DIVIDE
		 INVALID_CURSOR
		 CURSOR_ALREADY_OPENED
		 DUP_VAL_ON_INDEX
-exceptii non-predefinite, care necesita definire sau declarare in sectiunea declare. Sunt invocate de catre SGBD si pot fi tratate in exception
-exceptii definite de utilizator.se definesc in declare, se invoca de catre utilizator. se trateaza in sectiunea exception.
Toate exceptiile se caracterizeaza printr-un cod si printr-un mesaj. Codul si mesajul pot fi determinate cu ajutorul SQLCODE, respectiv SQLERRM (sql error message)*/



--exemplu de NO_DATA_FOUND
set serverout on
declare
v_nume angajati.nume%type;
v_sal angajati.salariul%type;
begin
select nume, salariul into v_nume, v_sal
from angajati where nume = 'Smith'; -- Gigel pt not_found, Chen pt a afisa normal
dbms_output.put_line('Angajatul cu numele '||v_nume||' are salariul '||v_sal);
exception
when no_data_found then
dbms_output.put_line('Nu exista niciun angajat cu acest nume!!!');
when too_many_rows then
dbms_output.put_line('Exista mai multi angajati cu acest nume!');
when others then
dbms_output.put_line('A aparut o eroare!');
end;
/

declare cursor c is select nume, salariul from angajati where nume='Smith';
r c%rowtype;
begin
open c;
loop
fetch c into r; --incarcam din cursor in variabila r
exit when c%notfound;
dbms_output.put_line('Angajatul cu numele '||r.nume||' are salariul '||r.salariul);
end loop;
close c;
fetch c into r;
--open c;
exception
when cursor_already_open then
dbms_output.put_line('Cursorul este deja deschis');
end;
/


declare
e_adauga exception;
pragma exception_init(e_adauga, -02290);
v_cod number(6);
v_msg char(255);
begin 
insert into departamente (id_departament, denumire_departament) values (10, null);
exception
when e_adauga then
dbms_output.put_line('Denumirea departamentului nu poate fi nula!');
v_cod:=sqlcode;
v_msg:=sqlerrm;
insert into erori values (user,to_date('28.03.2018','dd.mm.yyyy'),v_cod,v_msg);
when dup_val_on_index then
dbms_output.put_line('ID-ul departamentului trebuie sa fie unic!!');
end;
/

drop table erori;
create table erori (utilizator varchar2(255),data date, cod number(6), mesaj varchar2(255));
select * from erori;


declare
e_stergere exception;
pragma exception_init(e_stergere, -02292);
v_cod number(6);
v_msg char(255);
begin
delete from produse;
exception
when e_stergere then
dbms_output.put_line('Nu pot fi sterse inregistrari!!');
v_cod:=sqlcode;
v_msg:=sqlerrm;
insert into erori values (user,to_date('28.03.2018','dd.mm.yyyy'),v_cod,v_msg);
end;
/

--RAISE
--RAISE_APPLICATION_ERROR
--   -20000   -20999

declare
e_exceptie exception;
begin
if to_number(to_char(sysdate,'HH24')) > 19 then
raise e_exceptie;
else
update angajati
set salariul = salariul *1.1;
end if;
exception
when e_exceptie then 
dbms_output.put_line('Operatie nepermisa in afara programului de lucru');
end;
/

create table stocuri as select id_produs from produse;
alter table stocuri add cantitate number(3);
select * from stocuri;
update stocuri
set cantitate = dbms_random.value(1,100);

declare
v_cant stocuri.cantitate%type;
v_cc number(3):=&cc; --cantitate comandata
v_id number(4):=&id;
e_exc exception;
pragma exception_init (e_exc, -20001);
v_cod number(6);
v_msg char(255);
begin
select cantitate into v_cant from stocuri where id_produs = v_id;
if v_cant < v_cc then
raise_application_error(-2000, 'Stoc insuficient');
else
update stocuri
set cantitate = cantitate - v_cc
where id_produs = v_id;
select cantitate into v_cant from stocuri where id_produs = v_id;
dbms_output.put_line('Stocul actual este '||v_cant);
end if;
exception
when e_exc then
v_cod:=sqlcode;
v_msg:=sqlerrm;
dbms_output.put_line('Stocul este insuficient!');
insert into erori values (user,to_date('28.03.2018','dd.mm.yyyy'),v_cod,v_msg);
end;
/

