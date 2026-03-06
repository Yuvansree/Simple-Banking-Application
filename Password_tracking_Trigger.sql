create or replace trigger ttsbank_password after update of customer_id, password on ttsbank_customers for each row
declare
pragma autonomous_transaction ;
begin
insert into ttsbank_password_track (TRACK_ID, CUSTOMER_ID, CUSTOMER_PASSWORD, PASSWORD_CHANGED_ON)
values (sq5.nextval,:old.customer_id,:old.password, sysdate);
commit; 
end;
/
