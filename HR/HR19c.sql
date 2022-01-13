/*  The following example calculates the rank of a hypothetical employee in the 
    sample table hr.employees with a salary of $15,500 and a commission of 5%*/
SELECT RANK(15500, .05) WITHIN GROUP
   (ORDER BY salary, commission_pct) "Rank"
   FROM employees;