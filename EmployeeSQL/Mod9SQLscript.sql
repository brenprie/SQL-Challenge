-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/EdpDsg
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


-- CREATE TABLES, SPECIFYING PRIMARY KEYS; ADD FOREIGN KEYS
CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY ("title_id")
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY ("emp_no")
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY ("dept_no")
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY ("dept_no","emp_no")
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY ("emp_no","dept_no")
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY ("emp_no")
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-- AFTER IMPORT CSV DATA FILES, VERIFY THAT THEY HAVE LOADED CORRECTLY
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_manager;
SELECT * FROM dept_emp;
SELECT * FROM salaries;


-- QUERY 1: List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
JOIN salaries AS s ON e.emp_no = s.emp_no
ORDER BY emp_no;

-- QUERY 2: List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE e.hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- QUERY 3: List the manager of each dept along with their dept number, dept name, emp number, last name, and first name. 
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments AS d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no;

-- QUERY 4: List the dept number for each employee along with that employee's emp number, last name, first name, and dept name.
SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp AS de
JOIN employees AS e ON de.emp_no = e.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
ORDER BY emp_no;

-- QUERY 5: List first name, last name, and sex of each employee whose first name is Hercules and last name begins with the letter B.
SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- QUERY 6: List each employee in the Sales department, including their employee number, last name, and first name.
-- version 1 (subqueries)
SELECT e.emp_no, e.last_name, e.first_name
FROM employees AS e
WHERE emp_no IN (
	SELECT emp_no FROM dept_emp WHERE dept_no IN (
		SELECT dept_no FROM departments WHERE dept_name = 'Sales'
		)
	)
ORDER BY emp_no;
-- version 2 (joins)
SELECT e.emp_no, e.last_name, e.first_name
FROM employees AS e
JOIN dept_emp AS de ON de.emp_no = e.emp_no
JOIN departments AS d ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales'
ORDER BY emp_no;

-- QUERY 7: List each employee in the Sales and Development depts, including their emp number, last name, first name, and dept name.
-- version 1 (joins)
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON de.emp_no = e.emp_no
JOIN departments AS d ON d.dept_no = de.dept_no
WHERE d.dept_name IN ('Sales', 'Development')
ORDER BY emp_no;

-- version 2 (subqueries - more clunky, but I want to practice subqueries, 
-- and addressing the fact that departments is not called in the outer SELECT was a puzzle worth solving (with thanks to ChatGPT)
SELECT e.emp_no, e.last_name, e.first_name, 
       (SELECT d.dept_name 
        FROM departments AS d 
        WHERE d.dept_no = de.dept_no) AS dept_name
FROM employees AS e
WHERE e.emp_no IN (
    SELECT de.emp_no
    FROM dept_emp AS de
    WHERE de.dept_no IN (
        SELECT d.dept_no
        FROM departments AS d
        WHERE d.dept_name IN ('Sales', 'Development')
    )
)
ORDER BY e.emp_no;

-- QUERY 8: List the frequency counts, in desc order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) 
FROM employees
GROUP BY last_name
ORDER BY last_name DESC;


