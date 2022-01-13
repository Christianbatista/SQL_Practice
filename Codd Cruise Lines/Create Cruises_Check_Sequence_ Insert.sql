CREATE TABLE CRUISES
(CRUISE_ID      NUMBER,
 CRUISE_NAME    VARCHAR2(30),
 START_DATE     DATE,
 END_DATE       DATE,
 CONSTRAINT     CRUISE_ID_PK PRIMARY KEY (CRUISE_ID),
 CONSTRAINT     CRUISE_NAME_CK CHECK
                (CRUISE_NAME IN ('Hawaii', 'Bahamas' , 'Bermuda',
                                'Mexico', 'Day at Sea')
                )
);

CREATE SEQUENCE SEQ_CRUISE_ID;

INSERT INTO CRUISES
        (CRUISE_ID, CRUISE_NAME)
VALUES
        (SEQ_CRUISE_ID.NEXTVAL, 'Hawaii');