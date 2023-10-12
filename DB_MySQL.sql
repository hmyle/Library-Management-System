CREATE TABLE position (
  id INT PRIMARY KEY,
  name VARCHAR(50) UNIQUE
);

CREATE TABLE staff (
  id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  phone_num VARCHAR(20) UNIQUE,
  position_id INT NOT NULL,
  CONSTRAINT fk_staff_position FOREIGN KEY (position_id) REFERENCES position (id)
);



CREATE TABLE cpa_validation (
  id INT PRIMARY KEY,
  status VARCHAR(50) UNIQUE
);



CREATE TABLE librarian_titles (
  title_id INT NOT NULL,
  title_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (title_id)
);


CREATE TABLE accountant (
  staff_id INT PRIMARY KEY,
  cpa_status INT NOT NULL,
  CONSTRAINT fk_accountant_staff FOREIGN KEY (staff_id) REFERENCES staff(id),
  CONSTRAINT fk_accountant_cpa_validation FOREIGN KEY (cpa_status) REFERENCES cpa_validation(id)
);

CREATE TABLE janitor (
  staff_id INT PRIMARY KEY,
  shift VARCHAR(20),
  CONSTRAINT fk_janitor_staff FOREIGN KEY (staff_id) REFERENCES staff(id)
);

CREATE TABLE librarian (
  staff_id INT PRIMARY KEY,
  title INT,
  CONSTRAINT fk_librarian_staff FOREIGN KEY (staff_id) REFERENCES staff(id),
  CONSTRAINT fk_librarian_title FOREIGN KEY (title) REFERENCES librarian_titles(title_id)
);

CREATE TABLE reservation_status (
  id INT,
  status_value VARCHAR(50) not null,
  CONSTRAINT pk_res_status PRIMARY KEY (id)
);

CREATE TABLE category (
  id INT,
  category_name VARCHAR(100) not null,
  CONSTRAINT pk_category PRIMARY KEY (id)
);

CREATE TABLE book (
  id INT,
  title VARCHAR(500) UNIQUE NOT NULL,
  category_id INT not null,
  publication_date DATE not null,
  copies_owned INT not null,
  staff_id	INT not null,
  CONSTRAINT pk_book PRIMARY KEY (id),
  CONSTRAINT fk_book_category FOREIGN KEY (category_id) REFERENCES category(id),
  CONSTRAINT fk_staff_id FOREIGN KEY (staff_id) REFERENCES LIBRARIAN(STAFF_ID)
);

CREATE TABLE author (
  id INT,
  first_name VARCHAR(300)	NOT NULL,
  last_name VARCHAR(300),
  CONSTRAINT pk_author PRIMARY KEY (id)
);

CREATE TABLE member_status (
  id INT,
  status_value VARCHAR(50) not null,
  CONSTRAINT pk_memberstatus PRIMARY KEY (id)
);

CREATE TABLE sex(
  id INT,
  name VARCHAR(200) not null,
  CONSTRAINT pk_sex PRIMARY KEY (id)
);

CREATE TABLE member (
  id INT,
  First_name VARCHAR(50),
  Last_name VARCHAR(50),
  joined_date DATE not null,
  active_status_id INT not null,
  phone_num	VARCHAR(50) not null,
  sex_id INT not null,
  CONSTRAINT pk_member PRIMARY KEY (id),
  CONSTRAINT fk_member_status FOREIGN KEY (active_status_id) REFERENCES member_status(id),
  CONSTRAINT fk_sex FOREIGN KEY (sex_id) REFERENCES sex(id)
);

CREATE TABLE reservation (
  id INT,
  book_id INT not null,
  member_id INT not null,
  reservation_date DATE not null,
  reservation_status_id INT not null,
  CONSTRAINT pk_reservation PRIMARY KEY (id),
  CONSTRAINT fk_res_book FOREIGN KEY (book_id) REFERENCES book(id),
  CONSTRAINT fk_res_member FOREIGN KEY (member_id) REFERENCES member(id),
  CONSTRAINT fk_res_status FOREIGN KEY (reservation_status_id) REFERENCES reservation_status(id)
);


CREATE TABLE fine_payment (
  id INT,
  member_id INT not null,
  payment_date DATE not null,
  payment_amount INT not null,
  staff_id INT not null,
  CONSTRAINT pk_fine_payment PRIMARY KEY (id),
  CONSTRAINT fk_finepay_member FOREIGN KEY (member_id) REFERENCES member(id),
  CONSTRAINT fk_accountant_id FOREIGN KEY (staff_id) REFERENCES accountant(STAFF_ID)
);

CREATE TABLE loan (
  id INT,
  book_id INT	NOT NULL,
  member_id INT	NOT NULL,
  loan_date DATE not null,
  returned_date DATE not null,
  staff_id INT NOT NULL,
  CONSTRAINT pk_loan PRIMARY KEY (id),
  CONSTRAINT fk_loan_book FOREIGN KEY (book_id) REFERENCES book(id),
  CONSTRAINT fk_loan_member FOREIGN KEY (member_id) REFERENCES member(id),
  CONSTRAINT fk_librarian_id FOREIGN KEY (staff_id) REFERENCES LIBRARIAN(STAFF_ID)
);


CREATE TABLE fine (
  id INT,
  member_id INT not null,
  loan_id INT not null,
  fine_date DATE not null,
  fine_amount INT not null,
  CONSTRAINT pk_fine PRIMARY KEY (id),
  CONSTRAINT fk_fine_member FOREIGN KEY (member_id) REFERENCES member(id),
  CONSTRAINT fk_fine_loan FOREIGN KEY (loan_id) REFERENCES loan(id)
);

CREATE TABLE book_author (
    book_id	INT not null,
    author_id INT not null,
    CONSTRAINT fk_book_many FOREIGN KEY (book_id) REFERENCES book(id),
    CONSTRAINT fk_author_many FOREIGN KEY (author_id) REFERENCES author(id)
);

INSERT INTO sex VALUES (1, 'Male');
INSERT INTO sex VALUES (2, 'Female');
INSERT INTO sex VALUES (3, 'Others');

INSERT INTO member_status VALUES (1, 'Non-member');
INSERT INTO member_status VALUES (2, 'Alumni member');
INSERT INTO member_status VALUES (3, 'Institutional member');
INSERT INTO member_status VALUES (4, 'Full member');
INSERT INTO member_status VALUES (5, 'Temporary member');
INSERT INTO member_status VALUES (6, 'Limited member');

INSERT INTO reservation_status VALUES (1, 'Cancelled');
INSERT INTO reservation_status VALUES (2, 'Reserved');
INSERT INTO reservation_status VALUES (3, 'Pending');
INSERT INTO reservation_status VALUES (4, 'No-show');
INSERT INTO reservation_status VALUES (5, 'Waitlisted');

INSERT INTO librarian_titles VALUES (1, 'Librarian');
INSERT INTO librarian_titles VALUES (2, 'Library Assistant');
INSERT INTO librarian_titles VALUES (3, 'Cateloger');
INSERT INTO librarian_titles VALUES (4, 'Archivist');
INSERT INTO librarian_titles VALUES (5, 'Reference Librarian');
INSERT INTO librarian_titles VALUES (6, 'Technical Services');

INSERT INTO position (id, name) VALUES (1, 'accountant');
INSERT INTO position (id, name) VALUES (2, 'janitor');
INSERT INTO position (id, name) VALUES (3, 'librarian');

INSERT INTO cpa_validation VALUES (1, 'Certified');
INSERT INTO cpa_validation VALUES (2, 'Not certified');

INSERT INTO staff VALUES (1, "Accountant", "1", 75328952398, 1);
INSERT INTO staff VALUES (2, "Accountant", "2", 75328152398, 1);
INSERT INTO staff VALUES (3, "Accountant", "3", 75328252398, 1);
INSERT INTO staff VALUES (4, "Accountant", "4", 75328352398, 1);
INSERT INTO staff VALUES (5, "Accountant", "5", 75328452398, 1);
INSERT INTO staff VALUES (6, "Janitor", "1", 15328952398, 2);
INSERT INTO staff VALUES (7, "Janitor", "2", 25328952398, 2);
INSERT INTO staff VALUES (8, "Janitor", "3", 35328952398, 2);
INSERT INTO staff VALUES (9, "Janitor", "4", 45328952398, 2);
INSERT INTO staff VALUES (10, "Janitor", "5", 55328952398, 2);
INSERT INTO staff VALUES (11, "Librarian", "1", 71328952398, 3);
INSERT INTO staff VALUES (12, "Librarian", "2", 72328952398, 3);
INSERT INTO staff VALUES (13, "Librarian", "3", 73328952398, 3);
INSERT INTO staff VALUES (14, "Librarian", "4", 74328952398, 3);
INSERT INTO staff VALUES (15, "Librarian", "5", 76328952398, 3);

INSERT INTO accountant VALUES (1, 1);
INSERT INTO accountant VALUES (2, 2);
INSERT INTO accountant VALUES (3, 1);
INSERT INTO accountant VALUES (4, 2);
INSERT INTO accountant VALUES (5, 1);

INSERT INTO janitor VALUES (6, "Morning");
INSERT INTO janitor VALUES (7, "Afternoon");
INSERT INTO janitor VALUES (8, "Evening");
INSERT INTO janitor VALUES (9, "Morning");
INSERT INTO janitor VALUES (10, "Evening");

INSERT INTO librarian VALUES (11, 1);
INSERT INTO librarian VALUES (12, 2);
INSERT INTO librarian VALUES (13, 3);
INSERT INTO librarian VALUES (14, 4);
INSERT INTO librarian VALUES (15, 5);

INSERT INTO category VALUES (1, "Fiction");
INSERT INTO category VALUES (2, "Horror");
INSERT INTO category VALUES (3, "Literature");
INSERT INTO category VALUES (4, "Action");
INSERT INTO category VALUES (5, "Comedy");

INSERT INTO book VALUES (1, "No Man Sky", 1, "2012-12-30", 23, 11);
INSERT INTO book VALUES (2, "There is no one at all", 2, "2008-10-22", 11, 12);
INSERT INTO book VALUES (3, "The little flower", 3, "1990-11-30", 9, 13);
INSERT INTO book VALUES (4, "The golden Fenix", 4, "2000-10-12", 1, 14);
INSERT INTO book VALUES (5, "The dumb guy", 5, "2004-12-12", 11, 15);

INSERT INTO author VALUES (1, "Hellen", "Griffin");
INSERT INTO author VALUES (2, "John", "Haffinder");
INSERT INTO author VALUES (3, "Oleon", "Graphy");
INSERT INTO author VALUES (4, "Edward", "Galeon");
INSERT INTO author VALUES (5, "Koward", "Arise");

INSERT INTO member VALUES (1, "Thomas", "Malas", "2023-4-12", 1, "47592385798", 1);
INSERT INTO member VALUES (2, "March", "Millen", "2023-5-12", 2, "47592385788", 2);
INSERT INTO member VALUES (3, "Bravo", "Miles", "2023-1-11", 3, "47591385798", 3);
INSERT INTO member VALUES (4, "Phinies", "Tomson", "2023-5-1", 4, "57592385798", 1);
INSERT INTO member VALUES (5, "Kemas", "Ferb", "2023-2-12", 5, "41592385798", 1);

INSERT INTO reservation VALUES (1, 1, 1, "2023-5-1", 1);
INSERT INTO reservation VALUES (2, 2, 2, "2023-5-13", 2);
INSERT INTO reservation VALUES (3, 3, 3, "2023-5-2", 3);
INSERT INTO reservation VALUES (4, 4, 4, "2023-5-4", 4);
INSERT INTO reservation VALUES (5, 5, 5, "2023-5-11", 5);

INSERT INTO fine_payment VALUES (1, 1, "2023-6-1", 389451, 1);
INSERT INTO fine_payment VALUES (2, 2, "2023-6-2", 389452, 2);
INSERT INTO fine_payment VALUES (3, 3, "2023-6-3", 389453, 3);
INSERT INTO fine_payment VALUES (4, 4, "2023-6-4", 389454, 4);
INSERT INTO fine_payment VALUES (5, 5, "2023-6-5", 389455, 5);

INSERT INTO loan VALUES (1, 1, 1, "2023-1-5", "2023-5-1", 11);
INSERT INTO loan VALUES (2, 2, 2, "2023-1-4", "2023-5-2", 12);
INSERT INTO loan VALUES (3, 3, 3, "2023-1-3", "2023-5-3", 13);
INSERT INTO loan VALUES (4, 4, 4, "2023-1-2", "2023-5-4", 14);
INSERT INTO loan VALUES (5, 5, 5, "2023-1-1", "2023-5-5", 15);

INSERT INTO fine VALUES (1, 1, 1, "2023-5-1", 23423);
INSERT INTO fine VALUES (2, 2, 2, "2023-5-2", 23421);
INSERT INTO fine VALUES (3, 3, 3, "2023-5-3", 23123);
INSERT INTO fine VALUES (4, 4, 4, "2023-5-4", 13423);
INSERT INTO fine VALUES (5, 5, 5, "2023-5-5", 3423);

INSERT INTO book_author VALUES (1, 1);
INSERT INTO book_author VALUES (1, 2);
INSERT INTO book_author VALUES (2, 2);
INSERT INTO book_author VALUES (3, 3);
INSERT INTO book_author VALUES (4, 4);
INSERT INTO book_author VALUES (5, 5);