CREATE TABLE cruises
( cruise_id             NUMBER,
  cruise_type_id        NUMBER,
  cruise_name           VARCHAR(20),
  captain_id            NUMBER NOT NULL,
  start_date            DATE,
  end_date              DATE,  
  status                VARCHAR2(5) DEFAULT 'DOCK',
  CONSTRAINT cruise_pk PRIMARY KEY (cruise_id));
