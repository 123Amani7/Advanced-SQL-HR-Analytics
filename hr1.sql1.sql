--Task 1: Creating a Simple View
CREATE OR REPLACE VIEW vw_employee_details AS
SELECT
e.first_name,
e.last_name,
d.department_name
FROM  employees e
JOIN departments d ON e.department_id = d.department_id
WITH CHECK OPTION;


--Task 2: Using Date and Time Functions
SELECt *
FROM employees
WHERE hire_date >= CURRENT_DATE -30;

--Task 3: Procedures 
CREATE OR REPLACE PROCEDURE update_job_title (
p_employee_id IN employees.employee_id%TYPE,
p_job_id      IN employees.job_id%TYPE
)
IS
BEGIN
    UPDATE employees 
    SET job_id = p_job_id
    WHERE employee_id = p_employee_id;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT  || ' row(s) updated.');
END;    
/
--Task 4: UDF: Create a function named get_work_years 

CREATE OR REPLACE FUNCTION get_work_years ( 
p_hire_date IN DATE 
)
RETURN NUMBER
IS
    v_years NUMBER;
BEGIN
    v_years:= MONTHS_BETWEEN(SYSDATE, p_hire_date) / 12;
    RETURN FLOOR(v_years);
END;
/

--Task 5 :Triggers Create an AFTER UPDATE trigger on the employees table 
CREATE TABLE department_history (
    employee_id         NUMBER,
    old_department_id   NUMBER,
    new_department_id   NUMBER,
    change_date         DATE
);


CREATE OR REPLACE TRIGGER trg_department_update
AFTER UPDATE OF department_id
ON employees
FOR EACH ROW
BEGIN
     IF :OLD.department_id <> :NEW.department_id THEN
         INSERT INTO department_history (
             employee_id,
             old_department_id,
             new_department_id,
             change_date
          )
          VALUES (
                :NEW.employee_id,
                :OLD.department_id,
                :NEW.department_id,
                SYSDATE
            );
        END IF;
    END;
    
    / 