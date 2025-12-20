---- таблица пользователей)
CREATE TABLE Useer (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    active_promo_id INT NULL
);


---- таблица самокатов
CREATE TABLE Scooter (
    scooter_id SERIAL PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    battery_level INT CHECK (battery_level BETWEEN 0 AND 100),
    status VARCHAR(20) CHECK (status IN ('available', 'in_use', 'maintenance')),
    location_lat DECIMAL(10,8),
    location_lng DECIMAL(11,8),
    last_maintenance DATE
);


---- таблица тарифов)
CREATE TABLE Tariff (
    tariff_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost_per_minute DECIMAL(10,2) NOT NULL,
    start_fee DECIMAL(10,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);


---- таблица промокодов
CREATE TABLE Promocode (
    promo_id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent INT CHECK (discount_percent BETWEEN 1 AND 100),
    expire_date DATE NOT NULL,
    max_uses INT NOT NULL,
    current_uses INT DEFAULT 0
);


---- таблица прокатов
CREATE TABLE Rental (
    rental_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    scooter_id INT NOT NULL,
    tariff_id INT NOT NULL,
    promo_id INT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NULL,
    cost DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) CHECK (status IN ('active', 'completed', 'cancelled')),
    FOREIGN KEY (user_id) REFERENCES Useer(user_id),
    FOREIGN KEY (scooter_id) REFERENCES Scooter(scooter_id),
    FOREIGN KEY (tariff_id) REFERENCES Tariff(tariff_id),
    FOREIGN KEY (promo_id) REFERENCES Promocode(promo_id)
);


---- таблица платежей
CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    rental_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) CHECK (payment_method IN ('card', 'phone', 'cash')),
    payment_date TIMESTAMP NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rental(rental_id)
);

----таблица использования промокодов
CREATE TABLE PromoUsage (
    usage_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    promo_id INT NOT NULL,
    usage_date TIMESTAMP NOT NULL,
    rental_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Useer(user_id),
    FOREIGN KEY (promo_id) REFERENCES Promocode(promo_id),
    FOREIGN KEY (rental_id) REFERENCES Rental(rental_id),
    UNIQUE(user_id, promo_id, rental_id)
);


------ пользователи
INSERT INTO Useer (first_name, last_name, phone, email, registration_date) VALUES
('Иван', 'Иванов', '79161234567', 'ivan@mail.ru', '2021-01-15'),
('Анна', 'Петрова', '79262345678', 'anna@mail.ru', '2023-02-20'),
('Алексей', 'Сидоров', '79363456789', 'alex@mail.ru', '2023-03-10'),
('Марина', 'Козлова', '79464567890', 'marina@mail.ru', '2024-04-05'),
('Дмитрий', 'Николаев', '79565678901', 'dima@mail.ru', '2025-05-12'),
('Екатерина', 'Федорова', '79666789012', 'katya@mail.ru', '2024-06-18'),
('Павел', 'Морозов', '79767890123', 'pavel@mail.ru', '2024-07-22'),
('Ольга', 'Волкова', '79868901234', 'olga@mail.ru', '2019-08-30'),
('Сергей', 'Алексеев', '79969012345', 'sergey@mail.ru', '2024-09-03'),
('Татьяна', 'Семенова', '79070123456', 'tanya@mail.ru', '2022-10-11');

------------- самокаты
INSERT INTO Scooter (model, battery_level, status, location_lat, location_lng, last_maintenance) VALUES
('Xiaomi Mi Pro 2', 85, 'available', 61.253873, 73.396004, '2024-11-20'),
('Ninebot Max G30', 92, 'available', 61.254500, 73.397200, '2024-12-01'),
('Kugoo Kirin M4', 45, 'in_use', 61.255100, 73.398300, '2024-10-15'),
('Yamato Spark', 100, 'available', 61.256700, 73.399800, '2024-12-05'),
('Halten Diesel', 23, 'maintenance', 61.257300, 73.400500, '2024-09-10'),
('Xiaomi Mi 3', 78, 'available', 61.258000, 73.401200, '2024-11-28'),
('Ninebot F40', 91, 'available', 61.259500, 73.402800, '2024-12-10'),
('Kugoo S3', 67, 'in_use', 61.260200, 73.403900, '2024-11-05'),
('Yamato Light', 88, 'available', 61.261800, 73.405100, '2024-12-03'),
('Halten Speed', 34, 'maintenance', 61.262500, 73.406300, '2024-10-25');

------ тарифы
INSERT INTO Tariff (name, cost_per_minute, start_fee, is_active) VALUES
('Эконом', 5.00, 0, true),
('Стандарт', 7.50, 15, true),
('Премиум', 10.00, 30, true),
('Ночной', 3.00, 10, true),
('Студенческий', 4.50, 0, false);

----- промокоды
INSERT INTO Promocode (code, discount_percent, expire_date, max_uses) VALUES
('WELCOME10', 10, '2024-12-31', 100),
('SUMMER25', 25, '2024-08-31', 50),
('FIRSTRIDE', 15, '2025-01-31', 200),
('WINTER20', 20, '2024-12-25', 75),
('SPRING30', 30, '2024-04-30', 30);

--------- прокаты
INSERT INTO Rental (user_id, scooter_id, tariff_id, promo_id, start_time, end_time, cost, status) VALUES
(1, 1, 1, 1, '2024-12-01 10:30:00', '2024-12-01 11:00:00', 150.00, 'completed'),
(2, 2, 2, NULL, '2024-12-02 14:15:00', '2024-12-02 15:00:00', 337.50, 'completed'),
(3, 3, 3, 2, '2024-12-03 09:00:00', '2024-12-03 09:45:00', 562.50, 'completed'),
(4, 4, 1, NULL, '2024-12-04 18:30:00', NULL, NULL, 'active'),
(5, 5, 4, 3, '2024-12-05 22:00:00', '2024-12-05 23:00:00', 180.00, 'completed'),
(6, 6, 2, 1, '2024-12-06 12:45:00', '2024-12-06 13:30:00', 253.13, 'completed'),
(7, 7, 1, NULL, '2024-12-07 16:20:00', NULL, NULL, 'active'),
(8, 8, 3, 4, '2024-12-08 11:10:00', '2024-12-08 12:10:00', 540.00, 'completed'),
(9, 9, 2, NULL, '2024-12-09 15:45:00', '2024-12-09 16:15:00', 172.50, 'completed'),
(10, 10, 1, 5, '2024-12-10 19:00:00', '2024-12-10 19:30:00', 105.00, 'completed');

----- платежи
INSERT INTO Payment (rental_id, amount, payment_method, payment_date) VALUES
(1, 150.00, 'card', '2024-12-01 11:05:00'),
(2, 337.50, 'phone', '2024-12-02 15:05:00'),
(3, 562.50, 'card', '2024-12-03 09:50:00'),
(5, 180.00, 'cash', '2024-12-05 23:05:00'),
(6, 253.13, 'card', '2024-12-06 13:35:00'),
(8, 540.00, 'phone', '2024-12-08 12:15:00'),
(9, 172.50, 'card', '2024-12-09 16:20:00'),
(10, 105.00, 'phone', '2024-12-10 19:35:00');

--- использование промокодов
INSERT INTO PromoUsage (user_id, promo_id, usage_date, rental_id) VALUES
(1, 1, '2024-12-01 10:28:00', 1),
(3, 2, '2024-12-03 08:55:00', 3),
(5, 3, '2024-12-05 21:58:00', 5),
(6, 1, '2024-12-06 12:42:00', 6),
(8, 4, '2024-12-08 11:05:00', 8),
(10, 5, '2024-12-10 18:57:00', 10);

-- Все промокоды у которых expire_date в текущем или следующем месяце
SELECT 
    promo_id,
    code,
    discount_percent,
    expire_date,
    current_uses,
    max_uses
FROM Promocode
WHERE 
    EXTRACT(YEAR FROM expire_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    AND EXTRACT(MONTH FROM expire_date) IN (
        EXTRACT(MONTH FROM CURRENT_DATE),
        EXTRACT(MONTH FROM CURRENT_DATE + INTERVAL '1 month')
    )
ORDER BY expire_date;

-- Выбрать всех пользователей сумма всех поездок
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.phone,
    COUNT(r.rental_id),
    COALESCE(SUM(r.cost), 0),
    COALESCE(ROUND(AVG(r.cost), 2), 0)
FROM Useer u
LEFT JOIN Rental r ON u.user_id = r.user_id 
    AND r.status = 'completed'
GROUP BY u.user_id, u.first_name, u.last_name, u.phone
ORDER BY COALESCE(SUM(r.cost), 0) DESC;

-- Выбрать самый популярный тариф который чаще используют
SELECT 
    t.tariff_id,
    t.name,
    t.cost_per_minute,
    COUNT(r.rental_id),
    COUNT(DISTINCT r.user_id)
FROM Tariff t
LEFT JOIN Rental r ON t.tariff_id = r.tariff_id 
    AND r.status = 'completed'
WHERE t.is_active = true
GROUP BY t.tariff_id, t.name, t.cost_per_minute
ORDER BY COUNT(r.rental_id) DESC
LIMIT 1;

--top 5 пользователей которые используют промокоды
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(pu.usage_id) as promos_used
FROM Useer u
JOIN PromoUsage pu ON u.user_id = pu.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY COUNT(pu.usage_id) DESC
LIMIT 5;
