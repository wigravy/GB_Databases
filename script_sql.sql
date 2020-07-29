// База данных «Страны и города мира»:
// 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.

SELECT
	_cities.title, 
	_countries.title, 
	_regions.title
FROM
	_cities
JOIN
	(_regions,
	_countries)
ON
	_cities.country_id = _countries.id
	AND
	_cities.region_id = _regions.id 	
	
	
// 2. Выбрать все города из Московской области.

SELECT
	_cities.title, _regions.title
FROM
	_cities
JOIN
	_regions
ON 
	_cities.region_id = _regions.id 
WHERE 
	_regions.title = 'Московская область'
	

// База данных «Сотрудники»:
// 1. Выбрать среднюю зарплату по отделам.


SELECT
	AVG(salaries.salary), 
	departments.dept_name	
FROM
	salaries
JOIN
	(departments,
	dept_emp)
ON
	dept_emp.dept_no = departments.dept_no 
	AND 
	salaries.emp_no = dept_emp.emp_no
GROUP BY 
	departments.dept_no

	
// 2. Выбрать максимальную зарплату у сотрудника.


SELECT
	employees.first_name,
	employees.last_name,
	salaries.salary
FROM
	employees
JOIN	
	salaries
ON
	(employees.emp_no = salaries.emp_no)
ORDER BY
	salary DESC
LIMIT 1;


// 3. Удалить одного сотрудника, у которого максимальная зарплата.


DELETE FROM employees
WHERE 
	emp_no =(
	SELECT 
		salaries.emp_no
	FROM 
		salaries
	ORDER BY
		salary DESC
	LIMIT 1	
	);
	
// 4. Посчитать количество сотрудников во всех отделах.


SELECT 
	departments.dept_name, 
	COUNT(*) as count
FROM 
	employees
JOIN
	(dept_emp, 
	departments)
ON
	employees.emp_no = dept_emp.emp_no
	AND
	dept_emp.dept_no = departments.dept_no
GROUP BY 
	departments.dept_no
ORDER BY
	count DESC;
	
	
// 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.


SELECT
	departments.dept_name,
	COUNT(*),
	SUM(salary)
FROM
	salaries
JOIN 
	(employees,
	dept_emp, 
	departments) 
ON
	employees.emp_no = salaries.emp_no	
	AND 
	dept_emp.emp_no = employees.emp_no
	AND 
	departments.dept_no = dept_emp.dept_no
GROUP BY
	departments.dept_name;
	



