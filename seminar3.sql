set serveroutput on
declare
v_cant rand_comenzi.cantititate%type;
v_pret rand_comenzi.pret%type;
begin
select cantitate, pret into v_cant, v_pret from rand_comenzi
where id_produs = 240;
dbms_output.put_line('Cantitatea si pretul sunt: '|| v_cant||' '||v_pret);
if v_cant <10 then v_pret:=v_pret*0.9;
elsif v_cant between 10 and 20 then v_pret:=v_pret*0.95;
else v_pret:=v_pret*0.98;
end if;
dbms_output.put_line('Pretul final este: '||v_pret);
end;
/

set serveroutput on
declare
v_cant rand_comenzi.cantititate%type;
v_pret rand_comenzi.pret%type;
v_p number(4,2);
begin
select cantitate, pret into v_cant,v_pret from rand_comenzi
where id_produs = 2400;
dbms_output.put_line('Cantitatea si pretul sunt: '|| v_cant||' '||v_pret);
v_p:= case when v_cant <10 then 0.9
when v_cant between 10 and 20 then 0.95
else 0.98 end;
v_pret:=v_p;
dbms_output.put_line('Pretul final este: '||v_pret);
end;
/


set serveroutput on
declare
v_cant rand_comenzi.cantititate%type;
v_pret rand_comenzi.pret%type;
begin
select cantitate, pret into v_cant,v_pret from rand_comenzi
where id_produs = 2400;
dbms_output.put_line('Cantitatea si pretul sunt: '|| v_cant||' '||v_pret);
case when v_cant <10 then v_pret:=v_pret*0.9;
when v_cant between 10 and 20 then v_pret:=v_pret*0.95;
else v_pret:=v_pret*0.98;
end case;
dbms_output.put_line('Pretul final este: '||v_pret);
end;
/



-- Sa se afiseze angajatii al caror salariu este mai mare decat salariul mediu
declare
v_sal angajati.salariul%type;
v_sm v_sal%type;
i number(3):=100;
begin
select avg(salariul) into v_sm from angajati;
dbms_output.put_line('Salariul mediu este: '||v_sm);
loop
select salariul into v_sal from angajati where id_angajat=i;
exit when v_sal<v_sm or i>110;
dbms_output.put_line('Angajatul cu id '||i||' are salariul '||v_sal);
i:=i+1;
end loop;
end;
/

declare
v_sal angajati.salariul%type;
v_sm v_sal%type;
i number(3):=100;
begin
select avg(salariul) into v_sm from angajati;
dbms_output.put_line('Salariul mediu este: '||v_sm);
while i<110 loop
select salariul into v_sal from angajati where id_angajat=i;
exit when v_sal<v_sm;
dbms_output.put_line('Angajatul cu id '||i||' are salariul '||v_sal);
i:=i+1;
end loop;
end;
/


declare
v_sal angajati.salariul%type;
v_sm v_sal%type;
i number(3):=100;
begin
select avg(salariul) into v_sm from angajati;
dbms_output.put_line('Salariul mediu este: '||v_sm);
while i<110 loop
select salariul into v_sal from angajati where id_angajat=i;
if v_sal>v_sm then
dbms_output.put_line('Angajatul cu id '||i||' are salariul '||v_sal);
end if;
i:=i+1;
end loop;
end;
/

declare
v_sal angajati.salariul%type;
v_sm v_sal%type;
--i number(3):=100;
begin
select avg(salariul) into v_sm from angajati;
dbms_output.put_line('Salariul mediu este: '||v_sm);
for i in 100 .. 109
loop
select salariul into v_sal from angajati where id_angajat=i;
if v_sal>v_sm then
dbms_output.put_line('Angajatul cu id '||i||' are salariul '||v_sal);
end if;
end loop;
end;
/

--Sa afisam toti angajatii intre 100 si 110 din 2 in 2

declare
v_sal angajati.salariul%type;
v_sm v_sal%type;
--i number(3):=100;
begin
select avg(salariul) into v_sm from angajati;
dbms_output.put_line('Salariul mediu este: '||v_sm);
for i in 50 .. 55
loop
select salariul into v_sal from angajati where id_angajat=2*i;
dbms_output.put_line('Angajatul cu id '||i||' are salariul '||v_sal);
end loop;
end;
/

declare
v_prod produse%rowtype;
begin
select * into v_prod from produse where id_produs =3133;
dbms_output.put_line('Produsul cu denumirea '||v_prod.denumire_produs||' are pretul minim '||v_prod.pret_min);
end;
/

declare
type tip_data1 is record
(v_id angajati.id_departament%type,
v_den departamente.denumire_departament%type,
v_medie number(6));
v_rec tip_data1;
begin
select a.id_departament, denumire_departament, avg(salariul) into v_rec from angajati a,
departamente d
where a.id_departament = d.id_departament and a.id_departament = &id
group by  a.id_departament, denumire_departament;
dbms_output.put_line('Media este ' ||v_rec.v_medie);
end;
/


