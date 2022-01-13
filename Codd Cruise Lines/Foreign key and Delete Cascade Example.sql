CREATE TABLE SHIPS
(SHIP_ID        NUMBER CONSTRAINT SHIP_ID_PK PRIMARY KEY,
 SHIP_NAME      VARCHAR2(20),
 HOME_PORT_ID   NUMBER,
 CONSTRAINT     SHIPS_PORT_FK FOREIGN KEY   (HOME_PORT_ID)   /* The HOME_PORT_ID is the name of the column that we are identifing as Foreign meaning its root is at another table */
                                REFERENCES PORTS (PORT_ID)   /* REFERENCES dictates the Table then the "Column" you are choosing from */       
                                ON DELETE CASCADE);          /* DELETE CASCADE will remore all ship rows assigned to a PORT row upon the PORT row's removal from the PORTS table */