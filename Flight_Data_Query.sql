WITH flight1 AS 
(select cust_id,origin as city, 'O' as bool from flight
union all
select cust_id,destination as city,'D' as bool from flight),
flight2 AS
(select cust_id,city from flight1 group by cust_id,city having count(*)=1),
flight3 AS
(select a.* from flight1 a join flight2 b on a.cust_id=b.cust_id and a.city=b.city)
SELECT 
    o.cust_id,
    o.city AS origin_city,
    d.city AS destination_city
FROM 
    flight3 o
JOIN 
    flight3 d 
    ON o.cust_id = d.cust_id
WHERE 
    o.bool = 'O' AND d.bool = 'D';
