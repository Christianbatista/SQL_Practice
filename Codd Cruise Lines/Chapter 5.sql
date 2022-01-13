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

SELECT SUBSTR('2009',1,2)|| LTRIM('1124','1')
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
FROM DUAL;

SELECT ABS(-1.7) /* Converts the negative value to positive*/
FROM DUAL;

-- If the second peramater is removed" "2" Round() will round "up" the value
SELECT ROUND(ABS(-1.7),2) AS "ROUND"
FROM DUAL;

-- TRUNC(n,i) in this example i is omitted, so i defaults to zero.
-- meaning that the value will round down. 
SELECT TRUNC(ROUND(ABS(-11.73),2))
FROM DUAL;

-- TRUNC(n,i) i is included now, and is positve 
SELECT TRUNC(ROUND(ABS(-11.73),2),1)
FROM DUAL;

-- TRUNC(n,i) i is included now, and is negative 
SELECT TRUNC(ROUND(ABS(-11.73),2),-1)
FROM DUAL;

SELECT  SYSDATE TODAY,
        ROUND(SYSDATE, 'MM') ROUNDED_MONTH,
        ROUND(SYSDATE, 'RR') ROUNDED_YEAR
FROM DUAL;

SELECT  TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS') AS RAW_DATE,
        TO_CHAR(ROUND(SYSDATE) ,'DD-MON-YY HH:MI:SS') AS ROUNDED_DATE
FROM DUAL;

SELECT  TO_CHAR(TO_DATE('01-AUG-16 12:00:00', 'DD-MON-YY HH24:MI:SS'),
                    'DD-MON-YY HH:MI:SS') AS DAY_AT_NOON,
        TO_CHAR(ROUND(TO_DATE('01-AUG-16 12:00:00', 'DD-MON-YY HH24:MI:SS')),
                    'DD-MON-YY HH:MI:SS') AS ROUNDED_TO_NEXT_DAY
FROM DUAL;

SELECT  SYSDATE TODAY,
        TRUNC(SYSDATE,'MM') TRUNCATED_MONTH,
        TRUNC(SYSDATE,'RR') TRUNCATED_YEAR
FROM DUAL;

SELECT NEXT_DAY('28-DEC-21','Tuesday') /* input todays date */
FROM DUAL;

SELECT LAST_DAY('14-FEB-20'), LAST_DAY('20-FEB-21')
FROM DUAL;

SELECT  ADD_MONTHS('31-JAN-17',1),
        ADD_MONTHS('31-JAN-17',-12),/*There is no SUBTRACT_MONTHS function. Instead,use ADD_MONTHS to add a negative number of months, and you'll subtract them instead*/
        ADD_MONTHS('01-NOV-17',4)
FROM DUAL;

SELECT MONTHS_BETWEEN('12-JUN-14','03-OCT-13')
FROM DUAL;

SELECT MONTHS_BETWEEN('01-JAN-17','01-FEB-17')
FROM DUAL;

SELECT MONTHS_BETWEEN('10-AUG-17','10-JUL-17') /*To get positve number, the first parameter is expected to be the greater value; the second is expected to be the lesser*/
FROM DUAL;

SELECT NUMTOYMINTERVAL(27,'MONTH')/* The 2-3 value shows 2 years and 3 months is the amount of time that results*/
FROM DUAL;

SELECT NUMTODSINTERVAL(36,'HOUR') /*The following example translates 36 hours into its formal representation of 1 day and 12 hours*/
FROM DUAL;

SELECT  TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS')          AS TODAY,
        TO_CHAR(SYSDATE+1, 'DD-MON-YY HH:MI:SS')        AS TOMORROW,
        TO_CHAR(SYSDATE+1/24, 'DD-MON-YY HH:MI:SS')     AS ONE_HOUR_FROM_NOW,
        TO_CHAR(SYSDATE+1/1440, 'DD-MON-YY HH:MI:SS')   AS ONE_MIN_FROM_NOW
FROM DUAL;

ALTER TABLE SHIP_CABINS
ADD SQ_FT NUMBER;


UPDATE SHIP_CABINS SET SQ_FT =533 WHERE ROOM_NUMBER = 102;
UPDATE SHIP_CABINS SET SQ_FT =160 WHERE ROOM_NUMBER = 103;
UPDATE SHIP_CABINS SET SQ_FT =533 WHERE ROOM_NUMBER = 104;
UPDATE SHIP_CABINS SET SQ_FT =205 WHERE ROOM_NUMBER = 105;
UPDATE SHIP_CABINS SET SQ_FT =586 WHERE ROOM_NUMBER = 106;

INSERT INTO SHIP_CABINS
VALUES (107,'Suit','Ocean',1524);

SELECT SUM(SQ_FT)
FROM SHIP_CABINS;

/* To see how OVER,and ORDER BY are used with analytics*/
SELECT WINDOW,ROOM_NUMBER,SQ_FT 
        , SUM(SQ_FT) OVER   (ORDER BY SQ_FT) "Running Total"
        , SUM(SQ_FT) OVER   (ORDER BY SQ_FT
                             ROWS BETWEEN 1 PRECEDING AND
                                          1 FOLLOWING) "Subset"
FROM SHIP_CABINS
ORDER BY SQ_FT;

/* To see how OVER, PARTITION BY and ORDER BY are used with analytics. The inclusion of PARTITION BY
   changed the way Running Total and Subset are calculated.*/
SELECT WINDOW,ROOM_NUMBER,SQ_FT 
        , SUM(SQ_FT) OVER   (PARTITION BY WINDOW 
                             ORDER BY SQ_FT) "Running Total"
        , SUM(SQ_FT) OVER   (PARTITION BY WINDOW
                             ORDER BY SQ_FT
                             ROWS BETWEEN 1 PRECEDING AND
                                          1 FOLLOWING) "Subset"
FROM SHIP_CABINS
ORDER BY SQ_FT;

/* Lets change the ORDER BY for the select.*/
SELECT WINDOW,ROOM_NUMBER,SQ_FT 
        , SUM(SQ_FT) OVER   (PARTITION BY WINDOW 
                             ORDER BY SQ_FT) "Running Total"
        , SUM(SQ_FT) OVER   (PARTITION BY WINDOW
                             ORDER BY SQ_FT
                             ROWS BETWEEN 1 PRECEDING AND
                                          1 FOLLOWING) "Subset"
FROM SHIP_CABINS
ORDER BY ROOM_NUMBER;  /*this ORDER BY is all that was altered from the previous*/

/* Lets use LAG and LEAD.*/
SELECT WINDOW, ROOM_NUMBER, SQ_FT 
        , LAG(SQ_FT)  OVER   (ORDER BY WINDOW, SQ_FT) "Lag"
        , LEAD(SQ_FT) OVER   (ORDER BY WINDOW, SQ_FT) "Lead"
FROM SHIP_CABINS
ORDER BY WINDOW, SQ_FT;

/* Lets use LAG and LEAD.*/
SELECT WINDOW, ROOM_NUMBER, SQ_FT 
        , LAG(SQ_FT)  OVER   (PARTITION BY WINDOW ORDER BY ROOM_NUMBER, SQ_FT) "Lag"
        , LEAD(SQ_FT) OVER   (PARTITION BY WINDOW ORDER BY ROOM_NUMBER, SQ_FT) "Lead"
FROM SHIP_CABINS
ORDER BY ROOM_NUMBER;

SELECT AVG(SQ_FT), MEDIAN(SQ_FT), STDDEV(SQ_FT), VARIANCE(SQ_FT)
FROM SHIP_CABINS;

SELECT   WINDOW, ROOM_NUMBER, SQ_FT
        ,VARIANCE(SQ_FT) OVER (ORDER BY SQ_FT) "VARIANCE"
        ,STDDEV(SQ_FT)  OVER (ORDER BY SQ_FT) "Std Dev"
FROM     SHIP_CABINS
ORDER BY SQ_FT;

/* More examples of PERCENTIAL_CONT at https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions110.htm */
SELECT  WINDOW, ROOM_NUMBER,SQ_FT
    ,   PERCENTILE_CONT(.6)
            WITHIN GROUP    (ORDER BY SQ_FT)
            OVER (PARTITION BY WINDOW) "PCT"
FROM SHIP_CABINS
ORDER BY SQ_FT;

SELECT SUBSTR('ABCDEFG',3,4) "Substring"
FROM DUAL;
 
SELECT SUBSTR('ABCDEFG',-7,4) "Substring"
FROM DUAL;








