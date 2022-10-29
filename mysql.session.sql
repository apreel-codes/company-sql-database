
DROP TABLE studentInfo;

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- inserting the data

-- Corporate branch

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL); 
-- branch_id is NULL becuase that branch_id hasn't been created yet

-- now the branch just got added
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

-- now adding the branch to David Wallace's row
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

-- inserting Jan Levinson into the employee table too and adding the Corporate branch_id in the entry
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);


-- Scranton branch- the same process as above

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);


-- Stamford branch- the same process as above

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- branch supplier

INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');


-- client table

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);


-- works_with table

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


-- find all employees
select *
from employee;

-- find all employees ordered by salary in descending order
select * 
from employee
order by salary desc;

-- find all employees ordered by sex then name
select *
from employee
order by sex, first_name, last_name;

-- find the first 5 employees
select *
from employee
limit 5;

-- find the first and last name of all employees
select first_name as forename, last_name as surname
from employee;

-- find out all the different genders
select distinct sex
from employee;

-- find out all the different branche ids
select distinct branch_id
from employee;

--find out the total number of employees
select count(emp_id)
from employee;

-- find the total of female employees born after 1970
select count(emp_id)
from employee
where sex = 'F' and birth_day > '1970-12-31';

-- avg of all employees' salary
select AVG(salary)
from employee;

-- avg of all male employees' salary
select AVG(salary)
from employee
where sex = 'M';

-- sum of all salaries
select sum(salary)
from employee;

-- find out how many males and females there are in the company
select count(sex), sex
from employee
group by sex;

-- find the total sales of each salesman
select sum(total_sales), emp_id
from works_with
group by emp_id;

-- find all clients who is/are an LLC
select *
from client
where client_name like '%LLC';

-- find any branch suppliers who are in the label business
select *
from branch_supplier
where supplier_name like '%Label%';

-- find any employee born in October
select *
from employee
where birth_day like '____-02%';

-- find any client who are schools
select *
from client
where client_name like '%school%';

-- find a list of employee and branch names
select first_name
from employee
UNION
select branch_name
from branch;

-- list of all clients and branch suppliers' names
select client_name
from client
UNION
select supplier_name
from branch_supplier;

--find a list of all money spent or earned by the company
select salary
from employee
UNION
select total_sales
from works_with;


-- JOINS --
-- inserting another branch in the branch table
insert into branch values(4, 'Buffalo', NULL, NULL);

select * 
from branch;

-- find all branches and for these branches, find the names of their managers
select employee.emp_id, employee.first_name, branch.branch_name
from employee
join branch
on employee.emp_id = branch.mgr_id; --the related columns


-- find names of employees who have sold over 30, 000 to a single client
-- first, find all employees by emp_id that have sold over 30k at all in the works_with table
-- select works_with.emp_id
-- from works_with
-- where total_sales > 30000;

-- next is to get the employees' first_name and last_name using the emp_id
select employee.first_name, employee.last_name
from employee
where employee.emp_id in ( -- the nest the previous query inside this
    select works_with.emp_id
    from works_with
    where total_sales > 30000
);


--find all the clients who are handled by the branch that Michael Scott manages
-- first find the branch Michael manages

-- select branch.branch_id
-- from branch
-- where branch.mgr_id = 102;

select client.client_name
from client
where client.branch_id = (
    select branch.branch_id
    from branch
    where branch.mgr_id = 102
    limit 1
);




-- working with triggers
CREATE TABLE trigger_test (
     message VARCHAR(100)
);


-- create a new trigger
--my_trigger is the name of the trigger(function)
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT 
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;

-- what the above code id doing is "before any new item is inserted into the employee table, for each row that'll be getting a value, i want to insert the trigger_test table value which is a message
-- and this message is 'added new employee'"


--then copy all these line by name in the command line

-- now let's add another employee into the employee table
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

select * from trigger_test; -- will show 'added new employee'




-- another trigger example
--NEW refers to the specific row the values are being inserted
DELIMITER $$
CREATE
    TRIGGER my_trigger1 BEFORE INSERT 
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;


--add a new employee
INSERT INTO employee
VALUES(111, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

select * from trigger_test;



-- working with triggers and conditionals
--if the sex of the new value added is M, then add that etc.
DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT --INSERT can also be DELETE or UPDATE
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;

--add a new employee
INSERT INTO employee
VALUES(112, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

select * from trigger_test;


-- to drop trigger
DROP TRIGGER my_trigger;
