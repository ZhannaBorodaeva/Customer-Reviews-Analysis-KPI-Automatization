use magist;
select product_category_name from products;
CREATE TEMPORARY TABLE products_English_transtation
select *
from products
JOIN product_category_name_translation 
USING(product_category_name);#Creates temporary table with English names of categories
select * from products_English_transtation;
CREATE TEMPORARY TABLE products_health_beauty_perfurmery
select *
from products_English_transtation
where product_category_name_english IN('health_beauty','perfurmery');#Temporary table with corresponding categories
select * from products_health_beauty_perfurmery;
select order_purchase_timestamp from orders;
select order_delivered_customer_date from orders;
select payment_value from order_payments;
CREATE TEMPORARY TABLE products_orders_order_payments_health_beauty_perfurmery 
select *
from products_health_beauty_perfurmery
LEFT JOIN order_items
USING (product_id)
LEFT JOIN orders
USING (order_id)
LEFT JOIN order_payments
USING (order_id);
select * from products_orders_order_payments_health_beauty_perfurmery;
CREATE TEMPORARY TABLE credit_card
select product_id, product_category_name_english, order_status, order_purchase_timestamp, payment_type, payment_value #At home at this step add item_id and description of the product
from products_orders_order_payments_health_beauty_perfurmery
where payment_type IN('credit_card');
select * from credit_card;
CREATE TEMPORARY TABLE delivered_paymentrest
select * from credit_card
where order_status='delivered'
having payment_value>1000
order by payment_value desc;
select * from delivered_paymentrest;
CREATE temporary table yearfilter1
select *, YEAR(order_purchase_timestamp) as PurchaseYear
from delivered_paymentrest;
select * from yearfilter1;
CREATE temporary table final2
select product_id, product_category_name_english, order_status, payment_type, payment_value, PurchaseYear
from yearfilter1
where PurchaseYear=2018;
select * from final2;#The final database contains ids of the requested category names, order_status, payment_type, payment_value, Purchase Year (see above)


