# 🚀 Развертывание PostgreSQL для Logistics 5NF в Docker

## 📂 Структура проекта

```
logistics-db/
├── docker-compose.yml          # Основная конфигурация Docker
├── Dockerfile                  # Образ PostgreSQL
├── .env                        # Переменные окружения
├── Makefile                    # Команды для управления
├── sql-scripts/                # SQL скрипты
│   └── 01_CREATE_DATABASE_AND_TABLES.sql
├── config/                     # Конфигурация PostgreSQL
│   └── postgresql.conf
├── pgadmin-config/             # Конфигурация pgAdmin
│   └── servers.json
├── backups/                    # Резервные копии (создается автоматически)
└── logs/                       # Логи (создается автоматически)
```

## 🚀 Быстрый старт

### Вариант 1: С Makefile (рекомендуется)

```bash
# 1. Инициализация всего окружения
make init

# Готово! БД создана и проиндексирована
```

### Вариант 2: Вручную

```bash
# 1. Собрать образ
docker-compose build

# 2. Запустить контейнеры
docker-compose up -d

# 3. Проверить статус
docker-compose ps
```

## 🔌 Подключение к БД

### Параметры подключения

```
Host:     localhost
Port:     5432
Database: logistics_5nf
Username: logistics_admin
Password: secure_password_2026
```

### Из командной строки

```bash
# Через docker
make psql

# Или напрямую
psql -h localhost -p 5432 -U logistics_admin -d logistics_5nf
```

### Из Python (FastAPI/SQLAlchemy)

```python
DATABASE_URL = "postgresql://logistics_admin:secure_password_2026@localhost:5432/logistics_5nf"
```

### Из pgAdmin

Открой браузер: http://localhost:5050

```
Email:    admin@logistics.local
Password: admin_password_2026
```

Сервер уже настроен автоматически!

## 📊 Проверка созданной БД

```bash
# Список таблиц
make check

# Или вручную
docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "\dt"

# Количество индексов
docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';"
```

Ожидается:
- ✅ 17 таблиц
- ✅ 58+ индексов
- ✅ 23 Foreign Keys
- ✅ 7 статусов заказов

## 🛠️ Управление

### Основные команды

```bash
make help        # Список всех команд
make up          # Запустить
make down        # Остановить
make restart     # Перезапустить
make logs        # Логи PostgreSQL
make status      # Статус контейнеров
```

### Резервное копирование

```bash
# Создать бэкап
make backup

# Восстановить из последнего бэкапа
make restore
```

### Работа с контейнером

```bash
# Войти в контейнер
make shell

# Подключиться к БД
make psql
```

## 🔧 Настройка производительности

Файл `config/postgresql.conf` уже оптимизирован для:
- 4-8GB RAM
- SSD диски
- До 100 одновременных подключений
- Логирование медленных запросов (>1s)

Настройки можно изменить перед запуском:
```bash
nano config/postgresql.conf
docker-compose restart
```

## 🔐 Безопасность

### Смена паролей

Отредактируй `.env`:
```bash
nano .env
# Измени POSTGRES_PASSWORD и PGADMIN_PASSWORD
docker-compose down
docker-compose up -d
```

### Ограничение доступа

Для продакшена добавь в `docker-compose.yml`:
```yaml
ports:
  - "127.0.0.1:5432:5432"  # Доступ только с localhost
```

## 🧪 Тестирование

```bash
# Проверка подключения
docker exec logistics_postgres pg_isready -U logistics_admin -d logistics_5nf

# Проверка таблиц
make check

# Просмотр логов
make logs
```

## 🐛 Troubleshooting

### Контейнер не запускается

```bash
# Проверить логи
docker-compose logs postgres

# Пересоздать с нуля
make clean
make init
```

### Ошибка "database already exists"

Это нормально при повторном запуске. Скрипт инициализации выполняется только один раз.

### Нехватка памяти

Уменьши параметры в `config/postgresql.conf`:
```
shared_buffers = 1GB
effective_cache_size = 3GB
```

## 📈 Мониторинг

### Размер БД

```bash
docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT pg_size_pretty(pg_database_size('logistics_5nf'));"
```

### Активные подключения

```bash
docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT count(*) FROM pg_stat_activity;"
```

## 🔄 Обновление

```bash
# Создать бэкап
make backup

# Обновить образ
docker-compose pull

# Пересоздать контейнеры
docker-compose up -d --force-recreate
```

## 🗑️ Полная очистка

```bash
# Удалить всё (контейнеры + данные)
make clean

# Удалить и образы
docker-compose down -v --rmi all
```

