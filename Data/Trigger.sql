create trigger AdjustmentUpdateAlert 
on tblCheckoutItem
AFTER INSERT
NOT FOR REPLICATION
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @ItemAlertValue INT
	   DECLARE @ItemSum INT
	   DECLARE @ItemId INT
	   SELECT @ItemId = INSERTED.ItemId FROM INSERTED
	   select * from tblItem;
	EXEC @ItemAlertValue= dbo.GetItemAlertValue @ItemId
    EXEC @ItemSum=ItemSumCalculate @ItemId
	
IF @ItemSum<@ItemAlertValue
BEGIN
	IF NOT EXISTS(select * from tblAlertQty where ItemId=@ItemId)
	BEGIN
    INSERT INTO dbo.tblAlertQty (ItemId,Notify,NotifyDate) 
       VALUES(@ItemId, 1,GETDATE());
	END
	ELSE
	BEGIN
		UPDATE tblAlertQty
	   SET Notify = 1, NotifyDate = GETDATE()
	   WHERE ItemId=@ItemId;
	END
END
ELSE
BEGIN
    IF  EXISTS(select * from tblAlertQty where ItemId=@ItemId)
    BEGIN
	   UPDATE tblAlertQty
	   SET Notify = 0, NotifyDate = GETDATE()
	   WHERE ItemId=@ItemId;
	END
END
       
END