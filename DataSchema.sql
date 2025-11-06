-- 1. ТАБЛИЦЯ КОРИСТУВАЧІВ
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(255) NOT NULL UNIQUE,

    -- Перевірка, що e_mail відповідає стандартному формату e-mail
    CONSTRAINT email_check CHECK (
        REGEXP_LIKE(
            user_email,
            '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        )
    )
);

-- 2. ТАБЛИЦЯ ЕКСПЕРТІВ
CREATE TABLE experts (
    expert_id INTEGER PRIMARY KEY,
    expert_name VARCHAR(100) NOT NULL,
    expert_contact VARCHAR(255) NOT NULL UNIQUE,
    expert_status VARCHAR(10) NOT NULL,

    -- Перевірка, що статус може бути лише 'online' або 'offline'
    CONSTRAINT status_check CHECK (
        expert_status IN ('online', 'offline')
    )
);

-- 3. ТАБЛИЦЯ КВАЛІФІКАЦІЙ 
CREATE TABLE qualifications (
    qual_id INTEGER PRIMARY KEY,
    qual_name VARCHAR(100) NOT NULL,
    qual_description VARCHAR(500)
);

-- 4. ТАБЛИЦЯ МАРШРУТІВ
CREATE TABLE routes (
    route_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    route_name VARCHAR(255),
    route_time NUMBER NOT NULL,
    route_distance FLOAT NOT NULL,

    CONSTRAINT fk_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id),
    
    CONSTRAINT time_positive CHECK (route_time > 0),
    CONSTRAINT distance_positive CHECK (route_distance > 0)
);

-- 5. ТАБЛИЦЯ ТОЧОК МАРШРУТУ
CREATE TABLE route_points (
    point_id INTEGER PRIMARY KEY,
    route_id INTEGER NOT NULL,
    point_latitude FLOAT NOT NULL,
    point_longitude FLOAT NOT NULL,

    CONSTRAINT fk_route_points
    FOREIGN KEY (route_id)
    REFERENCES routes (route_id),
    
    CONSTRAINT latitude_positive CHECK (point_latitude > 0),
    CONSTRAINT longitude_positive CHECK (point_longitude > 0)
);

-- 6. ТАБЛИЦЯ ІНДЕКСІВ БЕЗПЕКИ
CREATE TABLE security_indexes (
    index_id INTEGER PRIMARY KEY,
    index_value FLOAT NOT NULL,
    index_status VARCHAR(50),

    -- Обмеження CHECK для діапазону значення індексу (1.0 до 5.0)
    CONSTRAINT index_value_range CHECK (
        index_value >= 1.0
        AND index_value <= 5.0
    )
);

-- 7. ТАБЛИЦЯ СЕАНСІВ КОНСУЛЬТАЦІЙ
CREATE TABLE consultation_sessions (
    session_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    expert_id INTEGER NOT NULL,
    session_date TIMESTAMP,
    duration NUMBER,
    quality_rating NUMBER,

    CONSTRAINT fk_session_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id),
    CONSTRAINT fk_session_expert
    FOREIGN KEY (expert_id)
    REFERENCES experts (expert_id),
    
    CONSTRAINT duration_positive CHECK (duration > 0),
    CONSTRAINT rating_positive CHECK (quality_rating > 0)
);

-- 8. ЗВ'ЯЗКОВА ТАБЛИЦЯ ЕКСПЕРТ-КВАЛІФІКАЦІЯ
CREATE TABLE expert_qualifications (
    expert_id INTEGER NOT NULL,
    qual_id INTEGER NOT NULL,

    CONSTRAINT pk_expert_qual
    PRIMARY KEY (expert_id, qual_id),
    CONSTRAINT fk_eq_expert
    FOREIGN KEY (expert_id)
    REFERENCES experts (expert_id),
    CONSTRAINT fk_eq_qual
    FOREIGN KEY (qual_id)
    REFERENCES qualifications (qual_id)
);

-- 9. ЗВ'ЯЗКОВА ТАБЛИЦЯ МАРШРУТ-БЕЗПЕКА
CREATE TABLE route_security (
    route_id INTEGER NOT NULL,
    index_id INTEGER NOT NULL,

    CONSTRAINT pk_route_security
    PRIMARY KEY (route_id, index_id),
    CONSTRAINT fk_rs_route
    FOREIGN KEY (route_id)
    REFERENCES routes (route_id),
    CONSTRAINT fk_rs_index
    FOREIGN KEY (index_id)
    REFERENCES security_indexes (index_id)
);

-- 10. ТАБЛИЦЯ ЗОВНІШНІХ СЕРВІСІВ
CREATE TABLE external_services (
    service_id INTEGER PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    service_api_url VARCHAR(500) NOT NULL UNIQUE
);
