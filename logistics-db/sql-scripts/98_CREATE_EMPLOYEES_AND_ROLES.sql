\c logistics_5nf

-- Таблица ролей
CREATE TABLE IF NOT EXISTS роли (
    ид_роль SERIAL PRIMARY KEY,
    название VARCHAR(50) UNIQUE NOT NULL,
    описание TEXT
);

-- Таблица сотрудников
CREATE TABLE IF NOT EXISTS сотрудники (
    ид_сотрудник SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    имя VARCHAR(50) NOT NULL,
    фамилия VARCHAR(50) NOT NULL,
    отчество VARCHAR(50),
    пароль VARCHAR(255) NOT NULL,
    ид_роль INTEGER NOT NULL REFERENCES роли(ид_роль),
    активен BOOLEAN DEFAULT TRUE,
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_сотрудники_email ON сотрудники(email);
CREATE INDEX idx_сотрудники_роль ON сотрудники(ид_роль);

-- Вставка ролей
INSERT INTO роли (название, описание) VALUES
('администратор', 'Полный доступ к системе'),
('менеджер', 'Управление заказами и клиентами'),
('логист', 'Планирование маршрутов'),
('водитель', 'Доставка грузов')
ON CONFLICT (название) DO NOTHING;

-- Вставка тестовых сотрудников (пароль: password123)
INSERT INTO сотрудники (email, имя, фамилия, отчество, пароль, ид_роль) VALUES
('admin@logistics.ru', 'Иван', 'Иванов', 'Иванович', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5Y5zyp4L8W0eK', 1),
('manager@logistics.ru', 'Анна', 'Петрова', 'Сергеевна', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5Y5zyp4L8W0eK', 2),
('logist@logistics.ru', 'Петр', 'Сидоров', 'Алексеевич', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5Y5zyp4L8W0eK', 3)
ON CONFLICT (email) DO NOTHING;

SELECT 
    с.email,
    с.имя || ' ' || с.фамилия as фио,
    р.название as роль,
    с.активен
FROM сотрудники с
JOIN роли р ON с.ид_роль = р.ид_роль;

