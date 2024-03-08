CREATE TABLE Venue (
    Venue_ID INT PRIMARY KEY,
    Venue_Name VARCHAR(255),
    Address VARCHAR(255),
    Postcode VARCHAR(6),
    Manager_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES Permenant_Staff(Staff_No)
);

CREATE TABLE Room (
    Room_ID INT PRIMARY KEY,
    Venue_ID INT,
    Room_Name VARCHAR(255),
    Description VARCHAR(255),
    Meeting_Capacity INT,
    Standing_Capacity INT,
    Banguet_Capacity INT,
    FOREIGN KEY (Venue_ID) REFERENCES Venue(Venue_ID)
);

CREATE TABLE Room_Reservation (
    Event_No INT PRIMARY KEY,
    Room_ID INT,
    Start_DateTime DATE,
    End_DateTime DATE,
    FOREIGN KEY (Event_No) REFERENCES Event(Event_No),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

CREATE TABLE Client (
    Client_No INT PRIMARY KEY,
    Client_Name VARCHAR(255),
    Company_Name VARCHAR(255),
    Contact_No VARCHAR(11),
    Contact_Email VARCHAR(255)
);

CREATE TABLE Permanent_Staff (
    Staff_No INT PRIMARY KEY,
    First_Name VARCHAR(255),
    Surname VARCHAR(255),
    DOB DATE,
    Address VARCHAR(255),
    Email_Address VARCHAR(255),
    Mobile_No VARCHAR(11),
    Work_Adjustments VARCHAR(255),
    Start_Date DATE,
    Leaving_Date DATE
    NIN VARCHAR(9),
    Annual_Salary DECIMAL(8,2),
    Account_No VARCHAR(8),
    Sort_Code VARCHAR(6),
);

CREATE TABLE Temporary_Staff (
    Staff_No INT PRIMARY KEY,
    First_Name VARCHAR(255),
    Surname VARCHAR(255),
    DOB DATE,
    Address VARCHAR(255),
    Email_Address VARCHAR(255),
    Mobile_No VARCHAR(11),
    Work_Adjustments VARCHAR(255),
    Start_Date DATE,
    Leaving_Date DATE
    Agency VARCHAR(255),
    Hourly_Rate DECIMAL(5,2),
    Max_Weekly_Hours INT
);

CREATE TABLE Event (
    Event_No INT PRIMARY KEY,
    Client_No INT,
    Booking_Date DATE,
    Event_Type VARCHAR(255),
    Summary_Details VARCHAR(255),
    Event_Manager_ID INT,
    Number_Adults INT,
    Number_Children INT,
    Management_Fee DECIMAL(5,2),
    Additional_Notes VARCHAR(255),

    FOREIGN KEY (Client_No) REFERENCES Client(Client_No),
    FOREIGN KEY (Event_Manager_ID) REFERENCES Permanent_Staff(Staff_No)
);

CREATE TABLE Event_Temp_Staff (
    Timesheet_ID INT PRIMARY KEY,
    Staff_No INT,
    Event_No INT,
    FOREIGN KEY (Staff_No) REFERENCES Temporary_Staff(Staff_No),
    FOREIGN KEY (Event_No) REFERENCES Event(Event_No)
);