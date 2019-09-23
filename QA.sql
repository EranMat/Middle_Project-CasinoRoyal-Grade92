USE DB_Casino_Royal
GO



--QA FOR REGISTER--

--QA test for corect insert register procedure
EXEC USP_Regisration 'efrat','eFgcg54','efrat','shapira','ceasarea','Israel','efishapira@gmail.com', 'female','12-01-90'

--QA test for register procedure- same username
EXEC USP_Regisration 'efrat','eFgcg54','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'

--QA test for register procedure- strong password
	--small
EXEC USP_Regisration 'EFRAAT18','GGFFIU54','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'
	--Upper
EXEC USP_Regisration 'EFRAAT18','efratt54','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'
	--Digit
EXEC USP_Regisration 'EFRAAT18','efrattDF','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'
	--The word password
EXEC USP_Regisration 'EFRAAT19','PASSwORD2','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'
	--Same as username
EXEC USP_Regisration 'EfRAAT19','EfRAAT19','Liat','shadmi','mizra','israel','efihapira@gmail.com', 'female','12-01-90'

--QA test for register procedure- same EMAIL
EXEC USP_Regisration 'Liat','eFgcg54','Liat','shadmi','mizra','israel','efishapira@gmail.com', 'female','12-01-90'

--QA test for register procedure- EMAIL format
EXEC USP_Regisration 'Liat','eFgcg54','Liat','shadmi','mizra','israel','efishapiragmail.com', 'female','12-01-90'

--QA test for register procedure- same EMAIL
EXEC USP_Regisration 'Liat','eFgcg54','Liat','shadmi','mizra','israel','liat@gmail.com', 'female','12-01-05'

--QA test for register procedure- Country
EXEC USP_Regisration 'eran','eFgcg54','eran','meteraso','haifa','brazill','liat@gmail.com', 'female','12-01-89'

--QA test for register procedure- Gender
EXEC USP_Regisration 'eran','eFgcg54','eran','meteraso','haifa','brazil','liat@gmail.com', 'malek','12-01-89'



--Some exstra users
EXEC USP_Regisration 'Yuval','Yuval123','Yuval','Dayan','Tel-Aviv','Israel','Yuval1234@gmail.com', 'Female','12-07-92'
EXEC USP_Regisration 'Shlomo' ,'Salomon1','Shlomo','Nahum','Beer-Sheva','Israel','Salomonkalu@yahoo.com', 'Male','05-12-85'
EXEC USP_Regisration 'Moti' ,'Motek18','MotiL','Luchim','Arce','Israel','Motek@walla.co.il', 'Male','01-01-97'





--QA test for LOGIN procedure--

--corect
EXEC USP_LOGIN 'efrat','eFgcg54'

--already loged in user
EXEC USP_LOGIN 'efrat','eFgcg54'

--5 incorect 
EXEC USP_LOGIN 'Yuval','Yuval178'
EXEC USP_LOGIN 'Yuval','Yuval178'
EXEC USP_LOGIN 'Yuval','Yuval178'
EXEC USP_LOGIN 'Yuval','Yuval178'
EXEC USP_LOGIN 'Yuval','Yuval178'



--QA test for UnBlock prcedure-- 
EXEC USP_UnBlock 2


--QA test for Cashier prcedure--
EXEC USP_Chashier 1,100,'Deposit'
EXEC USP_Chashier 2,200,'Cashout'
EXEC USP_Chashier 2,200,'Deposit'
EXEC USP_Chashier 3,500,'Deposit'

SELECT* FROM UTBL_BankRoll_Trans

--QA test for TRIGER--
SELECT* FROM UTBL_UserName --The Total Bankroll was updated


--QA test for Game Procedure-- (Press couple of time)
EXEC USP_GameSM 2, 20
EXEC USP_GameSM 1, 10

select* FROM UTBL_GameRound


-- QA reports

-- 1) Game statistics
SELECT* FROM DBO.Game_History_Report('Yuval')

-- 2) Bankyoll Transaction
SELECT *
FROM DBO.Bankroll_Transactions_Report ('YUVAL', '17/09/2019', '22/09/2019')


-- 3) Game statistics
SELECT * FROM UVW_Game_Statistics_Report

