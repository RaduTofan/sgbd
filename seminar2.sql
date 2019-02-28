set serveroutput on
declare
v_nume angajati.nume%type;
v_prenume angajati.prenume%type;
begin
select nume,prenume into v_nume, v_prenume from angajati
where id_angajat=101;
dbms_output.put_line ('Numele angajatului este '||v_nume||' '||v_prenume);
end;
/
variable g_numar number
begin
select count(*) into:g_numar from comenzi
where modalitate='online';
end;
/
print g_numar


--alta met
variable g_pret number
begin
select avg(pret) into:g_pret from rand_comenzi
where id_produs=3133;
end;
/
select distinct id_produs from rand_comenzi
where pret>:g_pret;

variable g_salariul number
declare
v_nume angajati.nume%type;
begin
select nume, salariul into v_nume,:g_salariul
from angajati
where id_angajat=&id;
dbms_output.put_line('Numele angajatului este '||v_nume||' avand salariul '||:g_salariul);
end;
/


DECLARE
v_var1 NUMBER :=100; 
v_var2 NUMBER;
v_var3 NUMBER := v_var2;
v_var4 VARCHAR(20) := 'variabila PL/SQL';
v_var5 NUMBER NOT NULL := v_var1;
c_const1 CONSTANT DATE := TO_DATE('12/02/2007','dd/mm/yyyy');
c_const2 CONSTANT NUMBER NOT NULL := 2;
c_const3 CONSTANT NUMBER := NULL;
v_var6 NUMBER DEFAULT NULL;

BEGIN
DBMS_OUTPUT.PUT_LINE('variabila 1 = '||v_var1);
DBMS_OUTPUT.PUT_LINE('variabila 2 = '||v_var2);
DBMS_OUTPUT.PUT_LINE('variabila 3 = '||v_var3);
DBMS_OUTPUT.PUT_LINE('variabila 4 = '||v_var4);
DBMS_OUTPUT.PUT_LINE('variabila 5 = '||v_var5);
DBMS_OUTPUT.PUT_LINE('constanta 1 = '||c_const1);
DBMS_OUTPUT.PUT_LINE('constanta 2 = '||c_const2);
DBMS_OUTPUT.PUT_LINE('constanta 3 = '||c_const3);
DBMS_OUTPUT.PUT_LINE('variabila 6 = '||v_var6);
END;
/

DECLARE
var NUMBER;
BEGIN
var := 1;
DBMS_OUTPUT.PUT_LINE(var);

<<bloc1>>
DECLARE
var NUMBER;
BEGIN
var :=2;
DBMS_OUTPUT.PUT_LINE(var);
END bloc1;

DBMS_OUTPUT.PUT_LINE(var);

<<bloc2>>
DECLARE
var NUMBER;
BEGIN
var :=3;
DBMS_OUTPUT.PUT_LINE(var);

<<bloc3>>
DECLARE
var NUMBER;
BEGIN
var :=4;
DBMS_OUTPUT.PUT_LINE(var);
DBMS_OUTPUT.PUT_LINE(bloc2.var);
END bloc3;
DBMS_OUTPUT.PUT_LINE(var);
END bloc2;
DBMS_OUTPUT.PUT_LINE(var);
END;
/


