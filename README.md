# SQL-Challenge

## Background

It’s been two weeks since you were hired as a new data engineer at Pewlett Hackard (a fictional company). Your first major task is to do a research project about people whom the company employed during the 1980s and 1990s. All that remains of the employee database from that period are six CSV files.

For this project, you’ll design the tables to hold the data from the CSV files, import the CSV files into a SQL database, and answer questions about the data, that is, you’ll perform data modeling, data engineering, and data analysis, respectively.

Note: Data generated by Mockaroo, LLC Links to an external site., (2022). Realistic Data Generator.

## Instructions

This Challenge is divided into three parts: data modeling, data engineering, and data analysis.

### Data Modeling & Data Engineering

Inspect the CSV files, and then sketch an Entity Relationship Diagram of the tables using [QuickDBD](https://app.quickdatabasediagrams.com/#/).
Be sure to do the following:
* Remember to specify the data types, primary keys, foreign keys, and other constraints.
* For the primary keys, verify that the column is unique. Otherwise, create a composite key Links to an external site, which takes two primary keys to uniquely identify a row.
* Be sure to create the tables in the correct order to handle the foreign keys.
* Import each CSV file into its corresponding SQL table.

ERD: 
    ![Mod 9 Table Schema](https://github.com/user-attachments/assets/f719ccf8-2ba6-489d-8a35-e8f6f9a7a431)

### Data Analysis

1. List the employee number, last name, first name, sex, and salary of each employee.
    ```SQL
    SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
    FROM employees AS e
    JOIN salaries AS s ON e.emp_no = s.emp_no
    ORDER BY emp_no;
    ```
    ![Q1 output](https://github.com/user-attachments/assets/0e1172a2-f3d2-4080-951f-cd7327943b76)

2. List the first name, last name, and hire date for the employees who were hired in 1986.

    ```SQL
    SELECT e.first_name, e.last_name, e.hire_date
    FROM employees AS e
    WHERE e.hire_date BETWEEN '1986-01-01' AND '1986-12-31';
    ```
    ![Q2 output](https://github.com/user-attachments/assets/0d335bce-8978-41cd-816f-6d7bb750d7c6)

3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

    ```SQL
    SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
    FROM departments AS d
    JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
    JOIN employees AS e ON dm.emp_no = e.emp_no;
    ```
    ![Q3 output](https://github.com/user-attachments/assets/5388485c-28f2-4cca-807c-040c88632455)

4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

    ```SQL
    SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
    FROM dept_emp AS de
    JOIN employees AS e ON de.emp_no = e.emp_no
    JOIN departments AS d ON de.dept_no = d.dept_no
    ORDER BY emp_no;
    ```
    ![Q4 output](https://github.com/user-attachments/assets/61627945-4ca9-4dde-9ae7-fcc0d4f7952f)

5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

    ```SQL
    SELECT e.first_name, e.last_name, e.sex
    FROM employees AS e
    WHERE first_name LIKE 'Hercules'
    AND last_name LIKE 'B%';
    ```
    ![Q5 output](https://github.com/user-attachments/assets/b7c55252-0db6-4aeb-aee0-2cd63de5e84f)

6. List each employee in the Sales department, including their employee number, last name, and first name.

    I implement this query using two approaches: 1) subqueries, and to verify my work, 2) joins. Both yield the same output after ordering. 
    ```SQL
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
    WHERE d.dept_name LIKE 'Sales'
    ORDER BY emp_no;
    ```
    ![Q6 output](https://github.com/user-attachments/assets/3f407d09-51d9-48a1-b006-65ae00c21ce6)
    
7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.


8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).


## Resources

[PostgreSQL 16.6 Documentation](https://www.postgresql.org/files/documentation/pdf/16/postgresql-16-US.pdf)
