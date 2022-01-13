CREATE TABLE employees
( employee_id           NUMBER,
  ship_id               NUMBER,
  first_name            VARCHAR2(20),
  last_name             VARCHAR2(30),
  position_id           NUMBER,
  CONSTRAINT employee_pk PRIMARY KEY (employee_id));