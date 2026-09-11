USE DeltaSquadDB;

--------------------------------------------------
-- #3 Create Database Tables
--------------------------------------------------
CREATE TABLE Customer
(
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL
);
GO
CREATE TABLE Location
(
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Street_Address VARCHAR(100) NOT NULL UNIQUE,
    Postal_Code VARCHAR(10) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Province VARCHAR(30) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE
);
GO
CREATE TABLE Amenity
(
    Amenity VARCHAR(100) PRIMARY KEY
);
GO
CREATE TABLE LocationAmenity
(
    Location_ID INT,
    Amenity VARCHAR(100),

    PRIMARY KEY (Location_ID, Amenity),

    CONSTRAINT FK_LocationAmenity_Location
        FOREIGN KEY (Location_ID)
        REFERENCES Location(Location_ID),

    CONSTRAINT FK_LocationAmenity_Amenity
        FOREIGN KEY (Amenity)
        REFERENCES Amenity(Amenity)
);
GO
CREATE TABLE Coach
(
    Coach_ID INT IDENTITY(101,1) PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Level VARCHAR(50),
    Philosophy VARCHAR(255)
);
GO
CREATE TABLE Course
(
    Course_ID INT IDENTITY(1,1) PRIMARY KEY,
    Certificate_Name VARCHAR(100) UNIQUE
);
GO
CREATE TABLE Certificate
(
    Coach_ID INT,
    Course_ID INT,
    Date_Completed DATE,

    PRIMARY KEY (Coach_ID, Course_ID),

    CONSTRAINT FK_Certificate_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_Certificate_Course
        FOREIGN KEY (Course_ID)
        REFERENCES Course(Course_ID)
);
GO
CREATE TABLE Room
(
    Room_Num INT IDENTITY(101,1) NOT NULL,
    Location_ID INT NOT NULL,
    Room_Name VARCHAR(100) NOT NULL,

    PRIMARY KEY (Room_Num, Location_ID),

    CONSTRAINT FK_Room_Location
        FOREIGN KEY (Location_ID)
        REFERENCES Location(Location_ID)
);
GO
CREATE TABLE Class
(
    Class_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Price DECIMAL(10,2) NOT NULL
);
GO
CREATE TABLE Visit
(
    Visit_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Clock_In TIME NOT NULL,
    Clock_Out TIME NOT NULL,
    Visit_Date DATE NOT NULL,
    Visit_Type VARCHAR(20),

    CONSTRAINT FK_Visit_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID),

    CONSTRAINT FK_Visit_Location
        FOREIGN KEY (Location_ID)
        REFERENCES Location(Location_ID)
);
GO
CREATE TABLE CoachLocation
(
    Coach_ID INT,
    Location_ID INT,

    PRIMARY KEY (Coach_ID, Location_ID),

    CONSTRAINT FK_CoachLocation_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_CoachLocation_Location
        FOREIGN KEY (Location_ID)
        REFERENCES Location(Location_ID)
);
GO
CREATE TABLE Review
(
    Coach_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Review_Type VARCHAR(20),

    PRIMARY KEY (Coach_ID, Customer_ID),

    CONSTRAINT FK_Review_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_Review_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
);
GO
CREATE TABLE Reference
(
    Coach_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,

    PRIMARY KEY (Coach_ID, Customer_ID),

    CONSTRAINT FK_Reference_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_Reference_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
);
GO
CREATE TABLE Schedule
(
    Schedule_ID INT IDENTITY(1,1) PRIMARY KEY,
    Class_ID INT NOT NULL,
    Room_Num INT,
    Location_ID INT,
    Coach_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,

    CONSTRAINT FK_Schedule_Class
        FOREIGN KEY (Class_ID)
        REFERENCES Class(Class_ID),

    CONSTRAINT FK_Schedule_Room
        FOREIGN KEY (Room_Num, Location_ID)
        REFERENCES Room(Room_Num, Location_ID),

    CONSTRAINT FK_Schedule_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID)
);
GO
CREATE TABLE Appointment
(
    Visit_ID INT PRIMARY KEY,
    Coach_ID INT,

    CONSTRAINT FK_Appointment_Visit
        FOREIGN KEY (Visit_ID)
        REFERENCES Visit(Visit_ID),

    CONSTRAINT FK_Appointment_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID)
);
GO
CREATE TABLE ClassBooking
(
    Visit_ID INT PRIMARY KEY,
    Schedule_ID INT NOT NULL,

    CONSTRAINT FK_ClassBooking_Visit
        FOREIGN KEY (Visit_ID)
        REFERENCES Visit(Visit_ID),

    CONSTRAINT FK_ClassBooking_Schedule
        FOREIGN KEY (Schedule_ID)
        REFERENCES Schedule(Schedule_ID)
);
GO
CREATE TABLE PersonalCoachReview
(
    Coach_ID INT,
    Customer_ID INT,
    Visit_ID INT,

    Communication INT NOT NULL CHECK (Communication BETWEEN 0 AND 5),
    Enthusiasm INT NOT NULL CHECK (Enthusiasm BETWEEN 0 AND 5),
    Punctuality INT NOT NULL CHECK (Punctuality BETWEEN 0 AND 5),

    Notes VARCHAR(255),

    PRIMARY KEY (Coach_ID, Customer_ID, Visit_ID),

    CONSTRAINT FK_PersonalCoachReview_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_PersonalCoachReview_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID),

    CONSTRAINT FK_PersonalCoachReview_Visit
        FOREIGN KEY (Visit_ID)
        REFERENCES Visit(Visit_ID)
);
GO
CREATE TABLE ClassCoachReview
(
    Coach_ID INT,
    Customer_ID INT,
    Schedule_ID INT,

    Communication INT NOT NULL CHECK (Communication BETWEEN 0 AND 5),
    Enthusiasm INT NOT NULL CHECK (Enthusiasm BETWEEN 0 AND 5),
    Punctuality INT NOT NULL CHECK (Punctuality BETWEEN 0 AND 5),

    Notes VARCHAR(255),

    PRIMARY KEY (Coach_ID, Customer_ID, Schedule_ID),

    CONSTRAINT FK_ClassCoachReview_Coach
        FOREIGN KEY (Coach_ID)
        REFERENCES Coach(Coach_ID),

    CONSTRAINT FK_ClassCoachReview_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID),

    CONSTRAINT FK_ClassCoachReview_Schedule
        FOREIGN KEY (Schedule_ID)
        REFERENCES Schedule(Schedule_ID)
);
GO

--------------------------------------------------
-- #4 Data Insertion
--------------------------------------------------

INSERT INTO Customer
    (First_Name, Last_Name, Phone, Email)
VALUES
    ('John', 'Smith', '6471111111', 'john@email.com'),
    ('Emma', 'Johnson', '6472222222', 'emma@email.com'),
    ('Michael', 'Brown', '6473333333', 'michael@email.com'),
    ('Sophia', 'Davis', '6474444444', 'sophia@email.com');
GO

INSERT INTO Location
    (Name, Street_Address, Postal_Code, City, Province, Country, Phone, Email)
VALUES
    ('Downtown Gym', '100 King St', 'L5B1A1', 'Mississauga', 'Ontario', 'Canada', '9051111111', 'downtown@gym.com'),
    ('North Gym', '200 Queen St', 'L6P2B2', 'Brampton', 'Ontario', 'Canada', '9052222222', 'north@gym.com'),
    ('West Gym', '45 North St', 'L4K1A1', 'Mississauga', 'Ontario', 'Canada', '9053333333', 'west@gym.com'),
    ('East Gym', '88 East Ave', 'M5V2T6', 'Toronto', 'Ontario', 'Canada', '9054444444', 'east@gym.com');
GO

INSERT INTO Amenity
    (Amenity)
VALUES
    ('Pool'),
    ('Sauna'),
    ('Basketball Court'),
    ('Yoga Studio');
GO

INSERT INTO LocationAmenity
    (Location_ID, Amenity)
VALUES
    (1, 'Pool'),
    (1, 'Sauna'),
    (2, 'Basketball Court'),
    (2, 'Yoga Studio'),
    (3, 'Pool'),
    (4, 'Sauna');
GO

INSERT INTO Coach
    (First_Name, Last_Name, Phone, Email, Level, Philosophy)
VALUES
    ('James', 'Wilson', '6475551111', 'james@gym.com', 'Senior', 'Train smart'),
    ('Olivia', 'Taylor', '6475552222', 'olivia@gym.com', 'Intermediate', 'Consistency first'),
    ('Daniel', 'Martin', '6475553333', 'daniel@gym.com', 'Senior', 'Strength through discipline'),
    ('Emily', 'Anderson', '6475554444', 'emily@gym.com', 'Junior', 'Enjoy the journey');
GO

INSERT INTO Course
    (Certificate_Name)
VALUES
    ('CPR Certification'),
    ('Personal Training'),
    ('Yoga Instructor'),
    ('Nutrition Coach');
GO

INSERT INTO Certificate
    (Coach_ID, Course_ID, Date_Completed)
VALUES
    (101, 1, '2024-01-15'),
    (102, 2, '2024-02-10'),
    (103, 4, '2024-03-05'),
    (104, 3, '2024-04-20');
GO

INSERT INTO Room
    (Location_ID, Room_Name)
VALUES
    (1, 'Studio A'),
    (2, 'Studio B'),
    (3, 'Weight Room'),
    (4, 'Yoga Room');
GO

INSERT INTO Class
    (Name, Price)
VALUES
    ('Yoga', 20.00),
    ('HIIT', 25.00),
    ('Strength Training', 30.00),
    ('Pilates', 22.00);
GO

INSERT INTO CoachLocation
    (Coach_ID, Location_ID)
VALUES
    (101, 1),
    (102, 2),
    (103, 3),
    (104, 4),
    (101, 2),
    (102, 1);
GO

INSERT INTO Schedule
    (Class_ID, Room_Num, Location_ID, Coach_ID, Date, Time)
VALUES
    (1, 101, 1, 101, '2025-07-10', '09:00'),
    (2, 102, 2, 102, '2025-07-11', '10:00'),
    (3, 103, 3, 103, '2025-07-12', '11:00'),
    (4, 104, 4, 104, '2025-07-13', '13:00');
GO

INSERT INTO Visit
    (Customer_ID, Location_ID, Clock_In, Clock_Out, Visit_Date, Visit_Type)
VALUES
    -- Class visits
    (1, 1, '09:00', '10:00', '2025-07-10', 'Class'),
    (2, 2, '10:00', '11:00', '2025-07-11', 'Class'),
    (3, 3, '11:00', '12:00', '2025-07-12', 'Class'),
    (4, 4, '13:00', '14:00', '2025-07-13', 'Class'),
    -- Appointment visits
    (2, 1, '14:00', '15:00', '2025-07-14', 'Appointment'),
    (3, 2, '15:00', '16:00', '2025-07-15', 'Appointment'),
    (4, 3, '16:00', '17:00', '2025-07-16', 'Appointment'),
    (1, 4, '17:00', '18:00', '2025-07-17', 'Appointment');
GO

INSERT INTO ClassBooking
    (Visit_ID, Schedule_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);
GO

INSERT INTO Appointment
    (Visit_ID, Coach_ID)
VALUES
    (5, 101),
    (6, 102),
    (7, 103),
    (8, 104);
GO

INSERT INTO Review
    (Coach_ID, Customer_ID, Review_Type)
VALUES
    -- Personal reviews
    (101, 2, 'Personal'),
    (102, 3, 'Personal'),
    (103, 4, 'Personal'),
    (104, 1, 'Personal'),
    -- Class reviews
    (101, 1, 'Class'),
    (102, 2, 'Class'),
    (103, 3, 'Class'),
    (104, 4, 'Class');
GO

INSERT INTO PersonalCoachReview
    (Coach_ID, Customer_ID, Visit_ID,
     Communication, Enthusiasm, Punctuality, Notes)
VALUES
    (101, 2, 5, 5, 5, 5, 'Excellent personal coaching session'),
    (102, 3, 6, 4, 5, 5, 'Very helpful and motivating'),
    (103, 4, 7, 5, 4, 5, 'Clear instructions and good support'),
    (104, 1, 8, 4, 4, 5, 'Good personal training session');
GO

INSERT INTO ClassCoachReview
    (Coach_ID, Customer_ID, Schedule_ID,
     Communication, Enthusiasm, Punctuality, Notes)
VALUES
    (101, 1, 1, 5, 5, 5, 'Great class and clear instruction'),
    (102, 2, 2, 4, 5, 5, 'Energetic and well organized class'),
    (103, 3, 3, 5, 4, 5, 'Excellent class coach'),
    (104, 4, 4, 4, 4, 5, 'Good class and very professional');
GO

INSERT INTO Reference
    (Coach_ID, Customer_ID, Date, Time)
VALUES
    (101, 1, '2025-07-20', '09:30'),
    (101, 2, '2025-07-21', '10:00'),
    (102, 2, '2025-07-22', '10:30'),
    (102, 3, '2025-07-23', '11:00'),
    (103, 3, '2025-07-24', '11:30'),
    (103, 4, '2025-07-25', '12:00'),
    (104, 4, '2025-07-26', '12:30'),
    (104, 1, '2025-07-27', '13:00');
GO

--------------------------------------------------
-- #5 SQL Queries
--------------------------------------------------

-- Wireframe #1: Locations
SELECT
    l.Name,
    COUNT(
        CASE WHEN v.Customer_ID = 1 
        THEN v.Visit_ID 
        END) AS '# of Visits'
FROM Location l
    LEFT JOIN Visit v
    ON v.Location_ID = l.Location_ID
GROUP BY l.Name
ORDER BY l.Name;
GO

-- Wireframe #2: Location Information
SELECT
    l.Name,
    l.Street_Address + ', ' + l.City + ', ' + l.Province + ', ' + 
    l.Country + ', ' + l.Postal_Code AS Address,
    l.Phone,
    l.Email,
    a.Amenity AS 'Amentities',
    c.First_Name AS 'Coaches'
FROM Location l
    FULL JOIN LocationAmenity a
    ON l.Location_ID = a.Location_ID
    FULL JOIN Schedule s
    ON l.Location_ID = s.Location_ID
    FULL JOIN Coach c
    ON s.Coach_ID = c.Coach_ID
WHERE l.Location_ID = 2;
GO

-- Wireframe #3: Coaches
SELECT
    c.First_Name,
    c.Level,
    -- Assign 0 if NULL to avoid returning null Ratings
    (CASE WHEN p.p_rating IS NULL THEN 0 ELSE p.p_rating END) +
    (CASE WHEN r.r_rating IS NULL THEN 0 ELSE r.r_rating END) AS 'Rating',
    -- Count used to determine if coach listed under 'My Coaches', not to display
    COUNT(
        CASE WHEN v.Customer_ID = 1 
        THEN v.Visit_ID 
        END) AS '# of Visits'
FROM Coach c
    LEFT JOIN (
        SELECT
            Coach_ID,
            AVG((Communication + Enthusiasm + Punctuality) / 3) AS p_rating
        FROM PersonalCoachReview
        GROUP BY Coach_ID
    ) p 
    ON p.Coach_ID = c.Coach_ID
    LEFT JOIN (
        SELECT
            Coach_ID,
            AVG((Communication + Enthusiasm + Punctuality) / 3) AS r_rating
        FROM ClassCoachReview
        GROUP BY Coach_ID
    ) r 
    ON r.Coach_ID = c.Coach_ID
    LEFT JOIN CoachLocation x
    ON c.Coach_ID = x.Coach_ID
    LEFT JOIN Appointment a 
    ON a.Coach_ID = c.Coach_ID
    LEFT JOIN Visit v
    ON v.Visit_ID = a.Visit_ID
GROUP BY c.First_Name, c.Level, p.p_rating, r.r_rating
ORDER BY '# of Visits' DESC;
GO

-- Wireframe #4: Coach Info
SELECT
    c.First_Name,
    c.Level,
    c.Philosophy,
    l.Name AS 'Location',
    e.Certificate_Name AS 'Certificates',
    CONCAT(a.First_Name, ' ',a.Last_Name) AS 'Client Name',
    a.Phone,
    a.Email,
    -- Assign 0 if NULL to avoid returning null Ratings
    (CASE WHEN p.p_rating IS NULL THEN 0 ELSE p.p_rating END) +
    (CASE WHEN r.r_rating IS NULL THEN 0 ELSE r.r_rating END) AS Rating
FROM Coach c
    LEFT JOIN (
        SELECT
            Coach_ID,
            AVG((Communication + Enthusiasm + Punctuality) / 3) AS p_rating
        FROM PersonalCoachReview
        GROUP BY Coach_ID
    ) p 
    ON p.Coach_ID = c.Coach_ID
    LEFT JOIN (
        SELECT
            Coach_ID,
            AVG((Communication + Enthusiasm + Punctuality) / 3) AS r_rating
        FROM ClassCoachReview
        GROUP BY Coach_ID
    ) r 
    ON r.Coach_ID = c.Coach_ID
    LEFT JOIN CoachLocation x
    ON c.Coach_ID = x.Coach_ID
    LEFT JOIN Location l
    ON x.Location_ID = l.Location_ID
    LEFT JOIN Certificate y
    ON c.Coach_ID = y.Coach_ID
    LEFT JOIN Course e
    ON y.Course_ID = e.Course_ID
    LEFT JOIN Reference z 
    ON c.Coach_ID = z.Coach_ID
    LEFT JOIN Customer a
    ON z.Customer_ID = a.Customer_ID
WHERE c.Coach_ID = 101;
GO

--------------------------------------------------
-- Data Insertion Checks
--------------------------------------------------
-- Row Checks
SELECT * FROM Customer;
SELECT * FROM Location;
SELECT * FROM Amenity;
SELECT * FROM LocationAmenity;
SELECT * FROM Coach;
SELECT * FROM Course;
SELECT * FROM Certificate;
SELECT * FROM Room;
SELECT * FROM Class;
SELECT * FROM CoachLocation;
SELECT * FROM Schedule;
SELECT * FROM Visit;
SELECT * FROM ClassBooking;
SELECT * FROM Appointment;
SELECT * FROM Review;
SELECT * FROM PersonalCoachReview;
SELECT * FROM ClassCoachReview;
SELECT * FROM Reference;
GO

-- Reference Table Check
SELECT * FROM Reference ORDER BY Coach_ID, Customer_ID;
GO

-- Row Counts
SELECT 'Customer' AS TableName, COUNT(*) AS Rows FROM Customer
UNION ALL SELECT 'Location', COUNT(*) FROM Location
UNION ALL SELECT 'Amenity', COUNT(*) FROM Amenity
UNION ALL SELECT 'LocationAmenity', COUNT(*) FROM LocationAmenity
UNION ALL SELECT 'Coach', COUNT(*) FROM Coach
UNION ALL SELECT 'Course', COUNT(*) FROM Course
UNION ALL SELECT 'Certificate', COUNT(*) FROM Certificate
UNION ALL SELECT 'Room', COUNT(*) FROM Room
UNION ALL SELECT 'Class', COUNT(*) FROM Class
UNION ALL SELECT 'Visit', COUNT(*) FROM Visit
UNION ALL SELECT 'CoachLocation', COUNT(*) FROM CoachLocation
UNION ALL SELECT 'Schedule', COUNT(*) FROM Schedule
UNION ALL SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL SELECT 'ClassBooking', COUNT(*) FROM ClassBooking
UNION ALL SELECT 'Review', COUNT(*) FROM Review
UNION ALL SELECT 'PersonalCoachReview', COUNT(*) FROM PersonalCoachReview
UNION ALL SELECT 'ClassCoachReview', COUNT(*) FROM ClassCoachReview
UNION ALL SELECT 'Reference', COUNT(*) FROM Reference
ORDER BY TableName;
GO

-- Visit Sub-Type Check
SELECT
    v.Visit_ID,
    v.Customer_ID,
    v.Location_ID,
    v.Visit_Type,
    cb.Schedule_ID,
    a.Coach_ID
FROM Visit v
LEFT JOIN ClassBooking cb
    ON v.Visit_ID = cb.Visit_ID
LEFT JOIN Appointment a
    ON v.Visit_ID = a.Visit_ID
ORDER BY v.Visit_ID;
GO

-- Review Sub-type Check
SELECT
    r.Coach_ID,
    r.Customer_ID,
    r.Review_Type,
    p.Visit_ID AS Personal_Visit_ID,
    c.Schedule_ID AS Class_Schedule_ID
FROM Review r
LEFT JOIN PersonalCoachReview p
    ON r.Coach_ID = p.Coach_ID
   AND r.Customer_ID = p.Customer_ID
LEFT JOIN ClassCoachReview c
    ON r.Coach_ID = c.Coach_ID
   AND r.Customer_ID = c.Customer_ID
ORDER BY r.Review_Type, r.Coach_ID, r.Customer_ID;
GO