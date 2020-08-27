-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
-- Я выбрал запрос "Выбрать среднюю зарплату по отделам."

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `average_salary_by_department` AS
select
    avg(`salaries`.`salary`) AS `AVG(salaries.salary)`,
    `departments`.`dept_name` AS `dept_name`
from
    (`salaries`
join (`departments`
join `dept_emp`) on
    (((`dept_emp`.`dept_no` = `departments`.`dept_no`)
    and (`salaries`.`emp_no` = `dept_emp`.`emp_no`))))
group by
    `departments`.`dept_no`
    
    
-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.   


CREATE FUNCTION getManagerId(first_name_in VARCHAR(14), last_name_in VARCHAR(16)) 
RETURNS INT DETERMINISTIC READS SQL DATA
BEGIN 	
	RETURN (
	SELECT
		emp_no
	FROM
		employees
	WHERE
		(first_name = first_name_in
		AND 
		last_name = last_name_in)
		LIMIT 1
	);
END;


--3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.


CREATE TRIGGER `bonus_cash_for_newbie`
AFTER INSERT
ON employees FOR EACH ROW
BEGIN
	INSERT INTO 
		employees.salaries (emp_no, salary, from_date, to_date)
	VALUES
		(NEW.emp_no, 20000, NOW(), NOW());
END


