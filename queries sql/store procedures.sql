
-- Register Account
CREATE PROCEDURE PopulateCustomer (
    @p_username VARCHAR(30),
    @p_password VARCHAR(30),
    @p_c_name VARCHAR(50),
    @p_c_email VARCHAR(50),
    @p_c_address VARCHAR(80)
)
AS
BEGIN
    DECLARE @v_u_id INT;
    
    -- Find the maximum u_id in the users table and increment it by 1
    SELECT @v_u_id = ISNULL(MAX(u_id), 0) + 1 FROM users;
    
    -- Insert into users table
    INSERT INTO users (u_id, username, password, u_type, status)
    VALUES (@v_u_id, @p_username, @p_password, 'customer', 1);
    
    -- Insert into customer table using the generated u_id
    INSERT INTO customer (c_id, c_name, c_email, c_address, status)
    VALUES (@v_u_id, @p_c_name, @p_c_email, @p_c_address, 1);
END;


-- EXEC
DECLARE	@return_value int

EXEC	@return_value = [dbo].[PopulateCustomer]
		@p_username = N'jundrel1581',
		@p_password = N'1234',
		@p_c_name = N'jundrel alonzo',
		@p_c_email = N'junwell@gmail.com',
		@p_c_address = N'789-d CC'

SELECT	'Return Value' = @return_value

GO

select * from [dbo].[customer]
select * from [dbo].[users]



-- Deactivate account
CREATE TABLE dumb_customer (
    c_id INTEGER PRIMARY KEY,              -- Customer ID
    c_name VARCHAR(50) NOT NULL,           -- Customer name
    c_email VARCHAR(50),                   -- Customer email
    c_address VARCHAR(80),                 -- Customer address
    deactivation_date DATE                 -- Deactivation date
);


CREATE PROCEDURE DeactivateAccount (
    @p_username VARCHAR(30)
)
AS
BEGIN
    DECLARE @v_c_id INT;
    
    -- Get the customer ID associated with the username
    SELECT @v_c_id = u_id
    FROM users
    WHERE username = @p_username;
    
    -- Insert the deactivated account details into the dumb_customer table
    INSERT INTO dumb_customer (c_id, c_name, c_email, c_address, deactivation_date)
    SELECT c_id, c_name, c_email, c_address, GETDATE()
    FROM customer
    WHERE c_id = @v_c_id;
    
    -- Delete the account from the users table
    DELETE FROM users
    WHERE username = @p_username;
    
    -- Delete the account from the customer table
    DELETE FROM customer
    WHERE c_id = @v_c_id;
END;

-- EXEC


select * from [dbo].[customer]
select * from [dbo].[users]
select * from [dbo].[dumb_customer]