/*  CHAPTER 8 DISPLAYING DATA FROM MULTILPLE TABLES */

/*  How to DELETE a single row in a table */
DELETE FROM PORTS
WHERE port_id = 315; 
--------------------------------------------------------------------------------
/*  Inner Joins, returns a merged row from two or more tables if and only if there
    are matched values among all joined tables. We only return rows where there
    are matched values in the join criteria.*/
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS INNER JOIN PORTS -- The INNER keyword is optional
ON      HOME_PORT_ID = PORT_ID
ORDER BY SHIP_ID;

SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS INNER JOIN PORTS
ON      HOME_PORT_ID = PORT_ID
WHERE   PORT_NAME = 'Charleston'
ORDER BY SHIP_ID;

/*  Older Inner Join Syntax that is not consistent with the ANSI standard for SQL joins.*/
SELECT  S.SHIP_ID, S.SHIP_NAME, P.PORT_NAME
FROM    SHIPS S, PORTS P
WHERE   S.HOME_PORT_ID = P.PORT_ID
ORDER BY S.SHIP_ID;

SELECT  S.SHIP_ID, S.SHIP_NAME, P.PORT_NAME
FROM    SHIPS S, PORTS P
WHERE   S.HOME_PORT_ID = P.PORT_ID
    AND PORT_NAME = 'Charleston'
ORDER BY S.SHIP_ID;
--------------------------------------------------------------------------------
/*  The adjustments to the tables before moving forward */
ALTER TABLE EMPLOYEES
ADD SSN VARCHAR2(11 BYTE);

ALTER TABLE EMPLOYEES
ADD DOB DATE;

ALTER TABLE EMPLOYEES
ADD PRIMARY_PHONE VARCHAR2(20 BYTE);

/*  Reordering the columns within the table.*/
ALTER TABLE EMPLOYEES MODIFY(START_DATE INVISIBLE, SALARY INVISIBLE);

ALTER TABLE EMPLOYEES MODIFY(START_DATE VISIBLE, SALARY VISIBLE);

DESC ADDRESSES;

ALTER TABLE ADDRESSES
ADD STREET_ADDRESS2 VARCHAR2(40 BYTE);

ALTER TABLE ADDRESSES
ADD ZIP VARCHAR2(5 BYTE);

ALTER TABLE ADDRESSES
ADD ZIP_PLUS VARCHAR2(4 BYTE);

ALTER TABLE ADDRESSES
ADD EMPLOYEE_ID NUMBER CONSTRAINT FK_EMPLOYEE_ID REFERENCES EMPLOYEES (EMPLOYEE_ID);

ALTER TABLE ADDRESSES MODIFY(STREET_ADDRESS INVISIBLE, CITY INVISIBLE, 
                            STATE INVISIBLE,COUNTRY INVISIBLE,STREET_ADDRESS2 INVISIBLE,
                            ZIP INVISIBLE,ZIP_PLUS INVISIBLE);

ALTER TABLE ADDRESSES MODIFY(STREET_ADDRESS VISIBLE,STREET_ADDRESS2 VISIBLE, 
                                CITY VISIBLE, STATE VISIBLE,ZIP VISIBLE,
                            ZIP_PLUS VISIBLE,COUNTRY VISIBLE);

INSERT INTO ADDRESSES
VALUES  (7,7,'421 Cooper Mill Rd',null,'North Augusta','SC',29860,null,'USA');

-------------------------------------------------------------------------------
/*  Now that all the adjustments have been completed we can run a statement against 
    the EMPLOYEES and ADDRESSES Table. They are related to eachother through 
    EMPLOYEE_ID*/
SELECT  EMPLOYEES.EMPLOYEE_ID,LAST_NAME,STREET_ADDRESS
FROM    EMPLOYEES   INNER JOIN ADDRESSES
ON      EMPLOYEES.EMPLOYEE_ID = ADDRESSES.EMPLOYEE_ID
ORDER BY EMPLOYEES.EMPLOYEE_ID;

/*  We are using a NATUREAL JOIN in this example. The natural join approach tells
    SQL to locate any columns in the two tables with a common name, and use them
    to join the tables. */
SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES NATURAL JOIN ADDRESSES; 

SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES NATURAL LEFT OUTER JOIN ADDRESSES; 

SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES NATURAL RIGHT OUTER JOIN ADDRESSES; 

SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES NATURAL FULL OUTER JOIN ADDRESSES; 
--------------------------------------------------------------------------------
/*  Table adjustments before moving forward */
ALTER TABLE EMPLOYEES
ADD OFFICE_NAME VARCHAR2(20 CHAR);

ALTER TABLE ADDRESSES
ADD OFFICE_NAME VARCHAR2(20 CHAR);

/*  Lets rename ADDRESSES to easily distinguish between employee addresses and 
    employer office addresses./*/
ALTER TABLE "C##CCL"."ADDRESSES" RENAME TO EMPLOYEE_ADDRESSES;

/*  Create new table for all the different employer addresses*/
CREATE TABLE EMPLOYER_ADDRESSES(
ADDRESS_ID      NUMBER,
STREET_ADDRESS  VARCHAR2(60),
EMPLOYEE_ID     NUMBER,
OFFICE_NAME     VARCHAR2(40));

/*  We added the constraint afterwards*/
ALTER TABLE EMPLOYER_ADDRESSES 
ADD CONSTRAINT EMPLOYEE_ID_FK FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

/*  The keyword USING is similar to the natural join*/
SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES   LEFT JOIN EMPLOYER_ADDRESSES
USING (EMPLOYEE_ID)
ORDER BY EMPLOYEE_ID;    

/*  This example assumes the presence of an additional column(OFFICE_NAME) in 
    both tables and performs the join using the combination of EMPLOYEE_ID and
    OFFICE_NAME. In the example of employee_id '5', Smith, the office_name is 
    different in both tables thus the result will be null.*/
SELECT  EMPLOYEE_ID, LAST_NAME, STREET_ADDRESS
FROM    EMPLOYEES   LEFT JOIN EMPLOYER_ADDRESSES
USING (EMPLOYEE_ID, OFFICE_NAME)
ORDER BY EMPLOYEE_ID;

ALTER TABLE SHIPS
ADD CONSTRAINT SHIP_ID_PK PRIMARY KEY(SHIP_ID);

ALTER TABLE SHIP_CABINS
ADD CONSTRAINT FK_SHIP_ID FOREIGN KEY(SHIP_ID) REFERENCES SHIPS(SHIP_ID);

/* Rename constraint name */
ALTER TABLE SHIPS RENAME CONSTRAINT SHIPS_PORTS_FK TO HOME_PORT_ID;

SELECT  P.PORT_NAME, S.SHIP_NAME,SC.ROOM_NUMBER
FROM    PORTS P JOIN SHIPS S ON P.PORT_ID = S.HOME_PORT_ID
                JOIN SHIP_CABINS SC ON S.SHIP_ID =SC.SHIP_ID;

/*  CREATE GRADING TABLE */
CREATE TABLE GRADING(
GRADING_ID  NUMBER,
GRADE       CHAR(1 BYTE),
SCORE_MIN   NUMBER(3),
SCORE_MAX   NUMBER(3)
);
ALTER TABLE GRADING ADD CONSTRAINT GRADING_ID_PK PRIMARY KEY(GRADING_ID);

CREATE TABLE SCORES(
SCORES_ID   NUMBER CONSTRAINT SCORES_ID_PK PRIMARY KEY,
TEST_SCORE  VARCHAR2(5 BYTE),
UPDATED_TEST_SCORE  VARCHAR2(5BYTE)
);
/*  Data inputed into SCORES table*/
INSERT INTO SCORES
VALUES (1,95,NULL);

INSERT INTO SCORES
VALUES (2,55,NULL);

INSERT INTO SCORES
VALUES (3,83,NULL);

/*  There is no foreign key in this example
    this is an non-equijoin and the syntax of the ON condition 
    in this non-equijoin is similar to the syntax for the WHERE
    clause in the SELECT.*/
SELECT S.SCORES_ID, S.TEST_SCORE, G.GRADE
FROM SCORES S JOIN GRADING G
ON  S.TEST_SCORE BETWEEN G.SCORE_MIN AND G.SCORE_MAX;
--------------------------------------------------------------------------------
/*  SELF-JOIN SECTION */

/*  First lets add some columns to the POISTIONS table */
ALTER TABLE POSITIONS
ADD (   REPORTS_TO  NUMBER(4),
        MIN_SALARY NUMBER(10,2),
        MAX_SALARY NUMBER(10,2)
    );
        
/*  Lets also move the EXEMPT column so that its the last column in the table */
ALTER TABLE POSITIONS
MODIFY( EXEMPT INVISIBLE);
ALTER TABLE POSITIONS
MODIFY( EXEMPT VISIBLE);

/*  UPDATED columns in row 1 to NULL*/
UPDATE POSITIONS
SET POSITION = NULL, EXEMPT = NULL
WHERE POSITION_ID = 1;

/*  Self-Referencing Foreign Keys 
    NOTE that a foreign key is advisse but not required in order to perform the
    self-join. */
ALTER TABLE POSITIONS
ADD CONSTRAINT FK_PO_PO FOREIGN KEY (REPORTS_TO)
    REFERENCES POSITIONS(POSITION_ID);
    
SELECT  A.POSITION_ID, A.POSITION, B.POSITION BOSS
FROM    POSITIONS A LEFT OUTER JOIN POSITIONS B
ON      A.REPORTS_TO = B.POSITION_ID
ORDER BY  A.POSITION_ID;

-------------------------------------------------------------------------------
/*  LEFT OUTER JOIN */

/*  What the author failed to explain but is observable from the results is that
    the direction of the join matters (LEFT or RIGHT) in the below example since
    this is a LEFT join. the SHIPS table is our priority table. The LEFT JOIN 
    returns unmateched rows from the left side of the join.*/
SELECT  SHIP_ID,SHIP_NAME, PORT_NAME
FROM    SHIPS LEFT OUTER JOIN PORTS -- the keyword OUTER is optional
ON      HOME_PORT_ID   = PORT_ID
ORDER BY SHIP_ID;

/*  What the author failed to explain but is observable from the results is that
    the direction of the join matters (LEFT or RIGHT) in the below example since
    this is a RIGHT join. the PORTS table is our priority table. The RIGHT JOIN 
    returns unmateched rows from the right side of the join.*/
SELECT  SHIP_ID,SHIP_NAME, PORT_NAME
FROM    SHIPS RIGHT OUTER JOIN PORTS
ON      HOME_PORT_ID   = PORT_ID
ORDER BY SHIP_ID;

/*  If you want to combine the effects of a RIGHT OUTER JOIN and LEFT OUTER JOIN,
    we can us the FULL OUTER JOIN. In the results we have all of our rows merged,
    but all returned regardless.*/
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS FULL OUTER JOIN PORTS -- the keyword OUTER is optional
ON      HOME_PORT_ID = PORT_ID
ORDER BY SHIP_ID;

/*  Not on the exam is the Oracle Outer Join Syntax: (+). You can think of it as 
    which ever side the (+) is on as adding fake NULL rows indicating that no
    matching rows were found in respect to all of the included returned rows 
    that are in the "other" table you are joining.*/
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS, PORTS 
WHERE   HOME_PORT_ID = PORT_ID(+) --We have replaced the ON keyword with WHERE.
ORDER BY SHIP_ID;
    
/*  Moving the (+) to the other side.*/
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS, PORTS 
WHERE   HOME_PORT_ID(+) = PORT_ID --We have replaced the ON keyword with WHERE.
ORDER BY SHIP_ID;

/*  You can't really do a full outer join using this syntax, but you can use the
    set operator UNION to combine a left outer join and a right outer join to
    achieve the same result.*/
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS, PORTS 
WHERE   HOME_PORT_ID = PORT_ID(+)
UNION
SELECT  SHIP_ID, SHIP_NAME, PORT_NAME
FROM    SHIPS, PORTS 
WHERE   HOME_PORT_ID(+) = PORT_ID
ORDER BY SHIP_ID;


CREATE TABLE PAY_HISTORY(
PAY_HISTORY_ID  NUMBER,
EMPLOYEE_ID     NUMBER,
SALARY          NUMBER(10,2),
START_DATE      DATE,
END_DATE        DATE
);
COMMIT;








