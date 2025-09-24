CREATE TABLE Buses (
    bus_id INT PRIMARY KEY,
    origin VARCHAR(255),
    destination VARCHAR(255),
    time varchar(50)
);



INSERT INTO Buses (bus_id, origin, destination, time)
VALUES 
(1, 'Station A', 'Station B', '06:20'),
(2, 'Station C', 'Station D', '09:30'),
(3, 'Station A', 'Station B', '10:15'),
(4, 'Station E', 'Station F', '14:45'),
(5, 'Station A', 'Station B', '17:04'),
(6, 'Station C', 'Station D', '20:40');



CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    origin VARCHAR(255),
    destination VARCHAR(255),
    arrival_time varchar(50)
);


INSERT INTO Passengers (passenger_id, origin, destination, arrival_time)
VALUES 
(101, 'Station A', 'Station B', '05:30'),
(102, 'Station E', 'Station F', '11:23'),
(103, 'Station C', 'Station D', '09:15'),
(104, 'Station A', 'Station B', '18:35'),
(105, 'Station C', 'Station D', '13:23'),
(106, 'Station E', 'Station F', '16:36'),
(107, 'Station A', 'Station B', '15:57'),
(108, 'Station A', 'Station B', '13:47');



with bus1 as 
 (select bus_id,origin,destination,dense_rank() over(order by origin,destination) as rnum, coalesce(lag(time,1) over (partition by origin,destination order by time),"00:00") as next_time,time from buses),
bus2 as 
(select passenger_id,origin,destination,dense_rank() over(order by origin,destination) as rnum, arrival_time from passengers)
select a.bus_id,coalesce(pass_count.passengers_on_board,0) as "passengers_on_board" from bus1 a left join 
(select a.bus_id, count(b.passenger_id) "passengers_on_board",b.rnum as rnum from bus1 a join bus2 b on a.rnum=b.rnum where b.arrival_time>=a.next_time and  b.arrival_time<=a.time group by a.bus_id,b.rnum order by a.bus_id) as pass_count  on a.bus_id=pass_count.bus_id order by a.bus_id 





