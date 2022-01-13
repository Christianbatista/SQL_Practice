CREATE TABLE positions
( position_id           NUMBER,
  position              VARCHAR2(20),
  exempt                CHAR(1),
  CONSTRAINT positions_pk PRIMARY KEY (position_id)
);