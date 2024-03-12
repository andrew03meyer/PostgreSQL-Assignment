------------------------------------------------------------------------------
-- This is the template for your COMP5320 Assessment 3 submission.
-- Please leave the overall structure and order of queries unchanged.
-- You can freely add queries as you need, but please place them in the
-- corresponding sections. And please do not remove any comments.
-------------------------------------------------------------------------------
-- Please fill in your name and login:
-- name: Andrew Meyer
-- login: am2660
-------------------------------------------------------------------------------
-- The following lines make sure you can rerun this whole script as often
-- as you want.
DROP TABLE IF EXISTS Event_Temp_Staff;
DROP TABLE IF EXISTS Room_Reservation;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Permanent_Staff;
DROP TABLE IF EXISTS Temporary_Staff;

-------------------------------------------------------------------------------
-- Task 1: Create Tables and Insert Data
-------------------------------------------------------------------------------
CREATE TABLE Permanent_Staff (
    Staff_No INT PRIMARY KEY NOT NULL,
    First_Name VARCHAR(255) NOT NULL,
    Surname VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Email_Address VARCHAR(255) NOT NULL,
    Mobile_No VARCHAR(11) NOT NULL,
    Work_Adjustments VARCHAR(255),
    Start_Date DATE DEFAULT CURRENT_DATE NOT NULL,
    Leaving_Date DATE,
    NIN VARCHAR(9) UNIQUE NOT NULL,
    Annual_Salary DECIMAL(8,2) NOT NULL,
    Account_No VARCHAR(8) NOT NULL,
    Sort_Code VARCHAR NOT NULL,

    CONSTRAINT DOB CHECK (DOB < (current_date - interval '18' year)),
    CONSTRAINT Leaving_Date CHECK (Leaving_Date >= Start_Date)
);

CREATE TABLE Temporary_Staff (
    Staff_No INT PRIMARY KEY NOT NULL,
    First_Name VARCHAR(255) NOT NULL,
    Surname VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Email_Address VARCHAR(255) NOT NULL,
    Mobile_No VARCHAR(11) NOT NULL,
    Work_Adjustments VARCHAR(255),
    Start_Date DATE DEFAULT CURRENT_DATE NOT NULL,
    Leaving_Date DATE,
    Agency VARCHAR(255) NOT NULL,
    Hourly_Rate DECIMAL(5,2) NOT NULL,
    Max_Weekly_Hours INT NOT NULL,

    CONSTRAINT DOB CHECK (DOB < (current_date - interval '18' year)),
    CONSTRAINT Leaving_Date CHECK (Leaving_Date >= Start_Date),
    CONSTRAINT Max_Weekly_Hours CHECK (Max_Weekly_Hours <= 48)
);

CREATE TABLE Venue (
    Venue_ID INT PRIMARY KEY NOT NULL,
    Venue_Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Postcode VARCHAR NOT NULL,
    Manager_ID INT,

    FOREIGN KEY (Manager_ID) REFERENCES Permanent_Staff(Staff_No)
);

CREATE TABLE Room (
    Room_ID INT PRIMARY KEY NOT NULL,
    Venue_ID INT NOT NULL,
    Room_Name VARCHAR(255) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Meeting_Capacity INT NOT NULL,
    Standing_Capacity INT NOT NULL,
    Banquet_Capacity INT NOT NULL,

    FOREIGN KEY (Venue_ID) REFERENCES Venue(Venue_ID),

    CONSTRAINT Meeting_Capacity CHECK (Meeting_Capacity <= 1000),
    CONSTRAINT Standing_Capacity CHECK (Standing_Capacity <= 1000),
    CONSTRAINT Banguet_Capacity CHECK (Banguet_Capacity <= 1000)
);

CREATE TABLE Client (
    Client_No INT PRIMARY KEY NOT NULL,
    Client_Name VARCHAR(255) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    Contact_Number VARCHAR(11) NOT NULL,
    Contact_Email VARCHAR(255) NOT NULL
);

CREATE TABLE Event (
    Event_No INT PRIMARY KEY NOT NULL,
    Client_No INT NOT NULL,
    Booking_Date DATE NOT NULL,
    Event_Type VARCHAR(255) NOT NULL,
    Summary_Details VARCHAR(255) NOT NULL,
    Event_Manager_ID INT,
    Number_Adults INT NOT NULL,
    Number_Children INT NOT NULL,
    Management_Fee DECIMAL(5,2) NOT NULL,
    Additional_Notes VARCHAR(255),

    FOREIGN KEY (Client_No) REFERENCES Client(Client_No),
    FOREIGN KEY (Event_Manager_ID) REFERENCES Permanent_Staff(Staff_No),

    CONSTRAINT Number_Adults CHECK (Number_Adults >= 20),
    CONSTRAINT Management_Fee CHECK (Management_Fee >= 0)
);

CREATE TABLE Room_Reservation (
    Event_No INT NOT NULL,
    Room_ID INT NOT NULL,
    Start_Date_Time DATE NOT NULL,
    End_Date_Time DATE NOT NULL,

    PRIMARY KEY (Event_No, Room_ID, Start_DateTime),

    FOREIGN KEY (Event_No) REFERENCES Event(Event_No),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),

    CONSTRAINT Start_DateTime CHECK (Start_DateTime <= End_DateTime)
);

CREATE TABLE Event_Temp_Staff (
    Timesheet_ID INT PRIMARY KEY NOT NULL,
    Staff_No INT NOT NULL,
    Event_No INT NOT NULL,
    Hours_Worked INT NOT NULL,

    FOREIGN KEY (Staff_No) REFERENCES Temporary_Staff(Staff_No),
    FOREIGN KEY (Event_No) REFERENCES Event(Event_No)
);

-- Below are the provided INSERT statements to add data to the tables.
-- Do not modify these INSERT statements.
INSERT INTO Permanent_Staff (
    staff_no, first_name, surname, dob, address, email_address, mobile_no,
    start_date, NIN, annual_salary, account_no, sort_code)
VALUES
    (1, 'John', 'Smith', '1980-01-01', '123 Example Street', 'email@address.com', '0123456789', '2020-01-01', 'QQ123456A', 33000, '12345678', '12-34-56'),
    (2, 'Anna', 'Jones', '1989-02-13', '456 Example Street', 'anna@example.com', '0123456780', '2020-01-01', 'QQ123457A', 33000, '12345679', '12-34-57'),
    (3, 'Peter', 'Brown', '1999-12-07', '789 Example Street', 'pb@example.com', '0123456781', '2020-01-01', 'QQ123458A', 33000, '12345680', '12-34-58');

INSERT INTO Temporary_Staff (
    staff_no, first_name, surname, dob, address, email_address, mobile_no,
    start_date, agency, hourly_rate, max_weekly_hours)
VALUES
    (1, 'Tom', 'Johnson', '1995-01-01', '123 Example Street', 'tom@temp.com', '0223456789', '2020-01-01', 'Agency 1', 10, 40),
    (2, 'Sue', 'Williams', '1996-02-13', '456 Example Street', 'sue@temp.com', '0223456780', '2020-01-01', 'Agency 2', 10, 40),
    (3, 'Michaela', 'Green', '1997-12-07', '789 Example Street', 'michaela@temp.co.uk', '0223456781', '2020-01-01', 'Agency 3', 10, 40),
    (4, 'David', 'Black', '1998-12-07', '789 Example Street', 'dave@black.org', '0223456782', '2020-01-01', 'Agency 4', 10, 40),
    (5, 'Sarah', 'White', '1999-12-07', '789 Example Street', 'sarah@email.org', '0223456783', '2020-01-01', 'Agency 5', 10, 40);


INSERT INTO Venue (venue_id, venue_name, address, postcode, manager_id) VALUES
    (1, 'Venue 1', '123 Example Street', 'EX1 111', 1),
    (2, 'Venue 2', '456 Example Street', 'EX1 222', 1),
    (3, 'Venue 3', '789 Example Street', 'EX1 333', 3);

INSERT INTO Room (room_id, venue_id, room_name, description, meeting_capacity, standing_capacity, banquet_capacity) VALUES
    (1, 1, 'Room 1', 'Room 1 description', 100, 200, 300),
    (2, 1, 'Room 2', 'Room 2 description', 100, 200, 300),
    (3, 2, 'Room 3', 'Room 3 description', 100, 200, 300),
    (4, 2, 'Room 4', 'Room 4 description', 100, 200, 300),
    (5, 3, 'Room 5', 'Room 5 description', 100, 200, 300),
    (6, 3, 'Room 6', 'Room 6 description', 100, 200, 300);

INSERT INTO Client (client_no, client_name, company_name, contact_number, contact_email) VALUES
    (1, 'Families N+M', 'N/A', '0123456789', 'client1@example.com'),
    (2, 'S. Smith', 'Acme Inc.', '0123456780', 'smith@acme.com'),
    (3, 'V. Jones', 'Big Data Inc.', '0123456781', 'jones@bigdata.com'),
    (4, 'J. Taylor', 'Tech Corp.', '0123456782', 'taylor@tech-corp.com'),
    (5, 'A. Brown', 'Data Science Ltd.', '0123456783', 'brown@datasci.co.uk');

INSERT INTO Event (
    event_no, client_no, booking_date, event_type, summary_details,
    number_adults, number_children, management_fee, event_manager_id)
VALUES
    (1, 1, '2023-05-01', 'Wedding',    'Wedding of N+M', 85, 20, 100, 1),
    (2, 2, '2023-05-01', 'Reception',  'Reception for new Head of Data Science at Acme Inc.', 20, 0, 100, 1),
    (3, 3, '2023-05-01', 'Conference', 'International Conference on Very Large Databases',   600, 0, 100, 2),
    (4, 2, '2023-12-01', 'Christmas Party',  'Christmas 2023', 90, 0, 100, 1),
    (5, 4, '2024-03-01', 'Reception', 'Spring Reception', 20, 0, 100, 1),
    (6, 4, '2024-06-01', 'Reception', 'Summer Reception', 20, 0, 100, 1),
    (7, 5, '2024-03-01', 'Reception', 'Spring Reception', 20, 0, 100, 1);

INSERT INTO Room_Reservation (event_no, room_id, start_date_time, end_date_time) VALUES
    (1, 1, '2023-05-01 14:00:00', '2023-05-02 02:00:00'),
    (2, 2, '2023-05-01 10:00:00', '2023-05-01 12:00:00'),
    (3, 3, '2023-05-01 08:00:00', '2023-05-01 20:00:00');

INSERT INTO Event_Temp_Staff (timesheet_id, staff_no, event_no, hours_worked) VALUES
    (1, 1, 1, 8), (2, 2, 1, 8), (3, 3, 1, 8), (4, 1, 2, 2), (5, 2, 2, 2),
    (6, 3, 2, 2), (7, 1, 3, 5), (8, 2, 3, 3), (9, 3, 3, 3), (10, 4, 3, 5),
    (11, 5, 3, 7);

-------------------------------------------------------------------------------
-- Task 2: Query the Database
-------------------------------------------------------------------------------

-- 2.0 Write an SQL query that returns your personal Kent login and your full name.
--     Use the column names `login` and `name`.
--     Hint: In PostgreSQL, SELECT statements can return constant values
--     without needing to fetch data from a specific table.

SELECT login, name FROM (VALUES('am2660', 'Andrew Meyer')) AS t1(login, name);

-- 2.1 List all room reservations that last for longer than 8 hours, include
--     the room_name, event_type, as well as client_name and company_name.



-- 2.2 Who are the three temporary staff members that have worked the most hours?
--     Show their first_name, surname, and the total number of hours worked.



-- 2.3 Take your answer for 2.2 and modify it to show the 2 temporary staff
--     members with the fewest hours worked, but show the results so that
--     the staff member with more hours worked is listed first.



-- 2.4 The following query was written to give the list of clients who have
--     booked enough events to have at least 100 participants in total.
--     However, it only lists the clients who have booked events with
--     at least 100 adults. Please rewrite the query to fix all problems.
SELECT c.client_name, c.company_name
FROM Client c
  JOIN Event e ON c.client_no = e.client_no
WHERE e.number_adults >= 100;



-- 2.5 After each event, you'll need to produce an invoice.  Write a query that
--     calculates the total billable cost of each event *based on the cost of
--     temporary staff and other fees*. The query should return the event_no,
--     the total_cost, and the client_name, and company_name. In addition to
--     the total_cost, list all_fees and staff_costs as columns so they
--     can be included on the invoice.



-- 2.6 Calculate the total cost of *ALL* staff for last year, i.e., 2023,
--     and return a single value, i.e. a single row, with the column total_staff_costs.



-- 2.7 As part of a promotion for new clients, you won't charge management fees
--     for events with a booking date in March 2024.
--     Please update the database to adjust the management fees.
--     Using knowledge about the concrete data, e.g., ids or names, will result in 0 marks.



-- 2.8 Thanks to the promotion for new clients, you're just off the phone with
--     Betty Michelson (michelson@kent-hikes.co.uk) of Kent Hikes Ltd.
--     She wants to eventually organize a reception. For now, please add her as a new client.
--     Her contact number is 012270000000.



-- 2.9 Please write a query that returns a column (used_ai) with either TRUE or FALSE
--     to indicate whether you used an AI assistant to help you write the query.
--     Also include a column (explanation) that names the used assistant and briefly
--     explains how you used it. If you didn't use one, please briefly explain why not.
--     Marks will be awarded only for the correctness of the SQL, not the content of the answer.
--     Hint: In PostgreSQL, SELECT statements can return constant values
--     without needing to fetch data from a specific table.



-------------------------------------------------------------------------------
