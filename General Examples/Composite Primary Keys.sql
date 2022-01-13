CREATE TABLE HelpDesk
( HD_Category   VARCHAR2(8),
  HD_Year       NUMBER,
  HD_Ticket_No  NUMBER,
  HD_Title      VARCHAR2(30),
  CONSTRAINT    HelpDesk_PK PRIMARY KEY     (HD_Category, HD_Year, HD_Ticket_No)); /* The preceding code has the effect of creating NOT NULL and UNIQUE constraints across all three columns */