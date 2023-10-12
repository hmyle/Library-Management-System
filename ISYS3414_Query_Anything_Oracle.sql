-- VIEW TO CREATE STAFF DETAIL PAGE --
CREATE OR REPLACE VIEW staff_detail AS
SELECT LISTAGG(staff.first_name || ' ' || staff.last_name, ', ') WITHIN GROUP (ORDER BY staff.last_name) AS full_name, staff.phone_num, position.name AS position_name
FROM staff
JOIN position ON staff.Position_ID = position.ID
GROUP BY staff.phone_num, position.name;

-- VIEWS TO CREATE DEPARTMENT DETAIL REPORT --
-- Accountant Detail View
CREATE OR REPLACE VIEW accountant_detail AS
SELECT s.first_name || ' ' || s.last_name AS accountant_name, a.staff_id AS accountant_id, v.status AS cpa_validation_status
FROM accountant a
JOIN cpa_validation v ON a.cpa_status = v.id
JOIN staff s ON a.staff_id = s.id;

-- Janitor Detail View
CREATE OR REPLACE VIEW janitor_detail AS
SELECT j.staff_id, s.first_name || ' ' || s.last_name AS name, j.shift
FROM janitor j
JOIN staff s ON j.staff_id = s.id;

-- Librarian Detail View
CREATE OR REPLACE VIEW librarian_detail AS
SELECT s.first_name || ' ' || s.last_name AS librarian_name, l.staff_id AS librarian_id, t.title_name AS librarian_title
FROM librarian l
JOIN librarian_titles t ON l.title = t.title_id
JOIN staff s ON l.staff_id = s.id;

-- VIEW TO CREATE AUTHOR DETAIL --
CREATE OR REPLACE VIEW author_detail AS
SELECT
LISTAGG(a.first_name || ' ' || a.last_name, ', ') WITHIN GROUP (ORDER BY a.id) AS Author_name,
LISTAGG(b.title, ', ') WITHIN GROUP (ORDER BY b.title) AS Books
FROM
author a
JOIN book_author ba ON a.id = ba.author_id
JOIN book b ON ba.book_id = b.id
GROUP BY
a.id, a.first_name, a.last_name;

-- VIEW TO CREATE BOOK INFORMATION PAGE --
CREATE OR REPLACE VIEW book_information AS
SELECT
b.id,
b.title,
b.publication_date,
b.copies_owned,
LISTAGG(a.first_name || ' ' || a.last_name, ', ') WITHIN GROUP (ORDER BY ba.book_id) AS author_names,
c.category_name AS category,
s.first_name || ' ' || s.last_name AS acquired_by
FROM book b
INNER JOIN book_author ba ON b.id = ba.book_id
INNER JOIN author a ON ba.author_id = a.id
INNER JOIN category c ON b.category_id = c.id
LEFT JOIN staff s ON b.staff_id = s.id
GROUP BY
b.id,
b.title,
b.publication_date,
b.copies_owned,
c.category_name,
s.first_name,
s.last_name;

-- VIEW TO CREATE LOAN REPORT PAGE --
CREATE OR REPLACE VIEW loan_report AS
SELECT m.first_name || ' ' || m.last_name AS member_name,
b.title AS book_name,
l.loan_date,
l.returned_date,
st.first_name || ' ' || st.last_name AS librarian_incharge
FROM loan l
JOIN member m ON l.member_id = m.id
JOIN book b ON l.book_id = b.id
JOIN staff st ON l.staff_id = st.id;
-- VIEW TO CREATE FINES REPORT PAGE --
CREATE OR REPLACE VIEW fines_report AS
SELECT
f.id AS fine_id,
m.first_name || ' ' || m.last_name AS member_name,
b.title AS book_borrowed,
f.fine_date AS fine_date,
f.fine_amount AS fine_amount
FROM fine f
INNER JOIN loan l ON f.loan_id = l.id
INNER JOIN member m ON l.member_id = m.id
INNER JOIN book b ON l.book_id = b.id;

-- VIEW TO CREATE FINE PAYMENT REPORT --
CREATE OR REPLACE VIEW fine_payment_report AS
SELECT m.last_name || ' ' || m.first_name AS member_name,
fp.payment_amount,
fp.payment_date,
s.last_name || ' ' || s.first_name AS accountant_name
FROM fine_payment fp
JOIN member m ON fp.member_id = m.id
JOIN staff s ON s.id = fp.staff_id;

-- VIEW TO CREATE RESERVATION REPORT PAGE --
CREATE OR REPLACE VIEW reservation_report AS
SELECT
b.title AS book,
m.first_name || ' ' || m.last_name AS member_name,
rs.status_value AS reservation_status,
r.reservation_date
FROM reservation r
JOIN book b ON b.id = r.book_id
JOIN member m ON m.id = r.member_id
JOIN member_status ms ON ms.id = m.active_status_id
JOIN reservation_status rs ON rs.id = r.reservation_status_id;

-- VIEW TO CREATE MEMBER REPORT PAGE --
CREATE OR REPLACE VIEW member_report AS
SELECT
m.id,
m.first_name || ' ' || m.last_name AS name,
m.joined_date,
ms.status_value AS active_status_name,
m.sex_id,
m.phone_num,
LISTAGG(b.title, ', ') WITHIN GROUP (ORDER BY b.title) AS borrowed_books,
COALESCE(SUM(f.fine_amount), 0) AS total_fine
FROM
member m
LEFT JOIN loan l ON m.id = l.member_id
LEFT JOIN book b ON l.book_id = b.id
LEFT JOIN fine f ON l.id = f.loan_id
LEFT JOIN member_status ms ON m.active_status_id = ms.id
GROUP BY
m.id,
m.first_name || ' ' || m.last_name,
m.joined_date,
m.active_status_id,
m.sex_id,
m.phone_num,
ms.status_value;

-- VIEWS TO CREATE THE CALENDAR PAGE --
-- Loans Calendar View
CREATE OR REPLACE VIEW loans_calendar AS
SELECT m.first_name || ' ' || m.last_name AS member_name, l.loan_date, l.returned_date
FROM loan l
JOIN member m ON l.member_id = m.id;

-- Reservation Calendar View
CREATE OR REPLACE VIEW reservations_calendar AS
SELECT m.First_name || ' ' || m.Last_name AS member_name, r.id AS reservation_id, r.Reservation_date
FROM member m
JOIN reservation r ON m.id = r.member_id;

-- VIEWS TO CREATE CHARTS AND GRAPHS --
-- Member Role Chart uses the member_report
-- Gender Chart View
CREATE OR REPLACE VIEW gender AS
SELECT s.name AS gender_name, COUNT(*) AS gender_count
FROM member m
JOIN sex s ON m.sex_id = s.id
GROUP BY s.name;

-- Book Categories Chart View
CREATE OR REPLACE VIEW categories_chart AS
SELECT category.category_name, COUNT(book.id) AS book_count
FROM category
LEFT JOIN book ON category.id = book.category_id
GROUP BY category.category_name;

-- Loans per Month Chart View
CREATE OR REPLACE VIEW loans_chart AS
SELECT TO_CHAR(loan_date, 'Month YYYY') AS month_year, COUNT(*) AS num_loans
FROM loan
GROUP BY TO_CHAR(loan_date, 'Month YYYY')
ORDER BY MIN(loan_date);

-- Fine Revenue Chart View
CREATE OR REPLACE VIEW fine_revenue_chart AS
SELECT TO_CHAR(payment_date, 'Month YYYY') AS month_year, SUM(payment_amount) AS total_fines
FROM fine_payment
GROUP BY TO_CHAR(payment_date, 'Month YYYY')
ORDER BY MIN(payment_date);

-- Librarian Performance Chart View
CREATE OR REPLACE VIEW librarian_performance AS
SELECT s.id AS staff_id, s.first_name || ' ' || s.last_name AS full_name,
COUNT(DISTINCT l.member_id) AS total_loans, COUNT(DISTINCT b.id) AS total_books
FROM staff s
LEFT JOIN loan l ON s.id = l.staff_id
LEFT JOIN book b ON s.id = b.staff_id
GROUP BY s.id, s.first_name || ' ' || s.last_name;

-- END OF VIEWS --