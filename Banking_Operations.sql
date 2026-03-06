create or replace procedure ttsbank_newaccount
(
    cus_name in varchar2,
    cus_phno in number,
    cus_mail in varchar2,
    cus_aadhar in number,
    cus_pan in varchar2,
    cus_pwd in varchar2,
    cus_sub_prod_id in number,
    p_trans_amount in number,
    trans_type in varchar2,
    benef_account in varchar2,
    trans_mode in varchar2,
    flag in number,
    p_accn_no  in number,
    msg out varchar2
)as
cid number;
cpid number;
accno number;
v_cus_product number;
v_available_bal number;
v_bal_limit  number;
v_withdraw_limit number;
v_limit number;
v_customer_id number;
v_count number;
v_password varchar2(50);
begin
if flag = 1 then
insert into ttsbank_customers(CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_PHNO,CUSTOMER_MAIL, AADHAR_NO, PAN_NO, PASSWORD)
values(sq1.nextval,cus_name,cus_phno,cus_mail,cus_aadhar,cus_pan,cus_pwd) returning customer_id into cid;
insert into ttsbank_cus_products (CUS_PRODUCT_ID, SUB_PRODUCT_ID, CUSTOMER_ID, ACCOUNT_NO,AVAILABLE_BALANCE)
values (sq2.nextval,cus_sub_prod_id,cid,sq4.nextval,p_trans_amount)
returning cus_product_id,account_no into cpid,accno;
insert into ttsbank_cus_transactions(CUS_TRANS_ID, CUS_PRODUCT_ID, TRANS_AMOUNT, 
TRANS_TYPE,BENEF_ACCOUNT, TRANS_MODE, ACCOUNT_BALANCE) 
values (sq3.nextval,cpid,p_trans_amount,trans_type,benef_account,trans_mode,p_trans_amount);
msg := 'Account Opened - and your account no is'||accno;
commit;
dbms_output.put_line(msg);
elsif flag = 2 then
select CUS_PRODUCT_ID, available_balance into v_cus_product , v_available_bal      -- to get input from user account_no and to compare get cus_product_id
from ttsbank_cus_products                     
where account_no = p_accn_no;
  select BALANCE_LIMIT, WITHDRAW_LIMIT into v_bal_limit , v_withdraw_limit      -- to get data for check bal_limit and withdraw limit   
from ttsbank_sub_products 
where sub_product_id = (select sub_product_id from ttsbank_cus_products 
where CUS_PRODUCT_ID = v_cus_product);
dbms_output.put_line(1);
select case when v_withdraw_limit >= nvl(sum(a.trans_amount),0) + p_trans_amount 
then 1 else 0 end into v_limit      -- to using condition for check withdraw limit 
from ttsbank_cus_transactions a
where (cus_product_id = v_cus_product and to_char(trans_on,'dd-mon-yyyy') = to_char(sysdate,'dd-mon-yyyy') )and TRANS_TYPE in ('d','D');
    dbms_output.put_line(v_limit);
if (trans_type in ('D','d') and v_bal_limit <=(v_available_bal - p_trans_amount) and v_limit = 1) or trans_type in ('C','c') then
insert into ttsbank_cus_transactions(CUS_TRANS_ID, CUS_PRODUCT_ID, TRANS_AMOUNT, 
TRANS_TYPE,BENEF_ACCOUNT, TRANS_MODE, ACCOUNT_BALANCE) 
values (sq3.nextval, v_cus_product,p_trans_amount,trans_type,benef_account,trans_mode,
case when trans_type in ('C','c') then v_available_bal + p_trans_amount 
when trans_type in ('D','d') then v_available_bal - p_trans_amount end 
) returning account_balance into v_available_bal;
update ttsbank_cus_products set available_balance = v_available_bal where account_no = p_accn_no;
msg := case when trans_type in ('D','d') then 'Debit Success'
when trans_type in ('C','c') then 'Credit Success' end ;
commit;
dbms_output.put_line(msg);
else
raise_application_error(-20000,'Insufficient fund or reached withdraw limit');
end if;
elsif flag = 3 then
select customer_id into v_customer_id
from ttsbank_cus_products                     
where account_no = p_accn_no;
select  count(*) into v_count from
(select customer_password ,customer_id, 
dense_rank()over(partition by customer_id order by password_changed_on desc) as d 
from ttsbank_password_track where customer_id = v_customer_id ) where customer_password = cus_pwd and d<= 3;
select password into v_password from ttsbank_customers where customer_id = v_customer_id;
if v_count > 0 or v_password = cus_pwd then 
msg := 'existing password must be changed';
dbms_output.put_line(msg);
else
update ttsbank_customers set PASSWORD =  cus_pwd where customer_id = v_customer_id;
msg:= 'password updated';
dbms_output.put_line(msg);
end if;
end if;
exception
when others then
dbms_output.put_line(sqlerrm);
end;
/
