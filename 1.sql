---- таблица пользователей
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

---- таблица тарифов
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

---- таблица использования промокодов
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
