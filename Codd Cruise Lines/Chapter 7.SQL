CREATE TABLE SHIP_SHOP(
    ID      NUMBER,
    ITEM    VARCHAR2(30),
    PRICE   NUMBER(5,2),
    CONSTRAINT id_pk PRIMARY KEY(ID));

INSERT INTO SHIP_SHOP
VALUES  (1,'Towel',21.99);

INSERT INTO SHIP_SHOP
VALUES  (3,'Postcard',2.49);

INSERT INTO SHIP_SHOP
VALUES  (2,'Mug',7.19);

COMMIT;

SELECT ITEM, PRICE, ROUND(PRICE) FROM SHIP_SHOP;

--AVG- is an example of a group function. There will be one-row result
SELECT AVG(PRICE) FROM SHIP_SHOP;

--This will not work
SELECT ROUND(PRICE), AVG(PRICE) FROM SHIP_SHOP;

--Nesting one function within the other is acceptable.
SELECT ROUND(AVG(PRICE)) FROM SHIP_SHOP;
--Nesting one function within the other is acceptable.
SELECT AVG(ROUND(PRICE)) FROM SHIP_SHOP;

CREATE TABLE VENDORS(
    VENDOR_ID       NUMBER,
    VENDOR_NAME     VARCHAR2(20 BYTE),
    STATUS          NUMBER(3),
    CATEGORY        VARCHAR2(10 BYTE),
    CONSTRAINT PK_VENDOR_ID PRIMARY KEY (VENDOR_ID) );

INSERT INTO VENDORS
VALUES  (1,'Acme Steaks',17,NULL);

INSERT INTO VENDORS
VALUES  (2,'Acme Poker Chips',NULL,NULL);

--COUNT(e1) determines the number of occurences of non-NULL values
SELECT COUNT(VENDOR_NAME), COUNT(STATUS), COUNT(CATEGORY)
FROM VENDORS;

--Simply COUNT the number of rows in the entire table
SELECT COUNT(*) AS Number_of_rows
FROM VENDORS;

/*  Note that a COUNT of the asterisk is asking for a count of all rows. 
    In the rare situation where a row contains nothing but NULL values 
    in all of its columns, COUNT(*) will still count that row.*/
SELECT COUNT(*), COUNT(VENDOR_NAME)
FROM VENDORS;

--SUM(e1)-- e1 is an expression whose data type is numberic
SELECT SUM(PRICE)
FROM SHIP_SHOP;

ALTER TABLE EMPLOYEES
ADD START_DATE DATE;

ALTER TABLE EMPLOYEES
ADD SALARY NUMBER;

UPDATE EMPLOYEES SET START_DATE = TO_DATE('2016-08-20','YYYY-MM-DD')
WHERE EMPLOYEE_ID = 2;

UPDATE EMPLOYEES SET START_DATE = TO_DATE('2015-12-01','YYYY-MM-DD')
WHERE EMPLOYEE_ID = 2;

UPDATE EMPLOYEES SET SALARY = TO_NUMBER('75,000.00', '999G999D99')
WHERE EMPLOYEE_ID = 1;

UPDATE EMPLOYEES SET SALARY = TO_NUMBER('77,000.00', '999G999D99')
WHERE EMPLOYEE_ID = 2;

INSERT INTO EMPLOYEES 
        (employee_id, first_name, last_name, position_id, ship_id, start_date, salary)
VALUES  
        (SEQ_EMPLOYEE_ID.nextval,'Alice','Lindon',25, 16, TO_DATE('2015-12-01','YYYY-MM-DD'),    TO_NUMBER('85,0000.00', '99G999D99') );

INSERT INTO EMPLOYEES 
        (employee_id, first_name, last_name, position_id, ship_id, start_date, salary)
VALUES  
        (4,'Jim','West',NULL, NULL, TO_DATE('2015-12-01','YYYY-MM-DD'), TO_NUMBER('850000') );

INSERT INTO EMPLOYEES 
        (employee_id, first_name, last_name )
VALUES  
        (5,'John','Smith');
        
INSERT INTO EMPLOYEES 
        (employee_id, first_name, last_name )
VALUES  
        (6,'C.S','Lewis');
        
INSERT INTO EMPLOYEES 
        (employee_id, first_name, last_name )
VALUES  
        (7,'Harry','Potter');

UPDATE EMPLOYEES SET SALARY = 105250 WHERE EMPLOYEE_ID = 4;        
commit;

/*  Now that we have included more names and additional columns to the employees
    We will run the MIN AND MAX Clauses*/ 

SELECT MIN(LAST_NAME), MAX(LAST_NAME) FROM EMPLOYEES;

--last name 'BACH' was in all Caps. Change to lower case.
UPDATE EMPLOYEES SET LAST_NAME = 'Bach' WHERE EMPLOYEE_ID = 2;

SELECT EMPLOYEE_ID, SALARY 
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;

--AVG(e1)-- works only with numeric data. It ignores NULL values.
SELECT AVG(SALARY) FROM EMPLOYEES;

--Example of nested within a scalar function.
SELECT ROUND(AVG(SALARY),2) FROM EMPLOYEES;

/*  We can get fancy by using a T0_CHAR funcation and format model.
    We have nested a single aggregate function within two scalar, or single row,
    row functions.
*/
SELECT TO_CHAR(ROUND(AVG(SALARY),2),'$99,999.99') FROM EMPLOYEES;

/*  MEDIAN(e1) it will ignore NULL values. The function returns the middle value
    or, if that isn't easily identified, then an interpolated values from within 
    the middle. */
CREATE TABLE TEST_MEDIAN(
A       NUMBER(3)
);

INSERT INTO TEST_MEDIAN VALUES (1);
INSERT INTO TEST_MEDIAN VALUES (10);
INSERT INTO TEST_MEDIAN VALUES (3);

/*  The function is looking for the middle value, dont confuse the middle value with 
    the avg value. in the below statement the middle value will be 3*/
SELECT MEDIAN(A) FROM TEST_MEDIAN;

UPDATE TEST_MEDIAN SET A =7 WHERE A=3;

/*  The function is looking for the middle value, dont confuse the middle value with 
    the avg value. in the below statement the middle value will be 7*/
SELECT MEDIAN(A) FROM TEST_MEDIAN;

/*  How to rename a column that is in a table */
ALTER TABLE SHIP_CABINS RENAME COLUMN "STYLE" to ROOM_STYLE;

/*  The RANK function calculates the rank of a value within a group of values.
    The rows are partitioned by ROOM_STYLE, so those are sorted first; then 
    within a given partition, rows are ranked by SQ_FT.*/
SELECT ROOM_NUMBER, ROOM_STYLE, SQ_FT
        , RANK() OVER (PARTITION BY ROOM_STYLE ORDER BY SQ_FT) SQ_FT_RK
FROM    SHIP_CABINS
ORDER BY SQ_FT;

/*  This is an aggregate RANK */
SELECT RANK(586) WITHIN GROUP (ORDER BY SQ_FT) AS AGGREGATE_RANK
FROM    SHIP_CABINS
ORDER BY SQ_FT;

/*  DENSE_RANK: Analytic operates similarly to RANK(); However after calculating for ties
    it will continue to the next sequential number, regardles of how many tied rows
    may have preceded*/
SELECT ROOM_NUMBER, ROOM_STYLE, SQ_FT,
    DENSE_RANK() OVER (PARTITION BY ROOM_STYLE ORDER BY SQ_FT) SQ_FT_DRK
FROM    SHIP_CABINS
ORDER BY ROOM_STYLE, SQ_FT;

/*  DENSE_RANK: Aggregate  
    The reason the answer is "3"  is due to the the ORDER BY taking place before 
    the statement searches for the value of 533 in the data */
SELECT DENSE_RANK(533) WITHIN GROUP (ORDER BY SQ_FT) AS AGGREGATE_RANK
FROM    SHIP_CABINS
ORDER BY SQ_FT;

/*  DENSE_RANK: Aggregate  
    The reason the answer is "4" is due to the the ORDER BY taking place before 
    the statement searches for the value of 586 in the data. (REMEMBER THAT 
    DENSE_RANK CALCULATES TIES, AND THEN THE NEXT SEQUENTIAL NUMBER IS POPULATED
    AFTER THE TIES.)*/
SELECT DENSE_RANK(533) WITHIN GROUP (ORDER BY SQ_FT) AS AGGREGATE_RANK
FROM    SHIP_CABINS
ORDER BY SQ_FT;

/*  Adding a column to the table */
ALTER TABLE SHIP_CABINS
ADD GUESTS NUMBER(2);

/*  The below examples are from textbook page 292. By using the keyword FIRST, 
    the statement identifies the lowest value for the GUESTS column. Then 
    for all rows with a GUEST value that matches the lowest value we just found,
    determine the MAX value for SQ_FT*/ 

--This example results is 205
SELECT MAX(SQ_FT) KEEP(DENSE_RANK FIRST ORDER BY GUESTS) AS FIRST_LAST_EXAMPLE
FROM SHIP_CABINS;

--This example results is 160
SELECT MIN(SQ_FT) KEEP(DENSE_RANK FIRST ORDER BY GUESTS) AS FIRST_LAST_EXAMPLE
FROM SHIP_CABINS;

--This example result is 1524
SELECT MAX(SQ_FT) KEEP(DENSE_RANK LAST ORDER BY GUESTS) AS FIRST_LAST_EXAMPLE
FROM SHIP_CABINS;

--This example result is 1524
SELECT MIN(SQ_FT) KEEP(DENSE_RANK LAST ORDER BY GUESTS) AS FIRST_LAST_EXAMPLE
FROM SHIP_CABINS;

/*  How to drop a constraint from a table.
    This will also remove any Indexes*/
ALTER TABLE SHIP_CABINS
DROP CONSTRAINT ROOM_NUMBER_PK;

ALTER TABLE SHIP_CABINS
ADD SHIP_CABIN_ID NUMBER;

ALTER TABLE SHIP_CABINS
ADD SHIP_ID NUMBER(7);

ALTER TABLE SHIP_CABINS
ADD ROOM_TYPE VARCHAR2(20 BYTE);

/*  When you make an invisible column visible, the column is included in the table’s column order as the last column.
    Since I made all columns invisible with the exception of the newest column SHIP_CABIN_ID. This push SHIP_CABIN_ID
    to be the first column in the table.*/ 
ALTER TABLE SHIP_CABINS MODIFY (ROOM_NUMBER INVISIBLE, ROOM_STYLE INVISIBLE,WINDOW INVISIBLE, SQ_FT INVISIBLE, BALCONY_SQ_FT INVISIBLE,GUESTS INVISIBLE);
ALTER TABLE SHIP_CABINS MODIFY (ROOM_NUMBER VISIBLE, ROOM_STYLE VISIBLE,WINDOW VISIBLE, SQ_FT VISIBLE, BALCONY_SQ_FT VISIBLE,GUESTS VISIBLE);
COMMIT;

DESC ship_cabins;

ALTER TABLE SHIP_CABINS 
ADD CONSTRAINT PK_SHIP_CABIN_ID PRIMARY KEY (SHIP_CABIN_ID);

/*  Below is the avg of all the cabins on the ship*/
SELECT  ROUND(AVG(SQ_FT),2)
FROM    SHIP_CABINS;

/* Look at the average for just the suites */
SELECT  ROUND(AVG(SQ_FT),2)
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1 AND ROOM_STYLE = 'Suite';

/* Look at the average for just the 'Stateroom' */
SELECT  ROUND(AVG(SQ_FT),2)
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1 AND ROOM_STYLE = 'Stateroom';

/*  We can get the same information as the above statements by using the
    GROUP BY Clause. By telling SQL to gjroup the rows according to thier 
    values for ROOM_STYLE, whatever they may be. */    
SELECT  ROOM_STYLE, ROUND(AVG(SQ_FT),2)
FROM    SHIP_CABINS
GROUP BY ROOM_STYLE;


/*  We could also include multiple aggregate functions in the above query */
SELECT  ROOM_STYLE,
        ROUND(AVG(SQ_FT),2)     AS "Average SQ FT",
        MIN(GUESTS)             AS "Minimum # of Guest",
        COUNT(SHIP_CABIN_ID)    AS "Total # of cabins"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE;

/*  This example is the same but we will group by ROOM_TYPE instead
    and change Min to Max, and we also shose to apply a format mode to the 
    AVG output to clean it up a little, and omitted the AS in the alias names*/
SELECT  ROOM_TYPE,
        TO_CHAR(ROUND(AVG(SQ_FT),2),'999,999.99')  AS "Average SQ FT",
        MAX(GUESTS)              "Maximum # of Guest",
        COUNT(SHIP_CABIN_ID)     "Total # of cabins"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_TYPE      -- You could GROUP BY ROOM_TYPE, AND WINDOW. 
ORDER BY 2 DESC;        -- sort the rows based on the value in the second item, decending order

SELECT  TO_CHAR(ROUND(AVG(SQ_FT),2),'999,999.99')   AS "Average SQ FT",
        MAX(GUESTS)                          AS "Maximum # of Guests",
        COUNT(SHIP_CABIN_ID)                 AS "Total # of cabins"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1 AND ROOM_TYPE   = 'Royal' -- remember room_type is case sensitive
ORDER BY 1 DESC; 

/*  You can group multiple columns with a single GROUP BY clause.
    The ORDER BY clause tells sql to sort the rows based on the value in the third
    item in the select list, which is the MIN aggregate function.*/
SELECT  ROOM_STYLE,
        ROOM_TYPE,
        TO_CHAR(MIN(SQ_FT),'9,999') "MIN",
        TO_CHAR(MAX(SQ_FT),'9,999') "MAX",
        TO_CHAR(MIN(SQ_FT)-MAX(SQ_FT),'9,999') "Diff"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE
ORDER BY 3;

/*  LETS continue build on the use of the ORDER BY clause*/
SELECT  ROOM_TYPE, WINDOW,  -- We are adding the WINDOW column for ease of understanding. 
        TO_CHAR(ROUND(AVG(SQ_FT),2),'999,999.99')  AS "Average SQ FT",
        MAX(GUESTS)              "Maximum # of Guest",
        COUNT(SHIP_CABIN_ID)     "Total # of cabins"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_TYPE, WINDOW  -- You could GROUP BY ROOM_TYPE, AND WINDOW. 
ORDER BY WINDOW;            -- You can ORDER BY WINDOW even though it is not in
                            -- SELECT list;However it needs to be included in the 
                            -- GROUP BY clause in for the statement to work.

--------------------------------------------------------------------------------
/*  Nesting Functions */
SELECT TO_CHAR(MEDIAN(SQ_FT),'999.99') FROM SHIP_CABINS;

SELECT  ROOM_STYLE, ROOM_TYPE,MAX(SQ_FT)
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE;

-- This statement will fail, because there are inconsistent levels of detail.
SELECT  ROOM_STYLE, ROOM_TYPE,AVG(MAX(SQ_FT))
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE;

/*  This result displays in just one row, which in turn represent the six rows
    from the previous query, which itself represented 12 rows So, we have aggregated
    12 rows into 6 and then 6 into 1. */
SELECT  AVG(MAX(SQ_FT))
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE;

/*  Two levels deep is the furthest you can go with nested aggregate functions.*/
SELECT  COUNT(AVG(MAX(SQ_FT)))
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE;

/*  We are allowed to introduce nested scalar functions at any time.*/
SELECT  ROUND(AVG(MAX(SQ_FT)))
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY ROOM_STYLE, ROOM_TYPE;

/*  HAVING clause is allowed only with a GROUP BY clause. HAVING and GROUP BY 
    clause. HAVING and GROUP BY may occur in either order. */
SELECT  ROOM_STYLE,
        ROOM_TYPE,
        TO_CHAR(MIN(SQ_FT),'9,999') "Min"
FROM    SHIP_CABINS
WHERE   SHIP_ID = 1
GROUP BY    ROOM_STYLE, ROOM_TYPE
HAVING  ROOM_TYPE IN ('Standard', 'Large')
    OR  MIN(SQ_FT)  > 1200
ORDER BY 3;













