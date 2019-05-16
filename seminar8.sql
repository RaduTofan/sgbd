/*
Seminar 8

PROCEDURI

Au parametri de tip IN si OUT.
Se creeaza si se sterge ca orice obiect.
Se apeleaza in mai multe feluri, in functie de tipul parametrilor.

*/


create or replace procedure a(p_sir varchar2) --procedura de inlocuire a dbms output
is
begin
dbms_output.put_line(p_sir);
end;
/
set serveroutput on
execute a('test');


--procedure cu care vom modifica salariul unui angajat
create or replace procedure modsal(p_id angajati.id_angajat%type default 101,
 p_procent number default 5,p_errcode out number)
is
exc exception;
exc1 exception;
begin
if p_procent not between -30 and 50 then
raise exc;
else
update angajati
set salariul=salariul*(1+p_procent/100)
where id_angajat = p_id;
end if;
if sql%rowcount =0 then
raise exc1;
end if;
exception when exc1 then
p_errcode:=1;
when exc then
p_errcode:=2;
end;
/

select * from angajati;
update angajati
set salariul=20000
where id_angajat =101;
--am pus salariul 20000 ca sa avem toti in sala salariul 20000 pt id 101, la toti era diferit;
execute modsal(101,10);

--diminuam cu 10% salariul pt angajat 101:
execute modsal(101,-10);


--default
execute();

execute modsal(p_procent=>15,p_id=>101);
select * from angajati;

begin
modsal (101,26);
end;
/

declare v_nr number(1);
begin
modsal (1010,60,v_nr);
if v_nr=1 then
a('Angajatul nu exista!');
elsif v_nr=2 then 
a('Procentul pentru modificarea salariului este in afara limitelor -30..50%!');
end if;
end;
/


create or replace procedure cauta_ang(p_id angajati.id_angajat%type,
p_nume out varchar2, p_vechime out number)
is 
begin
select nume, round(months_between(sysdate, data_angajare)/12,0) 
into p_nume, p_vechime
from angajati where id_angajat=p_id;
exception when no_data_found then
a('nu exista angajatul');
end;
/

declare
v_nume angajati.nume%type;
v_vechime number(2);
begin cauta_ang(1010, v_nume,v_vechime);
a(v_nume);
a(v_vechime);
end;
/

create or replace procedure sal_med(p_sal out number, p_id number) --p_sal parametru salariul de iesire, p_id id departamentului in care sa calc avg pt salariu
is
v_id number(3);
begin
select id_departament into v_id from departamente where id_departament = p_id;
select avg(salariul) into p_sal from angajati 
where id_departament = p_id;
exception when no_data_found then
a('Departamentul nu exista!');
end;
/

declare
v_sal angajati.salariul%type;
begin
sal_med(v_sal,1000);
a(v_sal);
end;
/

create or replace procedure eval (p_io in out number)
is
begin
if p_io <=10000 then
p_io:=p_io;
else
p_io:=p_io+100;
end if;
end;
/

declare
v_nr number(6):=&nr;
begin
eval(v_nr);
a(v_nr);
end;
/

create or replace procedure functie(p_id number, p_functie_noua in out varchar2)
is
v_functie_actuala angajati.id_functie%type;
cursor c is select id_angajat, id_functie from istoric_functii;
v_nr number(1);
begin
for r in c loop
select id_functie into v_functie_actuala from angajati where id_angajat = p_id;
if v_functie_actuala= r.id_functie then
v_nr:=1;
p_functie_noua:=v_functie_actuala;
end if;
end loop;
if v_nr is null then
update angajati
set id_functie = p_functie_noua
where id_angajat = p_id;
end if;
end;
/

select * from angajati;
select * from istoric_functii;
declare
v_fn angajati.id_functie%type:='&fn';
begin
functie(101,v_fn);
a(v_fn);
end;
/

create or replace function f_val(p_id number)
return number
is 
v_sum number(6);
begin
select sum(pret*cantitate) into v_sum from rand_comenzi
where id_produs = p_id;
return v_sum;
end;
/


create or replace procedure p_afis(p_val number)
is
cursor c is select * from produs where f_val(id_produs)>p_val;
r c%rowtype;
begin
open c;
loop
fetch c into r;
exit when c%notfound;
a(r.denumire_produs);
end loop;
if c%rowcount = 0
then a('nu exista astfel de produse');
end if;
close c;
end;
/

execute p_afis(10000);

execute p_afis(15000);







