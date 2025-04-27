--Library Management Systems Advance Queries

SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status
SELECT * FROM books

/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue. */

SELECT CURRENT_Date

 SELECT ist.issued_member_id,
 m.member_name ,
 b.book_title , 
 ist.issued_date, 
 CURRENT_DATE - ist.issued_date AS over_dues
 FROM issued_status AS ist 
 JOIN
 members AS m 
 ON m.member_id  = ist.issued_member_id 
 JOIN
 books AS b 
 ON b.isbn = ist.issued_book_isbn  
LEFT JOIN return_status AS rs 
 ON  rs.issued_id =  ist.issued_id 
 WHERE 
 rs.return_date IS NULL
 AND 
 (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1 ;

/* Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned 
(based on entries in the return_status table). */

--Stored Procedures 
-- syntax to create procedures 
CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(15), 
    p_issued_id VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_isbn VARCHAR(20);
    v_book_name VARCHAR(75); 
BEGIN
    -- Insert into return_status
    INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE);

    -- Fetch ISBN and book name
    SELECT 
        issued_book_isbn,
        issued_book_name
    INTO 
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Check if the issued_id was found
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Issued ID % not found in issued_status.', p_issued_id;
    END IF;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Final notification
    RAISE NOTICE 'Thank you for returning the book: %', v_book_name; 

END;
$$;




-- Testing function add_return_records 


SELECT * FROM books 
WHERE isbn = '978-0-307-58837-1'

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1'

SELECT * FROM return_status 
--DELETE FROM return_status 
WHERE issued_id = 'IS135'; 

--Calling Functions 
CALL add_return_records('RS138','IS135');

/* Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals */

SELECT * FROM branch
SELECT * FROM employee
SELECT * FROM issued_status
SELECT * FROM books
SELECT * FROM return_statu

CREATE TABLE branch_reports 
AS
SELECT b.branch_id, 
       b.manager_id, 
	   SUM(bk.rental_price) AS total_revenue,
	   COUNT(ist.issued_id) AS No_of_books_issued, 
	   COUNT(rs.return_id) AS no_of_books_returned 
FROM issued_status AS ist
JOIN employee AS e 
ON e.emp_id = ist.issued_emp_id
JOIN branch as b 
ON e.branch_id = b.branch_id
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id 
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn 
GROUP BY 1,2 ; 

SELECT * FROM branch_reports 

/* Task 16: CTAS: Create a Table of Active Members Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 2 months.  */

SELECT * FROM issued_status ; 

CREATE TABLE Active_members 
AS
SELECT * FROM members 
WHERE member_id IN (
        SELECT 
            DISTINCT issued_member_id 
        FROM issued_status 
        WHERE 
             issued_date >= CURRENT_DATE - INTERVAL '1 year 6 month') 

SELECT * FROM Active_members

/* Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch. */ 

SELECT * FROM employee
SELECT * FROM issued_status
SELECT * FROM branch 

SELECT e.emp_id, 
       e.emp_name,  
	   b.branch_id, 
	   COUNT(ist.issued_id) AS no_of_books_processed
FROM employee AS e
JOIN
issued_status AS ist 
ON ist.issued_emp_id = e.emp_id 
JOIN
branch as b 
ON b.branch_id = e.branch_id 

GROUP BY DISTINCT e.emp_id, b.branch_id; 



/*Task 18: Write a query to find the top 3 books that have been issued the most times.
Description: List the book title, book ISBN, and the total number of times it was issued.
Sort the results by the number of times issued, in descending order.
If two books have the same issue count, order them alphabetically by title.*/

SELECT 
    i.issued_book_name AS book_title,
    i.issued_book_isbn AS isbn,
    COUNT(*) AS total_times_issued
FROM issued_status i
GROUP BY i.issued_book_name, i.issued_book_isbn
ORDER BY total_times_issued DESC, book_title ASC
LIMIT 3;

/*Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued,
and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'),
the procedure should return an error message indicating that the book is currently not available. */

--Stored Procedure 

SELECT * FROM books
SELECT * FROM issued_status 



CREATE OR REPLACE PROCEDURE managed_library_system(
    p_issued_id VARCHAR(15),
    p_issued_member_id VARCHAR(15),
    p_issued_book_isbn VARCHAR(25),
    p_issued_emp_id VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(30);
BEGIN
    -- Checking if book is available 
    SELECT status 
    INTO v_status 
    FROM books 
    WHERE isbn = p_issued_book_isbn; 

    IF v_status = 'yes' THEN 
        -- Insert into issued_status
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        -- Update book status to 'no' (means issued)
        UPDATE books 
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;
        
        RAISE NOTICE 'Book records added successfully for book ISBN: %', p_issued_book_isbn; 
    ELSE
        RAISE NOTICE 'The book with ISBN: % is not available.', p_issued_book_isbn; 
    END IF;
END;
$$;



/* Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 
30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines */ 

CREATE TABLE overdue_books_summary AS
SELECT
    issued_member_id AS member_id,
    COUNT(CASE WHEN CURRENT_DATE - issued_date > 30 THEN 1 END) AS number_of_overdue_books,
    SUM(
        CASE 
            WHEN CURRENT_DATE - issued_date > 30 
            THEN (CURRENT_DATE - issued_date - 30) * 0.5 
            ELSE 0 
        END
    ) AS total_fine,
    COUNT(*) AS total_books_issued
FROM issued_status
GROUP BY issued_member_id;






