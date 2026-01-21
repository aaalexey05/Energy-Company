-- ═══════════════════════════════════════════════════════════════════════════════
-- ПОЛНЫЙ SQL СКРИПТ СОЗДАНИЯ БАЗЫ ДАННЫХ
-- Система Управления Логистикой (5NF)
-- PostgreSQL 16+
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 1: СОЗДАНИЕ БАЗЫ ДАННЫХ
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE DATABASE logistics_5nf
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.UTF-8'
    LC_CTYPE = 'ru_RU.UTF-8'
    TEMPLATE = template0;

-- Подключаемся к созданной БД
\c logistics_5nf;

-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 2: УРОВЕНЬ 1 - СПРАВОЧНЫЕ ДАННЫЕ (4 таблицы)
-- ═══════════════════════════════════════════════════════════════════════════════

-- 1. ТИПЫ СРЕДСТВ ДОСТАВКИ
CREATE TABLE типы_средств_доставки (
    ид_тип_средства SERIAL PRIMARY KEY,
    наименование VARCHAR(100) NOT NULL UNIQUE,
    грузоподъемность_кг DECIMAL(10,2),
    объем_куб_м DECIMAL(10,2),
    топливо_тип VARCHAR(50),
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE типы_средств_доставки IS 'Справочник типов транспортных средств';
COMMENT ON COLUMN типы_средств_доставки.грузоподъемность_кг IS 'Максимальная грузоподъемность в кг';
COMMENT ON COLUMN типы_средств_доставки.объем_куб_м IS 'Объем кузова в кубических метрах';

-- Индексы для типы_средств_доставки
CREATE INDEX idx_типы_наименование ON типы_средств_доставки(наименование);


-- 2. ГОРОДА
CREATE TABLE города (
    ид_город SERIAL PRIMARY KEY,
    название VARCHAR(100) NOT NULL UNIQUE,
    регион VARCHAR(100),
    координаты_широта DECIMAL(10,8),
    координаты_долгота DECIMAL(10,8),
    население INTEGER,
    часовой_пояс VARCHAR(10)
);

COMMENT ON TABLE города IS 'Справочник городов присутствия компании';

-- Индексы для города
CREATE INDEX idx_города_название ON города(название);
CREATE INDEX idx_города_регион ON города(регион);


-- 3. КЛИЕНТЫ
CREATE TABLE клиенты (
    ид_клиент SERIAL PRIMARY KEY,
    название VARCHAR(200) NOT NULL UNIQUE,
    тип_клиента VARCHAR(50),
    контактный_телефон VARCHAR(20),
    электронная_почта VARCHAR(100),
    адрес_регистрации TEXT,
    инн VARCHAR(12),
    кпп VARCHAR(9),
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    статус VARCHAR(20) DEFAULT 'активный'
);

COMMENT ON TABLE клиенты IS 'Клиенты компании (юридические и физические лица)';

-- Индексы для клиенты
CREATE INDEX idx_клиенты_название ON клиенты(название);
CREATE INDEX idx_клиенты_телефон ON клиенты(контактный_телефон);
CREATE INDEX idx_клиенты_статус ON клиенты(статус);
CREATE INDEX idx_клиенты_инн ON клиенты(инн);
CREATE INDEX idx_клиенты_email ON клиенты(электронная_почта);


-- 4. СТАТУСЫ ЗАКАЗОВ
CREATE TABLE статусы_заказов (
    ид_статус SERIAL PRIMARY KEY,
    код_статуса VARCHAR(50) NOT NULL UNIQUE,
    наименование VARCHAR(100) NOT NULL,
    описание TEXT,
    цвет_индикатора VARCHAR(7),
    порядок_сортировки INTEGER
);

COMMENT ON TABLE статусы_заказов IS 'Справочник статусов жизненного цикла груза';

-- Индексы для статусы_заказов
CREATE INDEX idx_статусы_код ON статусы_заказов(код_статуса);
CREATE INDEX idx_статусы_порядок ON статусы_заказов(порядок_сортировки);

-- Заполняем базовые статусы
INSERT INTO статусы_заказов (код_статуса, наименование, цвет_индикатора, порядок_сортировки, описание) VALUES
('новый', 'Новый заказ', '#3498db', 1, 'Груз только что создан в системе'),
('принят', 'Принят в работу', '#f39c12', 2, 'Груз принят диспетчером'),
('на_складе', 'На складе отправления', '#9b59b6', 3, 'Груз находится на складе отправки'),
('в_пути', 'В пути', '#e67e22', 4, 'Груз в процессе транспортировки'),
('на_складе_назначения', 'На складе назначения', '#1abc9c', 5, 'Груз прибыл на склад назначения'),
('доставлен', 'Доставлен', '#27ae60', 6, 'Груз успешно доставлен получателю'),
('отменен', 'Отменен', '#e74c3c', 7, 'Доставка отменена');


-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 3: УРОВЕНЬ 2 - ДИРЕКТОРИИ (2 таблицы)
-- ═══════════════════════════════════════════════════════════════════════════════

-- 5. ВОДИТЕЛИ
CREATE TABLE водители (
    ид_водитель SERIAL PRIMARY KEY,
    фамилия VARCHAR(50) NOT NULL,
    имя VARCHAR(50) NOT NULL,
    отчество VARCHAR(50),
    номер_прав VARCHAR(20) NOT NULL UNIQUE,
    категория_прав VARCHAR(10),
    дата_рождения DATE,
    телефон VARCHAR(20),
    адрес_проживания TEXT,
    дата_найма DATE NOT NULL,
    статус VARCHAR(20) DEFAULT 'активный',
    стаж_лет INTEGER,
    рейтинг DECIMAL(3,2),

    CONSTRAINT chk_рейтинг CHECK (рейтинг >= 0 AND рейтинг <= 5),
    CONSTRAINT chk_стаж CHECK (стаж_лет >= 0)
);

COMMENT ON TABLE водители IS 'Персонал компании - водители транспортных средств';

-- Индексы для водители
CREATE INDEX idx_водители_прав ON водители(номер_прав);
CREATE INDEX idx_водители_фио ON водители(фамилия, имя);
CREATE INDEX idx_водители_статус ON водители(статус);
CREATE INDEX idx_водители_телефон ON водители(телефон);


-- 6. СКЛАДЫ
CREATE TABLE склады (
    ид_склад SERIAL PRIMARY KEY,
    название VARCHAR(150) NOT NULL UNIQUE,
    ид_город INTEGER NOT NULL,
    адрес_полный TEXT,
    площадь_кв_м DECIMAL(12,2),
    координаты_широта DECIMAL(10,8),
    координаты_долгота DECIMAL(10,8),
    телефон VARCHAR(20),
    руководитель_фио VARCHAR(100),
    дата_открытия DATE,
    вместимость_куб_м DECIMAL(12,2),
    статус VARCHAR(20) DEFAULT 'работает',

    CONSTRAINT fk_склады_город FOREIGN KEY (ид_город) 
        REFERENCES города(ид_город) ON DELETE RESTRICT
);

COMMENT ON TABLE склады IS 'Складские помещения компании';

-- Индексы для склады
CREATE INDEX idx_склады_название ON склады(название);
CREATE INDEX idx_склады_город ON склады(ид_город);
CREATE INDEX idx_склады_статус ON склады(статус);


-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 4: УРОВЕНЬ 3 - ОСНОВНЫЕ СУЩНОСТИ (5 таблиц)
-- ═══════════════════════════════════════════════════════════════════════════════

-- 7. МАРШРУТЫ
CREATE TABLE маршруты (
    ид_маршрут SERIAL PRIMARY KEY,
    код_маршрута VARCHAR(50) NOT NULL UNIQUE,
    наименование VARCHAR(100) NOT NULL UNIQUE,
    описание TEXT,
    общее_расстояние_км DECIMAL(10,2) NOT NULL,
    ожидаемое_время_часов DECIMAL(8,2),
    статус VARCHAR(20) DEFAULT 'активный',
    тип_маршрута VARCHAR(50),
    дата_создания DATE DEFAULT CURRENT_DATE,
    стоимость_за_км_руб DECIMAL(10,2),
    приоритет INTEGER DEFAULT 0,

    CONSTRAINT chk_расстояние CHECK (общее_расстояние_км > 0),
    CONSTRAINT chk_время CHECK (ожидаемое_время_часов > 0)
);

COMMENT ON TABLE маршруты IS 'Маршруты доставки между городами';

-- Индексы для маршруты
CREATE INDEX idx_маршруты_код ON маршруты(код_маршрута);
CREATE INDEX idx_маршруты_наименование ON маршруты(наименование);
CREATE INDEX idx_маршруты_статус ON маршруты(статус);
CREATE INDEX idx_маршруты_тип ON маршруты(тип_маршрута);


-- 8. ОСТАНОВКИ МАРШРУТА
CREATE TABLE остановки_маршрута (
    ид_остановка SERIAL PRIMARY KEY,
    ид_маршрут INTEGER NOT NULL,
    порядковый_номер INTEGER NOT NULL,
    ид_город INTEGER NOT NULL,
    расстояние_от_предыдущей_км DECIMAL(10,2),
    ожидаемое_время_прибытия_часов DECIMAL(8,2),
    ожидаемое_время_отправки_часов DECIMAL(8,2),
    время_простоя_минут INTEGER DEFAULT 30,
    тип_остановки VARCHAR(50),
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_остановки_маршрут FOREIGN KEY (ид_маршрут) 
        REFERENCES маршруты(ид_маршрут) ON DELETE CASCADE,
    CONSTRAINT fk_остановки_город FOREIGN KEY (ид_город) 
        REFERENCES города(ид_город) ON DELETE RESTRICT,
    CONSTRAINT chk_порядковый_номер CHECK (порядковый_номер > 0),
    CONSTRAINT chk_расст_остановки CHECK (расстояние_от_предыдущей_км >= 0),
    CONSTRAINT uk_маршрут_порядок UNIQUE (ид_маршрут, порядковый_номер)
);

COMMENT ON TABLE остановки_маршрута IS 'Промежуточные и конечные точки маршрутов';

-- Индексы для остановки_маршрута
CREATE INDEX idx_остановки_маршрут ON остановки_маршрута(ид_маршрут);
CREATE INDEX idx_остановки_город ON остановки_маршрута(ид_город);
CREATE INDEX idx_остановки_порядковый ON остановки_маршрута(порядковый_номер);


-- 9. ТРАНСПОРТНЫЕ СРЕДСТВА
CREATE TABLE транспортные_средства (
    ид_средство SERIAL PRIMARY KEY,
    госномер VARCHAR(20) NOT NULL UNIQUE,
    ид_тип_средства INTEGER NOT NULL,
    ид_водитель INTEGER,
    год_выпуска INTEGER,
    марка VARCHAR(50),
    модель VARCHAR(50),
    цвет VARCHAR(30),
    состояние VARCHAR(20) DEFAULT 'исправен',
    дата_последнего_то DATE,
    статус VARCHAR(20) DEFAULT 'свободно',
    дата_регистрации DATE DEFAULT CURRENT_DATE,
    страховка_до DATE,
    пробег_км INTEGER DEFAULT 0,
    расход_топлива_л_100км DECIMAL(5,2),
    стоимость_руб DECIMAL(12,2),

    CONSTRAINT fk_тс_тип FOREIGN KEY (ид_тип_средства) 
        REFERENCES типы_средств_доставки(ид_тип_средства) ON DELETE RESTRICT,
    CONSTRAINT fk_тс_водитель FOREIGN KEY (ид_водитель) 
        REFERENCES водители(ид_водитель) ON DELETE SET NULL,
    CONSTRAINT chk_год CHECK (год_выпуска >= 1900 AND год_выпуска <= EXTRACT(YEAR FROM CURRENT_DATE)),
    CONSTRAINT chk_пробег CHECK (пробег_км >= 0)
);

COMMENT ON TABLE транспортные_средства IS 'Автопарк транспортной компании';

-- Индексы для транспортные_средства
CREATE INDEX idx_тс_госномер ON транспортные_средства(госномер);
CREATE INDEX idx_тс_статус ON транспортные_средства(статус);
CREATE INDEX idx_тс_водитель ON транспортные_средства(ид_водитель);
CREATE INDEX idx_тс_тип ON транспортные_средства(ид_тип_средства);
CREATE INDEX idx_тс_состояние ON транспортные_средства(состояние);


-- 10. ГРУЗЫ (ЦЕНТРАЛЬНАЯ ТАБЛИЦА)
CREATE TABLE грузы (
    ид_груз SERIAL PRIMARY KEY,
    номер_груза VARCHAR(50) NOT NULL UNIQUE,
    описание TEXT,
    вес_кг DECIMAL(12,2) NOT NULL,
    объем_куб_м DECIMAL(12,2),
    ид_клиент INTEGER NOT NULL,
    ид_склад_откуда INTEGER NOT NULL,
    ид_склад_куда INTEGER NOT NULL,
    ид_статус INTEGER DEFAULT 1,
    стоимость_руб DECIMAL(12,2),
    стоимость_доставки_руб DECIMAL(12,2),
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    дата_должна_прибыть DATE,
    дата_фактическая_доставка TIMESTAMP,
    примечание TEXT,
    страховка_руб DECIMAL(12,2),
    хрупкий BOOLEAN DEFAULT FALSE,
    температурный_режим VARCHAR(50),

    CONSTRAINT fk_грузы_клиент FOREIGN KEY (ид_клиент) 
        REFERENCES клиенты(ид_клиент) ON DELETE RESTRICT,
    CONSTRAINT fk_грузы_склад_откуда FOREIGN KEY (ид_склад_откуда) 
        REFERENCES склады(ид_склад) ON DELETE RESTRICT,
    CONSTRAINT fk_грузы_склад_куда FOREIGN KEY (ид_склад_куда) 
        REFERENCES склады(ид_склад) ON DELETE RESTRICT,
    CONSTRAINT fk_грузы_статус FOREIGN KEY (ид_статус) 
        REFERENCES статусы_заказов(ид_статус) ON DELETE RESTRICT,
    CONSTRAINT chk_вес CHECK (вес_кг > 0),
    CONSTRAINT chk_стоимость CHECK (стоимость_руб >= 0),
    CONSTRAINT chk_склады_разные CHECK (ид_склад_откуда <> ид_склад_куда)
);

COMMENT ON TABLE грузы IS 'Основная таблица грузов компании';

-- Индексы для грузы (МНОЖЕСТВЕННЫЕ - для быстрого поиска)
CREATE INDEX idx_грузы_номер ON грузы(номер_груза);
CREATE INDEX idx_грузы_статус ON грузы(ид_статус);
CREATE INDEX idx_грузы_клиент ON грузы(ид_клиент);
CREATE INDEX idx_грузы_дата_создания ON грузы(дата_создания);
CREATE INDEX idx_грузы_дата_доставки ON грузы(дата_должна_прибыть);
CREATE INDEX idx_грузы_склад_откуда ON грузы(ид_склад_откуда);
CREATE INDEX idx_грузы_склад_куда ON грузы(ид_склад_куда);
CREATE INDEX idx_грузы_комбо_статус_дата ON грузы(ид_статус, дата_создания);
CREATE INDEX idx_грузы_хрупкий ON грузы(хрупкий) WHERE хрупкий = TRUE;


-- 11. ПЛАТЕЖИ
CREATE TABLE платежи (
    ид_платеж SERIAL PRIMARY KEY,
    номер_платежа VARCHAR(50) NOT NULL UNIQUE,
    ид_клиент INTEGER NOT NULL,
    ид_груз INTEGER,
    сумма_руб DECIMAL(12,2) NOT NULL,
    тип_платежа VARCHAR(50),
    статус_платежа VARCHAR(50) DEFAULT 'ожидает',
    дата_создания TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    дата_оплаты TIMESTAMP,
    способ_оплаты VARCHAR(50),
    примечание TEXT,

    CONSTRAINT fk_платежи_клиент FOREIGN KEY (ид_клиент) 
        REFERENCES клиенты(ид_клиент) ON DELETE RESTRICT,
    CONSTRAINT fk_платежи_груз FOREIGN KEY (ид_груз) 
        REFERENCES грузы(ид_груз) ON DELETE SET NULL,
    CONSTRAINT chk_сумма CHECK (сумма_руб > 0)
);

COMMENT ON TABLE платежи IS 'Финансовые операции по доставкам';

-- Индексы для платежи
CREATE INDEX idx_платежи_номер ON платежи(номер_платежа);
CREATE INDEX idx_платежи_клиент ON платежи(ид_клиент);
CREATE INDEX idx_платежи_груз ON платежи(ид_груз);
CREATE INDEX idx_платежи_статус ON платежи(статус_платежа);
CREATE INDEX idx_платежи_дата ON платежи(дата_оплаты);
CREATE INDEX idx_платежи_дата_создания ON платежи(дата_создания);


-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 5: УРОВЕНЬ 4 - 5NF СВЯЗИ (3 таблицы) - ДЕКОМПОЗИЦИЯ M:N:K
-- ═══════════════════════════════════════════════════════════════════════════════

-- 12. ГРУЗ_И_СРЕДСТВА (5NF: ГРУЗ ↔ ТРАНСПОРТ)
CREATE TABLE груз_и_средства (
    ид_груз_средство SERIAL PRIMARY KEY,
    ид_груз INTEGER NOT NULL,
    ид_средство INTEGER NOT NULL,
    последовательность INTEGER DEFAULT 1,
    статус VARCHAR(20) DEFAULT 'зарезервировано',
    дата_начала TIMESTAMP,
    дата_окончания TIMESTAMP,
    пройдено_км DECIMAL(10,2),
    время_в_пути_часов DECIMAL(8,2),
    стоимость_доставки_руб DECIMAL(12,2),
    примечание TEXT,
    расход_топлива_л DECIMAL(10,2),

    CONSTRAINT fk_гс_груз FOREIGN KEY (ид_груз) 
        REFERENCES грузы(ид_груз) ON DELETE CASCADE,
    CONSTRAINT fk_гс_средство FOREIGN KEY (ид_средство) 
        REFERENCES транспортные_средства(ид_средство) ON DELETE RESTRICT,
    CONSTRAINT chk_последовательность CHECK (последовательность > 0),
    CONSTRAINT chk_пройдено CHECK (пройдено_км >= 0),
    CONSTRAINT uk_груз_средство UNIQUE (ид_груз, ид_средство)
);

COMMENT ON TABLE груз_и_средства IS '5NF: Связь ГРУЗ ↔ ТРАНСПОРТНОЕ_СРЕДСТВО';

-- Индексы для груз_и_средства (КРИТИЧНЫЕ для 5NF!)
CREATE INDEX idx_гс_груз ON груз_и_средства(ид_груз);
CREATE INDEX idx_гс_средство ON груз_и_средства(ид_средство);
CREATE INDEX idx_гс_статус ON груз_и_средства(статус);
CREATE INDEX idx_гс_дата_начала ON груз_и_средства(дата_начала);
CREATE INDEX idx_гс_комбо ON груз_и_средства(ид_груз, ид_средство, статус);


-- 13. ГРУЗ_И_МАРШРУТЫ (5NF: ГРУЗ ↔ МАРШРУТ)
CREATE TABLE груз_и_маршруты (
    ид_груз_маршрут SERIAL PRIMARY KEY,
    ид_груз INTEGER NOT NULL,
    ид_маршрут INTEGER NOT NULL,
    последовательность INTEGER DEFAULT 1,
    статус VARCHAR(20) DEFAULT 'планируется',
    дата_начала_маршрута TIMESTAMP,
    дата_окончания_маршрута TIMESTAMP,
    остановка_начало INTEGER,
    остановка_конец INTEGER,
    расстояние_по_маршруту_км DECIMAL(10,2),
    примечание TEXT,

    CONSTRAINT fk_гм_груз FOREIGN KEY (ид_груз) 
        REFERENCES грузы(ид_груз) ON DELETE CASCADE,
    CONSTRAINT fk_гм_маршрут FOREIGN KEY (ид_маршрут) 
        REFERENCES маршруты(ид_маршрут) ON DELETE RESTRICT,
    CONSTRAINT fk_гм_остановка_начало FOREIGN KEY (остановка_начало) 
        REFERENCES остановки_маршрута(ид_остановка) ON DELETE SET NULL,
    CONSTRAINT fk_гм_остановка_конец FOREIGN KEY (остановка_конец) 
        REFERENCES остановки_маршрута(ид_остановка) ON DELETE SET NULL,
    CONSTRAINT chk_гм_последовательность CHECK (последовательность > 0),
    CONSTRAINT uk_груз_маршрут UNIQUE (ид_груз, ид_маршрут)
);

COMMENT ON TABLE груз_и_маршруты IS '5NF: Связь ГРУЗ ↔ МАРШРУТ';

-- Индексы для груз_и_маршруты (КРИТИЧНЫЕ для 5NF!)
CREATE INDEX idx_гм_груз ON груз_и_маршруты(ид_груз);
CREATE INDEX idx_гм_маршрут ON груз_и_маршруты(ид_маршрут);
CREATE INDEX idx_гм_статус ON груз_и_маршруты(статус);
CREATE INDEX idx_гм_дата_начала ON груз_и_маршруты(дата_начала_маршрута);


-- 14. СРЕДСТВО_И_МАРШРУТЫ (5NF: ТРАНСПОРТ ↔ МАРШРУТ)
CREATE TABLE средство_и_маршруты (
    ид_средство_маршрут SERIAL PRIMARY KEY,
    ид_средство INTEGER NOT NULL,
    ид_маршрут INTEGER NOT NULL,
    приоритет INTEGER DEFAULT 0,
    статус VARCHAR(20) DEFAULT 'активный',
    дата_начала_обслуживания DATE,
    дата_конца_обслуживания DATE,
    количество_рейсов INTEGER DEFAULT 0,
    средняя_скорость_км_ч DECIMAL(6,2),
    общий_пробег_км DECIMAL(12,2),

    CONSTRAINT fk_см_средство FOREIGN KEY (ид_средство) 
        REFERENCES транспортные_средства(ид_средство) ON DELETE RESTRICT,
    CONSTRAINT fk_см_маршрут FOREIGN KEY (ид_маршрут) 
        REFERENCES маршруты(ид_маршрут) ON DELETE RESTRICT,
    CONSTRAINT chk_рейсов CHECK (количество_рейсов >= 0),
    CONSTRAINT uk_средство_маршрут UNIQUE (ид_средство, ид_маршрут)
);

COMMENT ON TABLE средство_и_маршруты IS '5NF: Связь ТРАНСПОРТНОЕ_СРЕДСТВО ↔ МАРШРУТ';

-- Индексы для средство_и_маршруты (КРИТИЧНЫЕ для 5NF!)
CREATE INDEX idx_см_средство ON средство_и_маршруты(ид_средство);
CREATE INDEX idx_см_маршрут ON средство_и_маршруты(ид_маршрут);
CREATE INDEX idx_см_статус ON средство_и_маршруты(статус);
CREATE INDEX idx_см_приоритет ON средство_и_маршруты(приоритет);


-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 6: УРОВЕНЬ 5 - ДОПОЛНИТЕЛЬНЫЕ ТАБЛИЦЫ (3 таблицы)
-- ═══════════════════════════════════════════════════════════════════════════════

-- 15. ИСТОРИЯ СТАТУСОВ
CREATE TABLE история_статусов (
    ид_история SERIAL PRIMARY KEY,
    ид_груз INTEGER NOT NULL,
    ид_статус_старый INTEGER,
    ид_статус_новый INTEGER NOT NULL,
    дата_изменения TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    комментарий TEXT,
    ид_пользователь VARCHAR(100),

    CONSTRAINT fk_история_груз FOREIGN KEY (ид_груз) 
        REFERENCES грузы(ид_груз) ON DELETE CASCADE,
    CONSTRAINT fk_история_статус_старый FOREIGN KEY (ид_статус_старый) 
        REFERENCES статусы_заказов(ид_статус) ON DELETE RESTRICT,
    CONSTRAINT fk_история_статус_новый FOREIGN KEY (ид_статус_новый) 
        REFERENCES статусы_заказов(ид_статус) ON DELETE RESTRICT
);

COMMENT ON TABLE история_статусов IS 'Аудит изменений статусов грузов';

-- Индексы для история_статусов
CREATE INDEX idx_история_груз ON история_статусов(ид_груз);
CREATE INDEX idx_история_дата ON история_статусов(дата_изменения);
CREATE INDEX idx_история_пользователь ON история_статусов(ид_пользователь);


-- 16. РАСХОДЫ ТОПЛИВА
CREATE TABLE расходы_топлива (
    ид_расход SERIAL PRIMARY KEY,
    ид_средство INTEGER NOT NULL,
    дата_заправки TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    объем_л DECIMAL(10,2) NOT NULL,
    стоимость_руб DECIMAL(10,2) NOT NULL,
    тип_топлива VARCHAR(50),
    пробег_на_момент_заправки INTEGER,
    станция_заправки VARCHAR(200),

    CONSTRAINT fk_расходы_средство FOREIGN KEY (ид_средство) 
        REFERENCES транспортные_средства(ид_средство) ON DELETE RESTRICT,
    CONSTRAINT chk_объем CHECK (объем_л > 0),
    CONSTRAINT chk_стоимость_топлива CHECK (стоимость_руб > 0)
);

COMMENT ON TABLE расходы_топлива IS 'Учет расходов на топливо';

-- Индексы для расходы_топлива
CREATE INDEX idx_расходы_средство ON расходы_топлива(ид_средство);
CREATE INDEX idx_расходы_дата ON расходы_топлива(дата_заправки);


-- 17. ТЕХНИЧЕСКОЕ ОБСЛУЖИВАНИЕ
CREATE TABLE техническое_обслуживание (
    ид_то SERIAL PRIMARY KEY,
    ид_средство INTEGER NOT NULL,
    дата_начала TIMESTAMP NOT NULL,
    дата_окончания TIMESTAMP,
    тип_обслуживания VARCHAR(100),
    описание_работ TEXT,
    стоимость_руб DECIMAL(12,2),
    исполнитель VARCHAR(200),
    статус VARCHAR(50) DEFAULT 'запланировано',

    CONSTRAINT fk_то_средство FOREIGN KEY (ид_средство) 
        REFERENCES транспортные_средства(ид_средство) ON DELETE RESTRICT
);

COMMENT ON TABLE техническое_обслуживание IS 'Учет технического обслуживания транспорта';

-- Индексы для техническое_обслуживание
CREATE INDEX idx_то_средство ON техническое_обслуживание(ид_средство);
CREATE INDEX idx_то_дата ON техническое_обслуживание(дата_начала);
CREATE INDEX idx_то_статус ON техническое_обслуживание(статус);


-- ═══════════════════════════════════════════════════════════════════════════════
-- ШАГ 7: СОЗДАНИЕ SEQUENCES ДЛЯ НОМЕРОВ
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE SEQUENCE seq_номер_груза START 1 INCREMENT 1;
CREATE SEQUENCE seq_номер_платежа START 1 INCREMENT 1;


-- ═══════════════════════════════════════════════════════════════════════════════
-- ЗАВЕРШЕНИЕ: СТАТИСТИКА СОЗДАННЫХ ОБЪЕКТОВ
-- ═══════════════════════════════════════════════════════════════════════════════

-- Проверяем созданные таблицы
SELECT 
    schemaname,
    tablename,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = tablename) AS columns_count
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- Проверяем индексы
SELECT 
    schemaname,
    tablename,
    indexname
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Итоговая статистика
SELECT 
    'Таблиц' AS тип_объекта,
    COUNT(*) AS количество
FROM pg_tables 
WHERE schemaname = 'public'
UNION ALL
SELECT 
    'Индексов' AS тип_объекта,
    COUNT(*) AS количество
FROM pg_indexes 
WHERE schemaname = 'public' AND indexname NOT LIKE '%_pkey'
UNION ALL
SELECT 
    'FK связей' AS тип_объекта,
    COUNT(*) AS количество
FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY' AND table_schema = 'public';

-- ═══════════════════════════════════════════════════════════════════════════════
-- ГОТОВО! База данных создана и проиндексирована
-- ═══════════════════════════════════════════════════════════════════════════════
-- СЛЕДУЮЩИЙ ШАГ: Заполнение тестовыми данными
-- ═══════════════════════════════════════════════════════════════════════════════
