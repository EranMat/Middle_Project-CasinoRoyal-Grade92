USE Master
go

--DB
drop DATABASE IF EXISTS DB_Casino_Royal

CREATE DATABASE DB_Casino_Royal

USE DB_Casino_Royal
GO


--TB Username

CREATE TABLE UTBL_UserName
(
	[UserID] INT PRIMARY KEY IDENTITY (1,1) ,
    [User Name] NVARCHAR(10) UNIQUE NOT NULL,
	[Password] NVARCHAR(10) NOT NULL,
    [First Name] NVARCHAR(20) NOT NULL,
	[Last Name] NVARCHAR(20) NOT NULL,
	[Address] NVARCHAR(100) DEFAULT '-',
	[Country] NVARCHAR(50) NOT NULL,
	[E-Mail] NVARCHAR(100) NOT NULL,
	[Gender] NVARCHAR(6) NOT NULL,
	[Birth Date] DATE NOT NULL,
	[Login Counter] INT DEFAULT 0 NOT NULL,
	[Login] NVARCHAR(5) DEFAULT 'NO' NOT NULL,
	[BankRoll] MONEY DEFAULT 0 NOT NULL
)
ALTER TABLE UTBL_UserName
ADD CONSTRAINT [Check.E-Mail] CHECK ([E-Mail] LIKE '%@%.%')



--TB Country

CREATE TABLE UTBL_Country
(
	[Country Name] NVARCHAR(50) PRIMARY KEY NOT NULL
)

INSERT INTO UTBL_Country
VALUES ('Afghanistan'), ('Albania'), ('Algeria'), ('Andorra'), ('Angola'), ('Argentina'), ('Armenia'), ('Australia'), ('Austria'), ('Azerbaijan'), ('Bahamas'),
('Bahrain'), ('Bangladesh'), ('Barbados'), ('Belarus'), ('Belgium'), ('Belize'), ('Benin'),	('Bolivia'), ('Bosnia and Herzegovina'), ('Botswana'), ('Brazil'),
('Bulgaria'), ('Burkina Faso'), ('Burundi'), ('Cambodia'), ('Cameroon'), ('Canada'), ('Cape Verde'), ('Chad'), ('Chile'), ('China'), ('Colombia'), ('Comoros'),
('Congo'), ('Cook Islands'), ('Costa Rica'), ('Ivory Coast'), ('Croatia'), ('Cuba'), ('Cyprus'), ('Czech Republic'), ('Democratic Republic of the Congo'), ('Denmark'),
('Dominican Republic'), ('Ecuador'), ('Egypt'), ('El Salvador'), ('Eritrea'), ('Estonia'), ('Ethiopia'), ('Fiji'), ('Finland'), ('France'), ('Gabon'), ('Gambia'),
('Georgia'), ('Germany'), ('Ghana'), ('Gibraltar'), ('Greece'), ('Guatemala'), ('Guinea'), ('Guinea-Bissau'), ('Haiti'), ('Honduras'), ('Hong Kong'), ('Hungary'),
('Iceland'), ('India'), ('Indonesia'), ('Iran'), ('Iraq'), ('Ireland'), ('Isle of Man'), ('Israel'), ('Italy'), ('Jamaica'), ('Japan'), ('Jordan'), ('Kazakhstan'),
('Kenya'), ('Kosovo'), ('Kuwait'), ('Kyrgyzstan'), ('Laos'), ('Latvia'), ('Lebanon'), ('Liberia'), ('Liechtenstein'), ('Lithuania'), ('Luxembourg'), ('Macao'), ('Macedonia'),
('Madagascar'),	('Malaysia'), ('Maldives'), ('Mali'), ('Malta'), ('Mexico'), ('Moldava'), ('Monaco'), ('Mongolia'), ('Montenegro'), ('Morocco'), ('Mozambique'),
('Myanmar'), ('Namibia'), ('Nepal'), ('Netherlands'), ('New Zealand'), ('Nicaragua'), ('Niger'), ('Nigeria'), ('North Korea'), ('Norway'), ('Oman'), ('Pakistan'), ('Palestine'),
('Panama'), ('Paraguay'), ('Peru'), ('Phillipines'), ('Poland'), ('Portugal'), ('Puerto Rico'), ('Qatar'), ('Romania'), ('Russia'), ('Rwanda'), ('Samoa'), ('San Marino'), 
('Saudi Arabia'), ('Senegal'), ('Serbia'), ('Seychelles'), ('Sierra Leone'), ('Singapore'), ('Slovakia'), ('Slovenia'), ('Solomon Islands'), ('Somalia'), ('South Africa'),
('South Korea'), ('Spain'), ('Sri Lanka'), ('Sudan'), ('Suriname'), ('Swaziland'), ('Sweden'), ('Switzerland'), ('Syria'), ('Taiwan'), ('Tajikistan'), ('Tanzania'),
('Thailand'), ('Togo'), ('Tunisia'), ('Turkey'), ('Turkmenistan'), ('Uganda'), ('Ukraine'), ('United Arab Emirates'), ('United Kingdom'), ('United States'), ('Uruguay'),
('Uzbekistan'), ('Vanuatu'), ('Venezuela'), ('Vietnam'), ('Yemen'), ('Zambia'), ('Zimbabwe')

	ALTER TABLE UTBL_UserName
	ADD CONSTRAINT FK_Country
	FOREIGN KEY (Country) REFERENCES UTBL_Country([Country Name]);


--TB Gender

CREATE TABLE UTBL_Gender 
(
	Gender NVARCHAR(6) PRIMARY KEY NOT NULL
)

INSERT INTO UTBL_Gender
VALUES ('Male'), ('Female')

	ALTER TABLE UTBL_UserName
	ADD CONSTRAINT FK_Gender
	FOREIGN KEY (Gender) REFERENCES UTBL_Gender(Gender);


--TB Symbols

CREATE TABLE UTBL_Symbols
(
 SymbolID INT PRIMARY KEY NOT NULL,
 SymbolChar NVARCHAR(1) UNIQUE NOT NULL
)

INSERT INTO UTBL_Symbols (SymbolID, SymbolChar)
VALUES (1,'@'), (2,'#'), (3,'$'), (4,'%'), (5,'&'), (6,'*')



--TB Games

CREATE TABLE UTBL_GameRound
(
	RoundNumber INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
	UserID INT FOREIGN KEY REFERENCES UTBL_UserName (userid),
	GameType NVARCHAR(10),
	BetAmount MONEY,
	WinOrLose NVARCHAR(5),
	Date DATETIME
)



--Transaction table

CREATE TABLE UTBL_Transaction_Type
(
  TransactionType NVARCHAR (10) PRIMARY KEY
  )

INSERT INTO UTBL_Transaction_Type
VALUES ('Deposit'),('Cashout'),('Win'),('Lose'),('Bonus')


 --BankRoll Table with reference to Transaction table

CREATE TABLE UTBL_BankRoll_Trans
(
  UserID INT NOT NULL,
  TransactionNum INT IDENTITY (1,1),
  TransactionType NVARCHAR(10) ,
  Date DATETIME NOT NULL,
  Amount MONEY NOT NULL,
  

  PRIMARY KEY (TransactionNum),
  FOREIGN KEY (UserID) REFERENCES UTBL_UserName (UserID),
  FOREIGN KEY (TransactionType) REFERENCES UTBL_Transaction_Type (TransactionType)
)

GO



--RAND NAMBER-----------------------------------------------------------------------------------------------------------

create view [dbo].[vv_getRANDValue]
as
select rand() as value

GO

Create function [dbo].[fn_RandomNum](@Lower int, @Upper int)
returns int
as
Begin
DECLARE @Random INT;
if @Upper > @Lower
	SELECT @Random = (@Upper - @Lower) * (SELECT Value FROM vv_getRANDValue) + @Lower
Else
	SELECT @Random = (@Lower - @Upper) * (SELECT Value FROM vv_getRANDValue) + @Upper
return @Random
end

GO


--STRONG PASSWORD  
CREATE FUNCTION dbo.GeneratePassword ()
RETURNS varchar(6)
AS
BEGIN
  DECLARE @randInt int;
  DECLARE @NewCharacter varchar(1); 
  DECLARE @NewPassword varchar(6); 
  SET @NewPassword='';

  --6 random characters
  WHILE (LEN(@NewPassword) <3)
  BEGIN
    select @randInt=[dbo].[fn_RandomNum](48,122)
	--      0-9           < = > ? @ A-Z [ \ ]                   a-z      
    IF @randInt<=57 OR (@randInt>=60 AND @randInt<=93) OR (@randInt>=97 AND @randInt<=122)
    Begin
      select @NewCharacter=CHAR(@randInt)
      select @NewPassword=CONCAT(@NewPassword, @NewCharacter)
    END
  END

  --Ensure a lowercase
  select @NewCharacter=CHAR([dbo].[fn_RandomNum](97,122))
  select @NewPassword=CONCAT(@NewPassword, @NewCharacter)
  
  --Ensure an upper case
  select @NewCharacter=CHAR([dbo].[fn_RandomNum](65,90))
  select @NewPassword=CONCAT(@NewPassword, @NewCharacter)
  
  --Ensure a number
  select @NewCharacter=CHAR([dbo].[fn_RandomNum](48,57))
  select @NewPassword=CONCAT(@NewPassword, @NewCharacter)
  
  --Ensure a symbol
  WHILE (LEN(@NewPassword) <6)
  BEGIN
    select @randInt=[dbo].[fn_RandomNum](33,64)
	--           !               # $ % &                            < = > ? @
    IF @randInt=33 OR (@randInt>=35 AND @randInt<=38) OR (@randInt>=60 AND @randInt<=64) 
    Begin
     select @NewCharacter=CHAR(@randInt)
     select @NewPassword=CONCAT(@NewPassword, @NewCharacter)
    END
  END

  RETURN(@NewPassword);
END;

GO
--   )





--REGISTER

CREATE PROCEDURE USP_Regisration
(
@UserName NVARCHAR(10),
@Password NVARCHAR(10),
@FirstName NVARCHAR(20),
@LastName NVARCHAR(20),
@Address NVARCHAR(100),
@Country NVARCHAR(20),
@Email NVARCHAR(100),
@Gender NVARCHAR(10),
@BirthDate DATE
)
AS
BEGIN
DECLARE @AlternativeUser NVARCHAR(20)
-- Check username
IF EXISTS (SELECT [User Name] FROM UTBL_UserName WHERE [User Name]=@UserName)
	BEGIN
	lABEL: 
	SET @AlternativeUser=@UserName+CONVERT(NVARCHAR(2),[dbo].[fn_RandomNum](11,99))
	IF EXISTS (SELECT [User Name] FROM UTBL_UserName WHERE [User Name]=@AlternativeUser)
		GOTO LABEL
		PRINT 'The UserName Is already exists. You can choose another UserName: '+@AlternativeUser
		RETURN
	END

-- Check password
IF (@password = lower(@password) COLLATE Latin1_General_BIN)OR (@password = Upper(@password) COLLATE Latin1_General_BIN)OR (@password NOT LIKE '%[0-9]%')
	BEGIN
	PRINT 'You need to enter a strong password!'
	RETURN
	END

IF @Password LIKE '%PASSWORD%'
	BEGIN
	PRINT 'Password can not be the word "password"'
	RETURN
	END

IF @Password=@UserName
	BEGIN
	PRINT 'Password can not be the same as user name'
	RETURN
	END

-- Check email
IF EXISTS (SELECT [E-Mail] FROM UTBL_UserName WHERE [E-Mail]=@Email)
	BEGIN
	PRINT 'The E-mail: ' + @Email + ' Is already exists.'
	RETURN
	END

IF @Email not like '%@%.%'
	BEGIN
	PRINT 'The email address must be in a legal email address format!'
	RETURN
	END

--Check 18 years old
IF (YEAR(GETDATE())- YEAR(@birthdate))<18
	BEGIN
	PRINT 'sorry, You must be abov 18 years old'
	RETURN
	END

--Check country
IF NOT EXISTS (SELECT [Country Name] FROM UTBL_Country WHERE [Country Name]=@Country)
	BEGIN
	PRINT 'Country must be choosed from the list!'
	RETURN
	END

--Check Gender
IF NOT EXISTS (SELECT Gender FROM UTBL_Gender WHERE Gender=@Gender)
	BEGIN
	PRINT 'Gender must be choosed from the list!'
	RETURN
	END

--DML if everything above is OK 
INSERT INTO  UTBL_UserName ([User Name],Password,[First Name],[Last Name],Address,Country,[E-Mail],Gender,[Birth Date])
VALUES (@Username, @Password, @FirstName, @LastName, @Address, @Country, @Email, @Gender, @BirthDate)
PRINT '***WELCOME TO CASINO ROYAL***   Get 10$ bonus'
INSERT INTO UTBL_BankRoll_Trans 
VALUES (@@IDENTITY, 'Bonus',GETDATE(), 10)
RETURN
END

GO



--LOGIN
CREATE PROCEDURE USP_LogIn
(
@UserName NVARCHAR(10),
@Password NVARCHAR(10)
)
AS
IF EXISTS (SELECT [User Name],Password FROM UTBL_UserName WHERE [User Name]=@UserName AND Password=@Password)
BEGIN
	IF (SELECT [Login] FROM UTBL_UserName WHERE [User Name]=@UserName)='YES'
		BEGIN 
		PRINT 'You are already loged in'
		RETURN
		END
	ELSE
		BEGIN
		PRINT 'You Loged in secssecfuly'
		DECLARE @Bankroll money =(SELECT bankroll from UTBL_UserName WHERE [User Name]=@Username)
		PRINT 'Your bank roll is '+CONVERT(CHAR,@Bankroll)
		UPDATE UTBL_UserName SET [Login] = 'YES' where [User Name]=@UserName
		UPDATE UTBL_UserName SET[Login counter] = 0 where [User Name]=@UserName
		RETURN
		END
RETURN
END
ELSE
	IF (SELECT [Login counter] FROM UTBL_UserName WHERE [User Name]=@UserName)<5
	BEGIN 
	PRINT 'User or password is incorect'
	UPDATE UTBL_UserName SET [Login counter] = [Login counter]+1 where [User Name]=@UserName
	RETURN
	END
	ELSE	
	PRINT 'You are blocked, please call the support'

GO


--UnBlock
CREATE PROCEDURE USP_UnBlock
(
@UserId INT
)
AS 
BEGIN
DECLARE @RandPassword NVARCHAR(6)
SET @RandPassword=dbo.GeneratePassword ()
UPDATE UTBL_UserName SET password=@RandPassword WHERE UserID=@UserId
UPDATE UTBL_UserName SET [Login counter]=0 WHERE UserID=@UserId
PRINT 'Your new password is:'
PRINT @RandPassword
RETURN
END

GO


--- Chashier--
CREATE PROCEDURE USP_Chashier
(
@UserID int, 
@Amount money, 
@TransactionType Nvarchar(10) 
)
AS
IF @TransactionType='Cashout'
	IF @Amount>(SELECT BankRoll FROM UTBL_UserName WHERE @UserID=UserID)
	BEGIN
	PRINT 'The amount you have is less than the amount you want to Cashout. Please Try Again.'
	RETURN
	END

IF @TransactionType='Cashout'
INSERT INTO UTBL_BankRoll_Trans (UserID , TransactionType, Date, Amount)
VALUES (@UserID, @TransactionType , GETDATE(), @Amount*(-1))

IF @TransactionType='Deposit'
INSERT INTO UTBL_BankRoll_Trans (UserID , TransactionType, Date, Amount)
VALUES (@UserID, @TransactionType , GETDATE(), @Amount)

GO

-----Game----
CREATE PROCEDURE USP_GameSM
(
@UserId INT,
@BetAmount INT
)
AS
IF @BetAmount>(SELECT BankRoll FROM UTBL_UserName WHERE UserID=@UserId)
	BEGIN 
	PRINT 'You can only bet on amount of money you have in your bankroll. please go to the Cachier or reduce your bet amount'
	RETURN
	END
ELSE
	BEGIN
	DECLARE @Symbol1 NVARCHAR(5), @Symbol2 NVARCHAR(5), @Symbol3 NVARCHAR(5), @WinOrLose NVARCHAR(10)
	SET @Symbol1=(SELECT TOP 1 SymbolChar FROM UTBL_Symbols ORDER BY NEWID())
	SET @Symbol2=(SELECT TOP 1 SymbolChar FROM UTBL_Symbols ORDER BY NEWID())
	SET @Symbol3=(SElECT TOP 1 SymbolChar FROM UTBL_Symbols ORDER BY NEWID())
	IF (@Symbol1=@Symbol2) and (@Symbol2=@Symbol3)
		BEGIN
		PRINT 'you won! '+CONVERT(CHAR(10),@BetAmount)+'$!'
		SET @WinOrLose='Win'
		INSERT INTO UTBL_BankRoll_Trans (UserId, TransactionType, DATE, Amount)
		VALUES (@UserId, @WinOrLose, GETDATE(), @BetAmount)
		END
	ELSE
		BEGIN
		PRINT 'Sorry, you lose this time. you can try your luck again..'
		SET @WinOrLose='Lose'
		INSERT INTO UTBL_BankRoll_Trans (UserId, TransactionType, DATE, Amount)
		VALUES (@UserId, @WinOrLose, GETDATE(), @BetAmount*(-1))
		END
	END
INSERT INTO UTBL_GameRound (UserID, GameType, BetAmount, WinOrLose, Date)
VALUES (@UserId,'SlotMachin',@BetAmount, @WinOrLose, GETDATE())

GO


---Trigger for BankRoll--

CREATE TRIGGER Bankroll_Insert
ON UTBL_BankRoll_Trans
FOR INSERT
AS
BEGIN
UPDATE UTBL_UserName
SET BankRoll = (U.bankroll + I.Amount)
FROM UTBL_UserName AS U INNER JOIN Inserted AS I
ON U.UserID = I.UserID
where I.TransactionNum= TransactionNum
END

GO	

--Reports-------------------------------------------------------------------------------------------------------------------------

-- 1) Game history Report--
CREATE FUNCTION DBO.Game_History_Report(@UserName NVARCHAR(20))
RETURNS @TABLE TABLE (GameType NVARCHAR(10),RoundNumber int, BetAmount MONEY,WinOrLose NVARCHAR(5), Date DATETIME)
AS
BEGIN
INSERT INTO @TABLE (GameType, RoundNumber, BetAmount, WinOrLose, Date)
SELECT GR.GameType, ROW_NUMBER() OVER (PARTITION BY GR.UserID ORDER BY GR.Date DESC) RoundNumber, GR.BetAmount, GR.WinOrLose, GR.Date
FROM UTBL_GameRound GR JOIN UTBL_UserName UN
ON GR.UserID=UN.UserID
WHERE UN.[User Name] = @UserName
ORDER BY GR.Date DESC
RETURN
END

GO


-- 2) Bankyoll Transaction
CREATE FUNCTION DBO.Bankroll_Transactions_Report(@UserName NVARCHAR(20), @BeginDate NVARCHAR(20), @EndDate NVARCHAR(20))
RETURNS TABLE
RETURN  
SELECT TransactionOfUser, BRT.TransactionNum, BRT.TransactionType, CONVERT(NVARCHAR,DATE,103) Date, BRT.Amount, SUM(BRT.Amount) OVER (PARTITION BY BRT.UserID ORDER BY BRT.TransactionNum) 'BankRoll'
FROM
(SELECT BRT.UserID ,BRT.TransactionNum, BRT.TransactionType, BRT.DATE, BRT.Amount, ROW_NUMBER() OVER (PARTITION BY BRT.UserID ORDER BY BRT.UserID) AS 'TransactionOfUser'
FROM UTBL_BankRoll_Trans BRT join UTBL_UserName UN
ON BRT.UserID = UN.UserID
WHERE UN.[User Name] = @UserName AND CONVERT(NVARCHAR,DATE,103) BETWEEN @BeginDate AND @EndDate) BRT

GO

-- 3) Game Statistics Report--
CREATE VIEW UVW_Game_Statistics_Report AS
SELECT CS.Date, CS.[Number of Rounds], CS.[Number of Winning], CS.[Total Bet Amount], ISNULL(CS.[Total Winning Amount],0) AS 'Total Winning Amount'
FROM
(SELECT CONVERT(NVARCHAR,Date,103) AS Date , COUNT(RoundNumber) AS 'Number of Rounds', COUNT(WinOrLose) 'Number of Winning', SUM(BetAmount) 'Total Bet Amount',
(SELECT SUM(Amount) FROM UTBL_BankRoll_Trans WHERE TransactionType = 'Win') 'Total Winning Amount'
FROM UTBL_GameRound
WHERE Date BETWEEN GETDATE()-7 AND GETDATE()
GROUP BY CONVERT(NVARCHAR,Date,103)) CS

GO