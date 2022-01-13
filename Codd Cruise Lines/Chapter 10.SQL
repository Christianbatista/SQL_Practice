/*  Chapter 10 Managing Schema Objects */

/*  Lets create a view */
CREATE  VIEW VW_EMPLOYEES AS 
        SELECT  EMPLOYEE_ID, LAST_NAME, FIRST_NAME, PRIMARY_PHONE
        FROM    EMPLOYEES;
        
DESC VW_EMPLOYEES;

SELECT * FROM VW_EMPLOYEES
ORDER BY EMPLOYEE_ID;

SELECT  FIRST_NAME ||' ' || LAST_NAME "EMPLOYEE", EMPLOYEE_ID
FROM    VW_EMPLOYEES
ORDER BY EMPLOYEE_ID;

COMMIT;
/*  When creating a view that contains an expression in the SELECT list, that 
    column must be given an alis name. */
CREATE OR REPLACE VIEW VW_EMPLOYEES (ID,NAME, PHONE) AS 
       SELECT   EMPLOYEE_ID,
                LAST_NAME || ', '|| FIRST_NAME,
                PRIMARY_PHONE
        FROM    EMPLOYEES;

/*  Since we have not already developed the PAY_HISTROY TABLE and inserted data
    the below statement will not run. */
CREATE VIEW EMP_TREND AS
    SELECT  EMP.SHIP_ID, PAY.MIN(SALARY) MIN_SALARY
    FROM    EMPLOYEES EMP LEFT JOIN PAY_HISTORY PAY
    ON      EMP.EMPLOYEE_ID = PAY.EMPLOYEE_ID
    GROUP BY EMP.SHIP_ID;    
    
/*  PHONE BOOK */
CREATE OR REPLACE VIEW EMP_PHONE_BOOK 
    AS SELECT LAST_NAME, FIRST_NAME, PRIMARY_PHONE FROM EMPLOYEES;
    
SELECT      LAST_NAME, FIRST_NAME, PRIMARY_PHONE
FROM        EMP_PHONE_BOOK
ORDER BY    LAST_NAME, FIRST_NAME;

/*  This code will not execute because our underlying table is the EMPLOYEES table,
    and it contains a PRIMARY KEY fo EMPLOYEE_ID.*/
INSERT INTO EMP_PHONE_BOOK (LAST_NAME, FIRST_NAME, PRIAMRY_PHONE)
    VALUES ('Sotogovernor', 'Sonia', '212-55-1212');

/*  We are updating our view. This will add a new row to the underlying table.*/
UPDATE EMP_PHONE_BOOK
   SET PRIMARY_PHONE = '803-646-6527'
WHERE   LAST_NAME = 'Batista'
  AND   FIRST_NAME = 'Christian';
  
----------------------------------------------
/*  Lets update the view to include the EMPLOYEE_ID */
CREATE OR REPLACE VIEW EMP_PHONE_BOOK
    AS SELECT   EMPLOYEE_ID,
                FIRST_NAME || ', ' || LAST_NAME EMP_NAME,
                PRIMARY_PHONE
        FROM EMPLOYEES;

DESC EMP_PHONE_BOOK;
/*  This will add a new row to the underlying table. */
INSERT INTO EMP_PHONE_BOOK (EMPLOYEE_ID, PRIMARY_PHONE)
VALUES  (102, '800-555-1212');

/*  Not only will the row in the view be deleted but also the row in the underlying 
    table.*/
DELETE FROM EMP_PHONE_BOOK WHERE EMPLOYEE_ID = 102;




