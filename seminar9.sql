/*
Seminar 9

TRIGGERI

Sunt niste blocuri PL/SQL stocabile in BD, la fel ca tabelele, procedurile, functiile.
Spre deosebire de proceduri si functii pe care le utlizam prin apel, triggeri se declanseaza automat, in anumite conditii, in functie de tipul de trigger.
Triggerul poate fi o extensie a restirctiilor de integritate.
Triggerul accepta declare, daca este nevoie.

1. Triggeri la nivelul BD
    - oprire/pornire server
2. Triggeri asociati tabelei virtuale
    - se declanseaza la comenzi de manipulare a datelor (update, insert, delete)
    
Putem avea triggeri care au rolul de:
    - informare
    - care sa impiedice anumite operatii
    - care ajuta la tinerea evidentei unei activitati
    - care sa genereze valori unice pt coloanele care sunt pk sau unique
    - care sa amplifice controlul datelor

*/

--exemplu, trigger de informare
create or replace trigger t_adauga 
after insert on departamente
begin
a('s-au adaugat inregistrari in departamente');
end;
/
set serveroutput on

insert into departamente (id_departament, denumire_departament)
values (600, 'dep_nou');
rollback;

create or replace trigger t_stergere
before delete on departamente
begin
raise_application_error(-20000, 'nu pot fi sterse inregistrari');
end;
/

delete from departamente;

--mai putem folosi INSERTING, UPDATING, DELETING

create table evenim (tip_modif char(1), utilizator varchar2(50), data timestamp);

create or replace trigger t_modif
after insert or update or delete on produse
declare
v_tip evenim.tip_modif%type;
begin
if inserting then v_tip:='I';
elsif updating then v_tip:='U';
else v_tip:='D';
end if;
insert into evenim values (v_tip, user, sysdate);
end;
/

select * from evenim;

insert into produse (id_produs, denumire_produs) values (1000, 'produs_nou');

delete from produse where id_produs = 1000;

select * from angajati;
select * from functii;

--daca ne uitam in tabela functii, angajatul cu id 100 are salariu maxim 40000, dar daca ii facem update oricum sare peste

update angajati set salariul = 40001
where id_angajat = 100;

rollback;
 
--astfel, cream trigger pt a controla acest lucru

create or replace trigger  t_sal
before insert or update on angajati
for each row
declare
v_max functii.salariu_max%type;
v_min functii.salariu_min%type;
begin
select salariu_min, salariu_max into v_min, v_max from functii
where id_functie = :new.id_functie;
if :new.salariul>v_max then
raise_application_error (-20000,'salariul este mai mare dacat val max sau salariul nu corespunde functiei');
end if;
if :new.salariul<v_min then
raise_application_error (-20000,'salariul este mai mic dacat val min sau salariul nu corespunde functiei');
end if;
end;
/

create or replace trigger t_sal1
before update on angajati
for each row
when(old.salariul>7000 or old.comision is null)
begin
if:new.salariul>:old.salariul+1000 then
:new.salariul:=old.salariul+1000;
end if;
if:new.salariul>1500 then
:new.salariul:15000;
end if;
end;
/

select * from angajati;

update angajati 
set salariul = 10001
where id_angajat=104;

rollback;

--vom crea un trigger prin care vom adauga valori unice pentru coloana de tipul id

create sequence sec start with 1 increment by 1 maxvalue 1000 nocycle;

create or replace trigger t_sec
before insert on produse
for each row
begin
select sec.nextval into :new.id_produs from dual;
end;
/

select * from produse;
insert into produse (id_produs, denumire_produs) values (1001, 'desktop');
select * from evenim;

create or replace view v_rc as select id_produs, nr_comanda, pret*cantitate valoare
from rand_comenzi;

select * from v_rc;
select * from rand_comenzi;

update v_rc set valoare =1 where id_produs = 3117 and nr_comanda = 2381; --acest lucru nu este posibil pt ca nu exista un corespondent intre coloane si valorile date;

---update-ul prin valoare poate fi posibil insa printr-un trigger

create or replace trigger t_val
instead of update on v_rc
for each row
begin
if updating ('VALOARE') then --cu majuscule deoarece asa este stocat in dictionarul BD
update rand_comenzi
set cantitate = cantitate +1
where id_produs=:new.id_produs
and nr_comanda = :new.nr_comanda;
end if;
end;
/