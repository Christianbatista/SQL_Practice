/*  CHAPTER 9 USING SUBQUERIES TO SOLVE QUERIES */

/*  Before moving forward to and proving a subquery example lets create a new 
    table and add some data to it.*/
CREATE TABLE SALES_DATA(
ID      NUMBER,
REP     VARCHAR2(10),
YEAR    NUMBER(4),
TOTAL_SALES NUMBER );

/*  Lets also add a constraint. */
ALTER TABLE SALES_DATA 
ADD CONSTRAINT PK_SALES_DATA PRIMARY KEY (ID);

/*  Lets COMMIT before adding records to the SALES_DATA table. Examples of two
    seperate ways to input multiple records are shown below.*/
COMMIT; 

/*  The below records are inserted one at a time into the table.*/
INSERT INTO SALES_DATA VALUES(1,'Joe',2018,249);
INSERT INTO SALES_DATA VALUES(2,'Joe',2017,178);
INSERT INTO SALES_DATA VALUES(3,'Joe',2016,483);
INSERT INTO SALES_DATA VALUES(4,'Ann',2018,422);
INSERT INTO SALES_DATA VALUES(5,'Ann',2017,427);
INSERT INTO SALES_DATA VALUES(6,'Ann',2016,245);
INSERT INTO SALES_DATA VALUES(7,'Moe',2018,308);
INSERT INTO SALES_DATA VALUES(8,'Moe',2017,721);
INSERT INTO SALES_DATA VALUES(9,'Moe',2016,109);
INSERT INTO SALES_DATA VALUES(10,'Lyn',2018,525);
INSERT INTO SALES_DATA VALUES(11,'Lyn',2017,589);
INSERT INTO SALES_DATA VALUES(12,'Lyn',2016,742);

ROLLBACK; -- ROLLBACK to the previous COMMIT, thus removing all the records recently inserted.

/*  The below records are all inserted by means of a single statement. they are
    placed into a dummy table then called. */
INSERT INTO SALES_DATA 
  WITH NAMES_YEARS_SALES AS ( 
    SELECT 1,'Joe',2018,249 FROM dual UNION ALL
    SELECT 2,'Joe',2017,178 FROM dual UNION ALL
    SELECT 3,'Joe',2016,483 FROM dual UNION ALL
    SELECT 4,'Ann',2018,422 FROM dual UNION ALL
    SELECT 5,'Ann',2017,427 FROM dual UNION ALL
    SELECT 6,'Ann',2016,245 FROM dual UNION ALL
    SELECT 7,'Moe',2018,308 FROM dual UNION ALL
    SELECT 8,'Moe',2017,721 FROM dual UNION ALL
    SELECT 9,'Moe',2016,109 FROM dual UNION ALL
    SELECT 10,'Lyn',2018,525 FROM dual UNION ALL
    SELECT 11,'Lyn',2017,589 FROM dual UNION ALL
    SELECT 12,'Lyn',2016,742     FROM dual 
  ) 
  SELECT * FROM NAMES_YEARS_SALES;

/*  You are tasked with listing any and all sales reps whose sales for 2016
    surpassed the sales teams's average sales for the prior year of 2017*/
SELECT  AVG(TOTAL_SALES) AVG_SALES
FROM    SALES_DATA
WHERE   YEAR = 2017;

/*  We have included the subquery within the outer parent query. A subquery in the 
    WHERE clause of a SELECT  statement is known as a nested subquery because it
    is nested within the larger query(the SELECT statement itself).*/
SELECT REP
FROM SALES_DATA
WHERE YEAR = 2018
    AND TOTAL_SALES >  (SELECT AVG(TOTAL_SALES)
                        FROM SALES_DATA
                        WHERE  YEAR = 2017);

/*  Correlated Subqueries
    The correlated subquery is executing once for each value that the parent
    query finds for each row, passing back its result like noncorreclated 
    subqueries do. */
SELECT  A.SHIP_CABIN_ID, A.ROOM_NUMBER, A.SQ_FT
FROM    SHIP_CABINS A
WHERE   A.SQ_FT >  (SELECT AVG(SQ_FT)
                    FROM    SHIP_CABINS
                    WHERE ROOM_STYLE = A.ROOM_STYLE)
ORDER BY A.ROOM_NUMBER;

/*  Here is a quick check. The previous statements results are in line with the 
    results for the below statement.*/
SELECT  ROOM_STYLE, AVG(SQ_FT)
FROM    SHIP_CABINS
GROUP BY ROOM_STYLE;

Commit;

--------------------------------------------------------------------------------
/*  Update and Delete Rows Using Correlated Subqueries   */
 CREATE TABLE INVOICES(
 INVOICE_ID     NUMBER,
 INVOICE_DATE   DATE,
 ACCOUNT_NUMBER VARCHAR2(80 BYTE),
 TERMS_OF_DISCOUNT  VARCHAR2(20 BYTE),
 VENDOR_ID          NUMBER,
 TOTAL_PRICE        NUMBER(8,2),
 SHIPPING_DATE      DATE,
 CONSTRAINT PK_INVOICE_ID PRIMARY KEY(INVOICE_ID));
 
 /* UPDATE STAEMENT TO THE INVOICES TABLE, This table currently does not have any 
    data in it yet. */
UPDATE INVOICES INV
    SET TERMS_OF_DISCOUNT = '10 PCT'
WHERE TOTAL_PRICE = (SELECT MAX(TOTAL_PRICE)
                     FROM   INVOICES
                     WHERE 
                     TO_CHAR(INVOICE_DATE, 'RRRR-Q') = 
                     TO_CHAR(INV.INVOICE_DATE, 'RRRR-Q')
                    );
                
UPDATE PORTS P
SET     CAPACITY = (SELECT COUNT(*)
                    FROM SHIPS
                    WHERE HOME_PORT_ID  = P.PORT_ID)
WHERE EXISTS (SELECT *
             FROM SHIPS
             WHERE HOME_PORT_ID = P.PORT_ID);
COMMIT;

DESC SHIP_CABINS;

ALTER TABLE SHIP_CABINS MODIFY(BALCONY_SQ_FT VISIBLE,SQ_FT VISIBLE);

SAVEPOINT DELETE_EXAMPLE_CORRELATED_SUBQUERY;

/*  */
DELETE FROM SHIP_CABINS S1
WHERE S1.BALCONY_SQ_FT =
       (SELECT MIN(BALCONY_SQ_FT)
        FROM    SHIP_CABINS S2
        WHERE   S1.ROOM_TYPE  = S2.ROOM_TYPE
        AND     S1.ROOM_STYLE = S2.ROOM_STYLE);

ROLLBACK TO SAVEPOINT DELETE_EXAMPLE_CORRELATED_SUBQUERY;

/*  Test keyword EXISTS AND NOT EXISTS */
SELECT PORT_ID, PORT_NAME
FROM PORTS P1
WHERE EXISTS   (SELECT *
                FROM SHIPS S1
                WHERE P1.PORT_ID = S1.HOME_PORT_ID);

SELECT PORT_ID, PORT_NAME
FROM PORTS P1
WHERE NOT EXISTS   (SELECT *
                FROM SHIPS S1
                WHERE P1.PORT_ID = S1.HOME_PORT_ID);
                
/*  WITH clause is used to assign a name to a subquery block. */
WITH
    PORT_BOOKINGS AS (
        SELECT P.PORT_ID, P.PORT_NAME, COUNT(S.SHIP_ID) CT
        FROM PORTS P, SHIPS S
        WHERE P.PORT_ID = S.HOME_PORT_ID
        GROUP BY P.PORT_ID, P.PORT_NAME
    ),
    DENSEST_PORT AS (
        SELECT MAX(CT) MAX_CT
        FROM PORT_BOOKINGS
    )
SELECT  PORT_NAME
FROM    PORT_BOOKINGS
WHERE   CT =(SELECT MAX_CT FROM DENSEST_PORT);

/*  SINGLE-ROW Subqueries, the first subquery returns the ship_ id number that Al
    Smith is associated with. The second subquery returns all employees that 
    are associated with the same ship_id; however does not want any of the results 
    to be Al Smith. */
SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME
FROM    EMPLOYEES
WHERE   SHIP_ID = (SELECT SHIP_ID
                 FROM   EMPLOYEES
                 WHERE  LAST_NAME ='Smith'
                   AND  FIRST_NAME = 'Al')
  AND   NOT (LAST_NAME = 'Smith' AND FIRST_NAME = 'Al')
ORDER BY EMPLOYEE_ID;

--------------------------------------------------------------------------------
/*  Multiple-Row Subqueries */

SELECT  SHIP_ID, LAST_NAME, FIRST_NAME
FROM    EMPLOYEES
WHERE   SHIP_ID IN (SELECT SHIP_ID FROM EMPLOYEES WHERE LAST_NAME = 'Smith')
ORDER BY SHIP_ID, LAST_NAME;

--------------------------------------------------------------------------------
/*  NOT IN and NULL Values in the Subquery */
CREATE TABLE PARENT (ID NUMBER, HOUSE VARCHAR2(30));

INSERT INTO PARENT VALUES (1,'0ak');
INSERT INTO PARENT VALUES (2,'Elm');

CREATE TABLE KID (KID_ID NUMBER, HOUSE VARCHAR2(30));

INSERT INTO KID VALUES (1,'Maple');
INSERT INTO KID VALUES (2,'Elm');

COMMIT;

/*  Because of the IN, it returns TRUE if the subject value equals any of the
    values in the set. Returns FALSE if the subquesry returns no rows*/
SELECT *
FROM PARENT 
WHERE HOUSE IN (SELECT HOUSE FROM KID);
 
/*  NOT IN, NOT is used with IN to reverese the results */
SELECT *
FROM PARENT 
WHERE HOUSE NOT IN (SELECT HOUSE FROM KID);

/*  Lets add a NULL to the KID table and rey the NOT IN again */
INSERT INTO KID VALUES (30, NULL);

/*  When a NULL is introduced into the row set returned by the subquery, a no-win
    situation results.*/
SELECT *
FROM PARENT 
WHERE HOUSE NOT IN (SELECT HOUSE FROM KID);

/*  One solution to the above statement is to exclude NULL values in the subquery
    when using NOT IN.*/
SELECT *
FROM PARENT 
WHERE HOUSE NOT IN (SELECT HOUSE FROM KID WHERE HOUSE IS NOT NULL);

/*  Identify the ships in each port that has the least/lowest capacity */
SELECT S1.HOME_PORT_ID, S1.SHIP_NAME, (SELECT    PORT_NAME
                      FROM      PORTS
                      WHERE     PORT_ID = S1.HOME_PORT_ID) HOME_PORT
FROM    SHIPS S1
WHERE   S1.CAPACITY =   (SELECT  MIN(CAPACITY)
                        FROM    SHIPS S2
                        WHERE   S2.HOME_PORT_ID = S1.HOME_PORT_ID);
                        
/*  If there is a port that a ship is not assigned to. That port will not get 
    updated from the query. */
UPDATE PORTS P
SET     CAPACITY = CAPACITY -1
WHERE EXISTS   (SELECT *     
                FROM SHIPS
                WHERE HOME_PORT_ID = P.PORT_ID);

/*  If there is a port that a ship is not assigned to. That that unused port 
    will get deleted from the ports table. */                
DELETE FROM PORTS P
WHERE NOT EXISTS (SELECT PORT_ID
                  FROM SHIPS
                  WHERE HOME_PORT_ID = P.PORT_ID);
                  
                  
WITH SHIPPER_INFO AS 
        (SELECT SHIP_ID FROM SHIPS)
SELECT PORT_ID
FROM PORTS;
                  
/*  */
SELECT  PORT_NAME
FROM    PORTS P
WHERE   PORT_ID IN (SELECT HOME_PORT_ID
                    FROM    SHIPS
                    WHERE   SHIP_ID IN (1,2,3));
                    


