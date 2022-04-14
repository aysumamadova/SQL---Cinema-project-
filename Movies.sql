CREATE DATABASE MoviesS
USE MoviesS

CREATE TABLE Movies(
ID int identity (1,1) primary key,
Name nvarchar(255),
ReleaseDate date
)

CREATE TABLE Genres(
ID int identity (1,1) primary key,
Name nvarchar(255)
)

CREATE TABLE MoviesGenres(
ID int identity (1,1) primary key,
GenresID int references Genres(ID),
MoviesID int references Movies(ID)
)


CREATE TABLE Actors(
ID int identity (1,1) primary key,
Name nvarchar(255),
Surname nvarchar(255),
Age int
)

CREATE TABLE Halls(
ID int identity (1,1) primary key,
Name nvarchar(255),
SeatCount int)

CREATE TABLE Sessionss(
ID int identity (1,1) primary key,
[Time] date)

CREATE TABLE Customers(
ID int identity (1,1) primary key,
Name nvarchar(255),
Surname nvarchar(255),
Age int)

CREATE TABLE MoviesActors(
ID int identity (1,1) primary key,
MoviesID int references Movies(ID),
ActorID int references Actors(ID)
)

CREATE TABLE Tickets(
ID int identity (1,1) primary key,
SolDate date,
Price float,
Place int,
CustomerID int references Customers(ID),
HALLID int references Halls(ID),
MoviesID int  references Movies(ID),
SessionsID int references Sessionss(ID)
)

CREATE TABLE  ButTickets (
ID int identity (1,1) primary key,
CustomerID int  references  Customers(ID),
HALLID int references Halls(ID),
MoviesID int  references Movies(ID),
SessionsID int references Sessionss(ID))




SELECT * FROM Actors
SELECT * FROM Customers
SELECT * FROM Genres
SELECT * FROM Halls
SELECT * FROM Movies
SELECT * FROM MoviesActors
SELECT * FROM MoviesGenres
SELECT * FROM Sessionss
SELECT * FROM Tickets
SELECT * FROM ButTickets

-------------------QUERY1-----------------
CREATE PROCEDURE usp_BuyTicket 
@HallID int,
@SessionsID int,
@MoviesID int,
@CustomerID int
AS 
IF EXISTS (SELECT * FROM ButTickets WHERE (@HallID=HallID AND SessionsID=@SessionsID AND MoviesID=@MoviesID AND CustomerID=@CustomerID))
BEGIN
PRINT 'Place is full'
END
ELSE
INSERT INTO ButTickets( HallID,SessionsID,MoviesID,CustomerID)
VALUES(@HallID ,@SessionsID,@MoviesID,@CustomerID)


EXEC usp_BuyTicket 2,2,1,1
DROP PROCEDURE usp_BuyTicket

-------------------QUERY2-----------------

CREATE FUNCTION GetEmptySeatT( 
@HallID int,
@SessionsID int)
RETURNS int
AS
BEGIN
DECLARE @SeateCount int
SELECT @SeateCount=Halls.SeatCount- COUNT(Sessionss.ID) FROM ButTickets
JOIN Halls 
ON ButTickets.HALLID=Halls.ID
JOIN Sessionss
ON ButTickets.SessionsID=Sessionss.ID
GROUP BY Halls.SeatCount , Sessionss.ID 
RETURN @SeateCount
END

SELECT dbo.GetEmptySeatT(1,3)


