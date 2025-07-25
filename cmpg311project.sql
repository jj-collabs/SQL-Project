-- 1. Client
CREATE TABLE Client (
  Client_ID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Email VARCHAR2(100),
  Phone VARCHAR2(20)
);

-- 2. Service
CREATE TABLE Service (
  Service_ID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Duration NUMBER,
  Price NUMBER(10, 2),
  Is_Premium_YN CHAR(1) CHECK (Is_Premium_YN IN ('Y', 'N'))
);

-- 3. Stylist
CREATE TABLE Stylist (
  Stylist_ID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Specialization VARCHAR2(100),
  Work_Hours VARCHAR2(100),
  Experience_Years NUMBER
);

-- 4. Junior_Stylist
CREATE TABLE Junior_Stylist (
  Stylist_ID NUMBER PRIMARY KEY,
  Mentor_ID NUMBER,
  Training_Status VARCHAR2(50),
  Performance_Rating NUMBER,
  Certification_Status_YN CHAR(1) CHECK (Certification_Status_YN IN ('Y', 'N')),
  FOREIGN KEY (Stylist_ID) REFERENCES Stylist(Stylist_ID),
  FOREIGN KEY (Mentor_ID) REFERENCES Stylist(Stylist_ID)
);

-- 5. Senior_Stylist
CREATE TABLE Senior_Stylist (
  Stylist_ID NUMBER PRIMARY KEY,
  Can_Train_Junior_Stylists_YN CHAR(1),
  Specialized_Services VARCHAR2(100),
  Trainer_Rating NUMBER,
  Management_Role_YN CHAR(1),
  Bonus_Eligibility_YN CHAR(1),
  FOREIGN KEY (Stylist_ID) REFERENCES Stylist(Stylist_ID)
);

-- 6. Booking
CREATE TABLE Booking (
  Booking_ID NUMBER PRIMARY KEY,
  Client_ID NUMBER,
  Service_ID NUMBER,
  Booking_DateTime DATE,
  Status VARCHAR2(50),
  FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
  FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID)
);

-- 7. Payment
CREATE TABLE Payment (
  Payment_ID NUMBER PRIMARY KEY,
  Booking_ID NUMBER,
  Payment_Method VARCHAR2(50),
  Amount_Paid NUMBER(10,2),
  Payment_DateTime DATE,
  FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
);

-- 8. Stylist_Booking
CREATE TABLE Stylist_Booking (
  Stylist_ID NUMBER,
  Booking_ID NUMBER,
  PRIMARY KEY (Stylist_ID, Booking_ID),
  FOREIGN KEY (Stylist_ID) REFERENCES Stylist(Stylist_ID),
  FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
);

-- 9. Training
CREATE TABLE Training (
  Training_ID NUMBER PRIMARY KEY,
  Course_Name VARCHAR2(100),
  Duration_Days NUMBER,
  Certification_Granted_YN CHAR(1)
);

-- 10. Stylist_Training
CREATE TABLE Stylist_Training (
  Stylist_ID NUMBER,
  Training_ID NUMBER,
  Completion_Date DATE,
  PRIMARY KEY (Stylist_ID, Training_ID),
  FOREIGN KEY (Stylist_ID) REFERENCES Stylist(Stylist_ID),
  FOREIGN KEY (Training_ID) REFERENCES Training(Training_ID)
);

-- 11. Inventory
CREATE TABLE Inventory (
  Inventory_ID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Stock_Level NUMBER,
  Restock_Threshold NUMBER,
  Last_Restocked DATE
);

-- 12. Inventory_Service
CREATE TABLE Inventory_Service (
  Inventory_ID NUMBER,
  Service_ID NUMBER,
  PRIMARY KEY (Inventory_ID, Service_ID),
  FOREIGN KEY (Inventory_ID) REFERENCES Inventory(Inventory_ID),
  FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID)
);

-- 13. Equipment
CREATE TABLE Equipment (
  Equipment_ID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Condition VARCHAR2(50),
  Last_Maintenance DATE
);

-- 14. Stylist_Equipment
CREATE TABLE Stylist_Equipment (
  Stylist_ID NUMBER,
  Equipment_ID NUMBER,
  PRIMARY KEY (Stylist_ID, Equipment_ID),
  FOREIGN KEY (Stylist_ID) REFERENCES Stylist(Stylist_ID),
  FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
);

-- Views bookings
CREATE VIEW Today_Bookings AS
SELECT B.Booking_ID, C.Name AS Client_Name, S.Name AS Service_Name, B.Booking_DateTime
FROM Booking B
JOIN Client C ON B.Client_ID = C.Client_ID
JOIN Service S ON B.Service_ID = S.Service_ID
WHERE Booking_DateTime BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE + 1);

-- Index 
CREATE INDEX idx_booking_datetime ON Booking (Booking_DateTime);

--  Data Inserted to client table
INSERT INTO Client VALUES (1, 'ZAKHELE SITHOLE', 'ZAKES@GMAIL.com', '0723456789');
INSERT INTO Client VALUES (2, 'SIYA MZOLO', 'SIYA@GMAIL.com', '0787654321');
INSERT INTO Client VALUES (3, 'AJ MATLHARE', 'MATLHAREJUNIOR@GMAIL.com', '0636194281');

--data inserted to service table
INSERT INTO Service VALUES (1, 'Haircut', 30, 200.00, 'N');
INSERT INTO Service VALUES (2, 'Premium Color', 90, 800.00, 'Y');

---DATA IN THE STYLIST TABLE
INSERT INTO Stylist VALUES (1, 'ANGELA BUHLE', 'Coloring', '09:00-17:00', 5);
INSERT INTO Stylist VALUES (2, 'BUHLE SITHOLE', 'Cutting', '10:00-18:00', 3);

--DATA IN JUNIOR STYLIST TABLE
INSERT INTO Junior_Stylist VALUES (2, 1, 'In Progress', 4, 'Y');
INSERT INTO Senior_Stylist VALUES (1, 'Y', 'Coloring', 5, 'Y', 'Y');

--DATA IN BOOKING TABLE
INSERT INTO Booking VALUES (1, 1, 1, SYSDATE, 'Completed');
INSERT INTO Booking VALUES (2, 2, 2, SYSDATE, 'Pending');

--DATA IN PAYMENT TABLE
INSERT INTO Payment VALUES (1, 1, 'Card', 200.00, SYSDATE);

--INSERTING DATA INTO STYLISTBOOKING TABLE
INSERT INTO Stylist_Booking VALUES (1, 1);
INSERT INTO Stylist_Booking VALUES (2, 2);

--INSERTING TO TRAING TABLE
INSERT INTO Training VALUES (1, 'Advanced Coloring', 5, 'Y');
INSERT INTO Stylist_Training VALUES (1, 1, SYSDATE - 30);

--INSERTING DATA IN THE INVENTORY TABLE
INSERT INTO Inventory VALUES (1, 'Hair Color Kit', 15, 5, SYSDATE - 10);
INSERT INTO Inventory_Service VALUES (1, 2);

--DATA IN EQUIPMENT TABLE
INSERT INTO Equipment VALUES (1, 'Hair Dryer', 'Good', SYSDATE - 5);
INSERT INTO Stylist_Equipment VALUES (1, 1);


--QUERIES
--  Limit rows and columns
SELECT Name, Email FROM Client WHERE ROWNUM <= 5;
SELECT Client_ID, Phone FROM Client WHERE ROWNUM <= 5;
SELECT Booking_ID, Status FROM Booking WHERE ROWNUM <= 5;
SELECT Service_ID, Name FROM Service WHERE ROWNUM <= 5;

--  Sorting
SELECT * FROM Service ORDER BY Price DESC;
SELECT * FROM Stylist ORDER BY Experience_Years DESC;
SELECT * FROM Booking ORDER BY Booking_DateTime DESC;
SELECT * FROM Client ORDER BY Name ASC;

--  LIKE, AND, OR
SELECT * FROM Client WHERE Email LIKE '%gmail.com' AND Phone IS NOT NULL;
SELECT * FROM Service WHERE Name LIKE 'Premium%' OR Price > 500;
SELECT * FROM Stylist WHERE Name LIKE '%BUHLE%' AND Experience_Years >= 3;
SELECT * FROM Equipment WHERE Condition LIKE 'G%' OR Name LIKE '%Dryer';

--  Character functions
SELECT INITCAP(Name) AS Proper_Name, LENGTH(Phone) AS Phone_Length FROM Client;
SELECT UPPER(Specialization) FROM Stylist;
SELECT LOWER(Email) FROM Client;
SELECT SUBSTR(Name, 1, 5) AS Short_Name FROM Client;

--  ROUND or TRUNC
SELECT ROUND(Price, 0) FROM Service;
SELECT TRUNC(Amount_Paid) FROM Payment;
SELECT ROUND(Experience_Years, 0) FROM Stylist;
SELECT TRUNC(SYSDATE - Booking_DateTime) FROM Booking;

--  Date function
SELECT Booking_ID, Booking_DateTime, SYSDATE - Booking_DateTime AS Days_Ago FROM Booking;
SELECT Last_Maintenance, SYSDATE - Last_Maintenance AS Days_Since_Maintenance FROM Equipment;
SELECT Last_Restocked, SYSDATE - Last_Restocked AS Days_Since_Restock FROM Inventory;
SELECT Payment_DateTime, EXTRACT(MONTH FROM Payment_DateTime) AS Payment_Month FROM Payment;

-- Aggregate
SELECT COUNT(*) AS Total_Clients FROM Client;
SELECT MAX(Price) AS Max_Service_Price FROM Service;
SELECT AVG(Experience_Years) AS Avg_Experience FROM Stylist;
SELECT MIN(Stock_Level) AS Min_Stock FROM Inventory;

-- GROUP BY and HAVING
SELECT Service_ID, COUNT(*) AS Bookings FROM Booking GROUP BY Service_ID HAVING COUNT(*) > 1;
SELECT Stylist_ID, COUNT(*) AS Trainings FROM Stylist_Training GROUP BY Stylist_ID HAVING COUNT(*) > 0;
SELECT Client_ID, COUNT(*) AS Payments FROM Booking GROUP BY Client_ID HAVING COUNT(*) > 1;
SELECT Inventory_ID, COUNT(*) FROM Inventory_Service GROUP BY Inventory_ID HAVING COUNT(*) >= 1;

-- Joins
SELECT C.Name, S.Name AS Service FROM Client C JOIN Booking B ON C.Client_ID = B.Client_ID JOIN Service S ON B.Service_ID = S.Service_ID;
SELECT S.Name, E.Name AS Equipment FROM Stylist S JOIN Stylist_Equipment SE ON S.Stylist_ID = SE.Stylist_ID JOIN Equipment E ON SE.Equipment_ID = E.Equipment_ID;
SELECT ST.Stylist_ID, T.Course_Name FROM Stylist_Training ST JOIN Training T ON ST.Training_ID = T.Training_ID;
SELECT B.Booking_ID, P.Amount_Paid FROM Booking B JOIN Payment P ON B.Booking_ID = P.Booking_ID;
SELECT C.Name, P.Payment_Method FROM Client C JOIN Booking B ON C.Client_ID = B.Client_ID JOIN Payment P ON B.Booking_ID = P.Booking_ID;

--  Subquery
SELECT * FROM Service WHERE Price > (SELECT AVG(Price) FROM Service);
SELECT * FROM Stylist WHERE Experience_Years > (SELECT MIN(Experience_Years) FROM Stylist);
SELECT * FROM Inventory WHERE Stock_Level < (SELECT AVG(Stock_Level) FROM Inventory);
SELECT * FROM Booking WHERE Client_ID IN (SELECT Client_ID FROM Client WHERE Name LIKE '%ZAKHELE%');

-- Company info requirement: Daily revenue report
SELECT TRUNC(P.Payment_DateTime) AS Payment_Date, SUM(P.Amount_Paid) AS Total_Revenue FROM Payment P GROUP BY TRUNC(P.Payment_DateTime);


