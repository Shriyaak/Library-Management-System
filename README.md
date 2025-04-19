
Project Title: Library Management System <br/>
Level: Intermediate <br/>
Dataset:  <br/>
![Page](https://github.com/Shriyaak/Library-Management-System/blob/116937053f30d865d6f32a9382698e592bb098d6/Screenshot%202025-04-19%20224918.png)

<br/>
This project showcases the development of a Library Management System using SQL. It involves designing and managing database tables, carrying out CRUD operations, and running complex SQL queries. The objective is to highlight proficiency in database structure, data handling, and query executio

## Data Model: 
![Model](https://github.com/Shriyaak/Library-Management-System/blob/116937053f30d865d6f32a9382698e592bb098d6/Data%20Model.png)
## CRUD Operations:  
Create: Inserted sample records into the books table. <br/>
Read: Retrieved and displayed data from various tables. <br/>
Update: Updated records in the employees table. <br/>
Delete: Removed records from the members table as needed. <br/> 

### Tasks: 

Task 1: Create a New Book Record <br/> 
Inserted a new book entry into the books table using the INSERT INTO statement and verified it with a record count query. <br/> 

Task 2: Update Member Information <br/> 
Updated the address of a specific member (member_id = 'C101') using the UPDATE statement. <br/> 

Task 3: Delete a Record from Issued Status <br/> 
Removed an issued record from the issued_status table where issued_id = 'IS121'. <br/> 

Task 4: Retrieve Books Issued by an Employee <br/> 
Queried the issued_status table to list books issued by a specific employee (emp_id = 'E101'). <br/> 

Task 5: Identify Employees Who Issued Multiple Books <br/> 
Used GROUP BY and HAVING clauses to identify employees who have issued more than one book. <br/> 

Task 6: Create a Summary Table of Book Issue Counts <br/> 
Created a new table book_count using CTAS (Create Table As Select) to summarize how many times each book was issued. <br/> 

Task 7: Retrieve Books by Category <br/> 
Queried all books from the books table that fall under the "History" category. <br/> 

Task 8: Calculate Rental Income by Category <br/> 
Used JOIN, SUM, and GROUP BY to calculate the total rental income and count of books issued per category. <br/> 

Task 9: List Recently Registered Members <br/> 
Retrieved all members who registered within the last 180 days using date-based filtering. <br/> 

Task 10: List Employees Along with Their Branch Manager <br/> 
Joined the employee and branch tables to display each employee’s branch details along with their respective manager's name. <br/> 

Task 11: Create Table for Expensive Books <br/> 
Created a new table expensive_books containing all books with a rental price greater than 6. <br/> 

Task 12: Retrieve List of Unreturned Books <br/> 
Used LEFT JOIN between issued_status and return_status tables to find books that have not yet been returned. <br/>  

## Advanced SQL Operations
