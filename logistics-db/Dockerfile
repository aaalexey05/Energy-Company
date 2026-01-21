# Dockerfile для PostgreSQL с автоматической инициализацией БД
FROM postgres:16-alpine

# Метаданные
LABEL maintainer="logistics-team"
LABEL description="PostgreSQL 16 для системы управления логистикой (5NF)"
LABEL version="1.0"

# Переменные окружения
ENV POSTGRES_DB=logistics_5nf
ENV POSTGRES_USER=logistics_admin
ENV POSTGRES_PASSWORD=secure_password_2026
ENV PGDATA=/var/lib/postgresql/data/pgdata

# Копируем SQL скрипты инициализации
# Скрипты из /docker-entrypoint-initdb.d/ выполняются автоматически при первом запуске
COPY ./sql-scripts/01_CREATE_DATABASE_AND_TABLES.sql /docker-entrypoint-initdb.d/

# Настройки производительности PostgreSQL
COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf

# Открываем порт
EXPOSE 5432

# Healthcheck для проверки работоспособности
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB || exit 1
