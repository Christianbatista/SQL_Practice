CREATE DIRECTORY INVOICE_FILES AS 'C:\LOAD_INVOICES';

CREATE TABLE INVOICES_EXTERNAL
( INVOICE_ID        CHAR(3),
  INVOICE_DATE      CHAR(9),
  ACCOUNT_NUMBER    CHAR(13)
)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
    DEFAULT DIRECTORY INVOICE_FILES
    ACCESS PARAMETERS
        (RECORDS DELIMITED BY NEWLINE
        SKIP 2                              /*'SKIP 2'  means that the first two lines of the txt file are to be skipped they just contain header info */
        FIELDS  (INVOICE_ID     CHAR(3),
                 INVOICE_DATE   CHAR(9),
                 ACCOUNT_NUMBER CHAR(13))
        )
    LOCATION    ('INVOICE_DATA.TXT')
    );
