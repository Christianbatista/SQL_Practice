SELECT 'Chapter ' || 1 || '.... I am born.'
FROM DUAL;

SELECT  SYSDATE,
        ADD_MONTHS(SYSDATE,
                   SUBSTR('plus 3 months',6,1)) AS PLUS_THREE
FROM DUAL;

/* This is a text value of 3, and in the dictionary , yes, the text '3' is greater than 20*/
SELECT 'TRUE' FROM DUAL WHERE '3' > '20';

/* This will return no rows selected */
SELECT 'TRUE' FROM DUAL WHERE '3' > 20;

--Section 6.02--------------------------------------------

CREATE TABLE CALLS(
CALL_ID NUMBER,
CALL_DATE_TZ TIMESTAMP WITH TIME ZONE );

--This script will not run 
INSERT INTO CALLS
VALUES (1, '24-MAY-12 10:15:30');

--This will insert the data 
INSERT INTO CALLS
VALUES (1, TO_TIMESTAMP_TZ('24-MAY-12 10:15:30',
                            'DD-MON-RR HH24:MI:SS')   );

--This is another example of the TO_TIMESTAMP_TZ converstion function
SELECT TO_TIMESTAMP_TZ('1999-12-01 11:00:00 -8:00',
   'YYYY-MM-DD HH:MI:SS TZH:TZM') FROM DUAL;

--T0_NUMBER(e1,format_model, nls_parms)
SELECT TO_NUMBER('$17,000.23', '$999,999.99')
FROM DUAL;

SELECT TO_NUMBER('17.000,23', '999G999D99',
                 'NLS_NUMERIC_CHARACTERS= '',.'' ') AS REFORMATED_NUMBERS
FROM DUAL;

--TO_CHAR(c)
SELECT TO_CHAR('Hello')
FROM DUAL;

--TO_CHAR(n,format_model,nls_parms)
SELECT TO_CHAR(198,'$999.99')
FROM DUAL;

--TO_CHAR(d,format_model,nls_parms)
SELECT TO_CHAR(SYSDATE,'DAY, "THE" DD "OF" MONTH, RRRR')
FROM DUAL;

--FM code is a format mask that cleans up all of the trailing blanks
SELECT TO_CHAR(SYSDATE,'FMDAY, "THE" DD "OF" MONTH, RRRR')
FROM DUAL;

--mixed case notice how DAY is not Day
SELECT TO_CHAR(SYSDATE,'FMDay, "the" DD "of" MONTH, RRRR')
FROM DUAL;

--Adding the th indicator introduces an additional improvement
SELECT TO_CHAR(SYSDATE,'FMDay, "the" Ddth "of" MONTH, RRRR')
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'HH24:MI:SS AM') 
FROM DUAL;

--Try to figure out what is wrong with this code, do you see it
SELECT TO_CHAR(SYSDATE, 'DD-MON-RRRR HH:MM:SS') AS "Today's Date and Time"
FROM DUAL;

--This is the corrected code for the above statement
SELECT TO_CHAR(SYSDATE, 'DD-MON-RRRR HH:MI:SS') AS "Today's Date and Time"
FROM DUAL;

SELECT  TO_CHAR(TO_DATE('01-JAN-49','DD-MON-YY'),'YYYY'),
        TO_CHAR(TO_DATE('01-JAN-50','DD-MON-YY'),'YYYY'),
        TO_CHAR(TO_DATE('01-JAN-49','DD-MON-RR'),'RRRR'),
        TO_CHAR(TO_DATE('01-JAN-50','DD-MON-RR'),'RRRR')
FROM DUAL;

--12 Hour clock vs 24 Hour clock----
SELECT  TO_CHAR(TO_DATE('07-JULY-16 00:00:00','DD-MON-YY HH24:MI:SS'),
                'DD-MON-YY HH24:MI:SS PM') AS MIDNIGHT_HR24,
        TO_CHAR(TO_DATE('07-JULY-16 00:00:00','DD-MON-YY HH24:MI:SS'),
                'DD-MON-YY HH12:MI:SS PM') AS MIDNIGHT_HR12
FROM DUAL;

--TO_DATE---
SELECT TO_DATE('2016-01-31','RRRR-MM-DD')
FROM DUAL;

----
SELECT TO_CHAR(TO_DATE('04-JUL-1776'),'DAY')
FROM DUAL;

--This version all caps
SELECT TO_CHAR(TO_DATE('04-JUL-1776'),'fmDay,MONTH "the" Ddthsp, YEAR')
FROM DUAL;

--This version all only the first letter is capital
SELECT TO_CHAR(TO_DATE('04-JUL-1776'),'fmDay,Month "the" Ddthsp, Year')
FROM DUAL;

SELECT TO_TIMESTAMP('2020-JAN-01 13:34:00:093423' ,
                    'RRRR-MON-DD HH24:MI:SS:FF') EVENT_TIME
FROM DUAL;

SELECT TO_TIMESTAMP_TZ('17-04-2016 16:45:30','DD-MM-RRRR HH24:MI:SS') AS "TIME"
FROM DUAL;

SELECT TO_YMINTERVAL('04-06') AS EVENT_TIME
FROM DUAL;


SELECT TO_DSINTERVAL('40 08:30:00.03225') AS EVENT_TIME
FROM DUAL;
-------INTERVAL YEAR TO MONTH----
SELECT NUMTOYMINTERVAL(27,'MONTH')
FROM DUAL;

SELECT NUMTOYMINTERVAL(27,'YEAR')
FROM DUAL;

-------INTERVAL DAY TO SECOND----
SELECT NUMTODSINTERVAL(36,'DAY')
FROM DUAL;

SELECT NUMTODSINTERVAL(36,'HOUR')
FROM DUAL;

SELECT NUMTODSINTERVAL(36,'MINUTE')
FROM DUAL;

SELECT NUMTODSINTERVAL(36,'SECOND')
FROM DUAL;

--Cast examples
-- ex. with time 
SELECT CAST('19-JAN-16 11:35:30'
            AS TIMESTAMP WITH LOCAL TIME ZONE) "CONVERTED LTZ"
FROM DUAL;

-- ex. without time
SELECT CAST('22-OCT-1997' AS TIMESTAMP WITH LOCAL TIME ZONE) 
   FROM dual;

SELECT CAST(TO_TIMESTAMP('19-JAN-16 14:35:30', 'DD-MON-RR HH24:MI:SS')
            AS TIMESTAMP WITH LOCAL TIME ZONE) AS "Converted LTZ"
FROM DUAL;

--Conditional Expressions---

SELECT CASE 'option1'
        WHEN 'option1' THEN 'found it'
        WHEN 'option2' THEN 'did not find it' 
        END AS "Answer"
FROM DUAL;

INSERT INTO SHIPS
VALUES(4002,'Codd Champion',2974,2500,NULL);
INSERT INTO SHIPS
VALUES(4003,'Codd Elegance',2974,2400,NULL);
INSERT INTO SHIPS
VALUES(4002,'Codd Victorious',2974,2600,NULL);

--Note that in this example the CASE function takes in a numberic value and returns a text string
SELECT  SHIP_NAME, CAPACITY, 
        CASE CAPACITY   WHEN 2052 THEN 'MEDIUM'
                        WHEN 2974 THEN 'LARGE'
                        END AS CABIN_SIZE
FROM SHIPS
ORDER BY CAPACITY;

SELECT STATE, DECODE(STATE, 'CA', 'California',
                            'IL', 'Illinois',
                            'Other') AS DECODED_STATE
FROM ADDRESSES;

--NVL(e1,e2) helpful when doing maths
SELECT  NVL(NULL,0)         FIRST_ANSWER,
        14+NULL-4           SECOND_ANSWER,
        14+NVL(NULL,0)-4    THIRD_ANSWER
FROM DUAL;

ALTER TABLE SHIP_CABINS
ADD BALCONY_SQ_FT NUMBER;

SELECT SQ_FT + NVL(BALCONY_SQ_FT,0)AS TOTAL_SQ_FT
FROM SHIP_CABINS;

SELECT SQ_FT + NVL(BALCONY_SQ_FT,0)AS TOTAL_SQ_FT
FROM SHIP_CABINS
WHERE room_number = 102;

UPDATE SHIP_CABINS SET BALCONY_SQ_FT = '60' WHERE ROOM_NUMBER = 104;













