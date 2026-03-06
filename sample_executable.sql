declare
v varchar2(50);
begin
ttsbank_newaccount(cus_name => 'Rajesh',
cus_phno => 7209467851, 
cus_mail => 'n@gmail.com', 
cus_aadhar =>123443008888,
cus_pan=>'net',
cus_pwd=> 'one',
cus_sub_prod_id => 3000,
p_trans_amount=>1000,
trans_type=>'d',
benef_account=> 'self',
trans_mode=> 'upi',
flag => 3,
p_accn_no => 10000005,
msg => v);
end;
/
