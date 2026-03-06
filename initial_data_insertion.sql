---After Creating tables and sequence use these plsql block to add some basic initial data .


---Adding Initial data to ttsbank_bank
begin
insert into ttsbank_banks(bank_id, bank_code, bank_location, is_headoffice)
 values(1000,'ttsbnk001','chennai','y');
insert into ttsbank_banks(bank_id, bank_code, bank_location, is_headoffice)
 values(1001,'ttsbnk002','madurai','n');
insert into ttsbank_banks(bank_id, bank_code, bank_location, is_headoffice)
 values(1002,'ttsbnk003','coimbatore','n');
end;
/


  ---Adding Initial data to ttsbank_products
begin
insert into ttsbank_products(product_id, product_name,product_code)
values(2000,'savings bank','sb');
insert into ttsbank_products(product_id, product_name,product_code)
values(2001,'current','cb');
insert into ttsbank_products(product_id, product_name,product_code)
values(2002,'business','bb');
end;
/

  ---Adding Initial data to ttsbank_sub_product
begin
insert into ttsbank_sub_products (sub_product_id, product_id, features,balance_limit, withdraw_limit)
values(3000,2000,'Silver',5000,50000);
insert into ttsbank_sub_products (sub_product_id, product_id, features,balance_limit, withdraw_limit)
values(3001,2000,'Gold',10000,100000);
insert into ttsbank_sub_products (sub_product_id, product_id, features,balance_limit, withdraw_limit)
values(3002,2000,'Platinum',15000,2500000);
end;
/
