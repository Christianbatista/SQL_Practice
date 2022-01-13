CREATE TABLE emp_compensation
(employee_id            NUMBER(6),
 salary                 NUMBER(8,2) NOT NULL,
 LAST_CHANGED_DATE      DATE,
CONSTRAINT EMP_ID_FK FOREIGN KEY(employee_id)
            REFERENCES EMPLOYEES (EMPLOYEE_ID));

commit;