INSERT INTO CRUISES
    (CRUISE_ID, CRUISE_TYPE_ID, CRUISE_NAME,
     CAPTAIN_ID, START_DATE, END_DATE, STATUS)
VALUES
    (1,1,'Day At Sea',
    101, '02-JAN-10', '09-JAN-10',
    'Sched');
    
INSERT INTO CRUISES
    (CRUISE_ID, CRUISE_NAME,
     STATUS, CAPTAIN_ID, START_DATE, END_DATE)
VALUES
    (2,'Bermuda and Back',
    'DONE',101, '07-APR-08', '14-APR-08');