UPDATE UserManagement.UserSecurity SET [password]= HASHBYTES('MD5', [password]);
select * from UserManagement.UserSecurity;
go

CREATE OR ALTER TRIGGER UserManagement.trg_HashBeforeInsert
ON UserManagement.UserSecurity
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO UserManagement.UserSecurity (
        userEmail, 
        password, 
        securityQuestion, 
        securityAnswer, 
        phone
    )
    SELECT
    userEmail,
        HASHBYTES('MD5', password),
        securityQuestion,
        securityAnswer,
        phone
    FROM inserted;
    end;
go

CREATE OR ALTER TRIGGER UserManagement.trg_HashBeforeUpdate
ON UserManagement.UserSecurity
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE U
    SET 
        U.userEmail = I.userEmail,
        U.password = CASE 
                        WHEN UPDATE(password) THEN HASHBYTES('MD5', I.password) 
                        ELSE U.password 
                     END,
        U.securityQuestion = I.securityQuestion,
        U.securityAnswer = I.securityAnswer,
        U.phone = I.phone
    FROM UserManagement.UserSecurity U
    INNER JOIN inserted I ON U.userEmail = I.userEmail;
END;
GO


