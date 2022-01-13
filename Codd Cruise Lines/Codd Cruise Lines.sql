Insert into employees
VALUES (2,3,'EMILY', 'BACH', 50);

SELECT LAST_NAME, INITCAP(LAST_NAME)
FROM    EMPLOYEES;


SELECT SYSDATE FROM DUAL;

SELECT FIRST_NAME || ' ' || LAST_NAME || ' of ship number ' || SHIP_ID || '.'
FROM EMPLOYEES;

SELECT RPAD('Chapter One - I Am Born', 40, '.')
FROM DUAL;

SELECT RPAD('Chapter One - I Am Born', 40, '.')
FROM DUAL;

SELECT TRIM('Chapter One - I Am Born', 40, '.')
FROM DUAL;

SELECT TRIM(TRAILING '+' FROM 'Seven thousand++++++') TheResults
FROM DUAL;

SELECT LENGTH('CHRISTIANBATISTA')
FROM DUAL;

SELECT INSTR('DFIOLSNCIENGSDLIDISDDISRRR','IS',1,2)
FROM DUAL;

SELECT SUBSTR('NAME: MARK KENNEDY',7,8)
FROM DUAL;

SELECT FLOOR(56.3333333333)
FROM DUAL;

SELECT ROUND(56.6579821,4)
FROM DUAL;0

