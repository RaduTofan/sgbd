--exemplu de cursor implicit
set serveroutput on
declare v_rez number(3);
begin
delete from rand_comenzi
where id_produs in(3133,2400);
v_rez:=sql%rowcount;
if sql%notfound
then
dbms_output.put_line('Nu au fost sterse inregistrari');
else
dbms_output.put_line('Au fost sterse '||v_rez||' inregistrari');
end if;
end;
/
rollback; --ca sa nu ramanem cu cele 14 inregistrari sterse;
begin
update rand_comenzi
set cantitate=100
where id_produs=5000;
if sql%found 
then
dbms_output.put_line(sql%rowcount);
else
dbms_output.put_line('Nu au fost efectuate modificari in baza de date');
end if;
end;
/
--exemplu de cursor explicit
declare
cursor c is select id_produs,denumire_produs,pret_min
from produse where lower(categorie)like 'software%';
v_id produse.id_produs%type;
v_den produse.denumire_produs%type;
v_pm produse.pret_min%type;
begin
dbms_output.put_line('Produse din categoria software sunt: ');
open c;
loop
fetch c into v_id,v_den,v_pm;
exit when c%notfound;
dbms_output.put_line(v_id||'Produsul '||v_den||' are pret minim'||v_pm);
end loop;
close c;
end;
/
--cursorul este mai eficient ca un for,while,select etc., acceseaza baza de date doar o singura data, in timp ce for,while,select etc. acceseaza baza de date de fiecare data
--cu un cursor se pot sterge toate tabelel deodata
--EXEMPLU
declare
cursor c is select * from user_tables; --user tables - ne arata toate tabele din schema proprie
r c%rowtype;
begin
open c;
loop
fetch c into r;
exit when c%notfound;
execute immediate 'drop table '||r.table_name||' cascade constraints';
end loop;
close c;
end;
/

declare
cursor c is select id_departament, a.nr_dep/b.nr_tot*100 proc_nr, 
a.sal_dep/b.sal_tot*100 proc_sal
from(select id_departament,count(id_angajat) nr_dep,
sum(salariul) sal_dep
from angajati group by id_departament) a,
(select count from (id_angajat) nr_tot, sum(salariul) sal_tot
from angajati) b;




