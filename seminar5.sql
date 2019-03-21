--A doua forma a cursorului
--curosrul anonim
--curosr cu parametru
--cursori imbviati
--cursori cu clauza for update
-- a doua forma de scriere a cursorului este mai simpla, prima mai explicita
set serveroutput on

declare
cursor c is select * from clienti where starea_civila='single'
order by limita_credit desc;
r c%rowtype;
begin
dbms_output.put_line('Lista clientilor necasatoriti:');
open c;
loop 
fetch c into r;
exit when c%notfound;
if r.limita_credit > 3000 then 
dbms_output.put_line('Clientul '||r.nume_client||' are limita credit '||r.limita_credit);
end if;
end loop;
close c;
end;
/

--does the exact same thing:
declare
cursor c is select * from clienti where starea_civila='single'
order by limita_credit desc;
--r c%rowtype;
begin
dbms_output.put_line('Lista clientilor necasatoriti:');
--open c;
for r in c loop
--fetch c into r;
--exit when c%notfound;
if r.limita_credit > 3000 then 
dbms_output.put_line('Clientul '||r.nume_client||' are limita credit '||r.limita_credit);
end if;
end loop;
--close c;
end;
/


--cursor anonim: care n-are nume
begin 
for r in (select nr_comanda, sum(pret*cantitate) val
from rand_comenzi group by nr_comanda) loop
dbms_output.put_line('Comanda '||r.nr_comanda||' are valoarea '||r.val);
end loop;
end;
/

--cursorii cu parametru sunt foarte utilizati. permit utilizarea unui parametru sau a mai multor parametri. la rulare rezultatul va fi diferit
declare
cursor c (p_nr number) is select nr_comanda, count(id_produs) nr
from rand_comenzi group by nr_comanda having count(id_produs)>p_nr
order by 2;
r c%rowtype;
begin
open c(&p); --aici punem ce valoarea vrem, %p pt a introduce de fiecare data ce valoarea vrem, putem pune 10, 8 etc. whatever wefackinwant;
loop 
fetch c into r;
exit when c%notfound;
dbms_output.put_line('Comanda '||r.nr_comanda||' contine '||r.nr||' produse');
end loop;
close c;
end;
/

--SA SE CREEZE UN CURSOR (CU PARAMETRI) IN CARE SA AFISAM ANGAJATII DINTR-UN ANUMIT DEPARTAMENT (PRIMIT CA PARAMETRU) SI CARE AU UN ANUMIT SALARIU (PRIMIT CA PARAMETRU);

declare
cursor c is select * from departamente;
cursor c1(p_id number) is select * from angajati where id_departament = p_id;
--c1 se va deschide pentru fiecare id de departament
r c%rowtype;
r1 c1%rowtype;
begin
open c;
loop
fetch c into r;
exit when c%notfound;
dbms_output.put_line('In departamentul '||r.denumire_departament||' lucreaza: ');
open c1(r.id_departament);
loop
fetch c1 into r1;
exit when c1%notfound;
dbms_output.put_line('Angajatul '||r1.nume);
end loop;
close c1;
dbms_output.put_line('-------------------------');
end loop;
close c;
end;
/
-- for update- asigura accesul concurent la date; blocheaza pentru un anumit timp accesul la baza de date in bazele de date in care au acces mai multi utilizatori in acelasi timp 

declare cursor c is select * from rand_comenzi for update of pret;
r c%rowtype;
v_rez number(3):=0;
begin
open c;
loop
fetch c into r;
exit when c%notfound;
if r.cantitate >50 then
update rand_comenzi
set pret = pret*0.9
where id_produs = r.id_produs;
--se mai poate scrie: where current of c;
v_rez:=v_rez+1;
end if;
end loop;
dbms_output.put_line('Au fost actualizate '||v_rez||' inregistrari');
close c;
end;
/

--cu ajutorul unui cursor putem elimina duplicatele dintr-o BD
create table clienti2 as select * from clienti;
insert into clienti2  select * from clienti;
--^ am create o tabela clona pentru clienti
select count(*) from clienti2;

declare cursor c is select * from clienti2 order by id_client for update;
r c%rowtype;
r_old c%rowtype;
begin
open c;
fetch c into r_old;
loop 
fetch c into r;
exit when c%notfound;
if r_old.id_client = r.id_client then
delete from clienti2
where current of c;
end if;
r_old:=r;
end loop;
close c;
end;
/


