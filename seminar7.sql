set serveroutput on
create or replace function f_nume(p_id angajati.id_angajat%type) --antetul functiei, p_id - parametrul pt id
return varchar2
is
v_nume angajati.nume%type;
begin
select nume into v_nume from angajati where id_angajat=p_id;
return v_nume;
exception
when no_data_found then
return null;
end;
/

select f_nume(100) from dual;
select f_nume(id_angajat) from angajati;

declare
v_rez varchar2(50);
begin
if f_nume(1020) is null then
dbms_output.put_line('Angajatul nu exista');
else
v_rez:=f_nume(1020);
dbms_output.put_line('Numele angajatului este '||v_rez);
end if;
end;
/

--daca facem schimbare in functie, trebuie neaparat sa o compilam din nou inainte de a o apela

declare
cursor c is select * from angajati where id_departament =80;
r c%rowtype;
begin
open c;
loop
fetch c into r;
exit when c%notfound;
dbms_output.put_line(f_nume(r.id_angajat));  --prin apelul functiei afisam numele tuturor angajatilor din departamentul 80
end loop;
close c;
end;
/

execute dbms_output.put_line(f_nume(110));


--pt a rula urmatoarele 3 linii de cod, le selectam cu mouse-ul si apasam f9
variable g varchar2
execute :g:=f_nume(111); --numaidecat spatiu intre execute si :g:
print g


create or replace function f_modsal(p_id number, p_co number)
return number
is
v_sal angajati.salariul%type;
begin
update angajati
set salariul = salariul*p_co
where id_angajat = p_id;
select salariul into v_sal from angajati where id_angajat = p_id;
return v_sal;
end;
/

select f_modsal(id_angajat,0.9) from angajati; -- ne da mesaj de eroare

begin
dbms_output.put_line('Salariul curent este '||f_modsal(110,1.2));
end;
/

rollback;


-- o functie prin care sa afisam numarul de functii detinute anterior de un angajat

create or replace function f_functie(p_id number)
return number
is 
v_nr number(2);
v_id angajati.id_angajat%type;
begin
select id_angajat into v_id from angajati where id_angajat = p_id;
select count(id_functie) into v_nr from istoric_functii where id_angajat=p_id;
return v_nr;
exception
when no_data_found then
return null;

end;
/

select nume,f_functie(id_angajat) from angajati;

select f_functie(1000) from dual;



begin
if f_functie(102) is null then
dbms_output.put_line('Angajatul nu exista');
else
dbms_output.put_line(f_functie(1000));
end if;
end;
/


--functie care calculeaza diferentiat impozitul pe salariul in functie de nivelul acestuia

create or replace function f_impozit(p_sal number)
return number
is 
e_exception exception;
begin
case when p_sal <= 0 then
raise e_exception;
when p_sal<5000 then
return p_sal*0.16;
when p_sal between 5000 and 10000 then
return p_sal*0.21;
else return p_sal*0.23;
end case;
exception
when e_exception then
return null;
end;
/

select id_departament, sum(f_impozit(salariul)) from angajati
group by id_departament order by 2 desc;

begin
dbms_output.put_line('Impozitul este '||f_impozit(100));
end;
/

-- functie care sa calculeze valoarea tva-ului, functie cu mai multi parametri

create or replace function f_tva(p_id number, p_val number, p_t1 number, p_t2 number, p_t3 number)
return number
is
v_cat produse.categorie%type;
begin
select categorie into v_cat from produse where id_produs = p_id;
if v_cat like '%hardware%' then
return p_val*p_t1;
elsif v_cat like '%software%' then
return p_val*p_t2;
else return p_val*p_t3;
end if;
end;
/


select id_produs,f_tva(id_produs,cantitate*pret, 0.19,0.09,0.05) as "Valoare TVA" from rand_comenzi;




