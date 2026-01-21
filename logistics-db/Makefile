# ═══════════════════════════════════════════════════════════════
# Makefile для управления Docker окружением
# ═══════════════════════════════════════════════════════════════

.PHONY: help build up down restart logs clean backup restore

help: ## Показать справку
	@echo "Доступные команды:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Собрать Docker образ
	docker-compose build

up: ## Запустить контейнеры
	docker-compose up -d
	@echo "✅ Контейнеры запущены!"
	@echo "📊 PostgreSQL: localhost:5432"
	@echo "🌐 pgAdmin: http://localhost:5050"

down: ## Остановить контейнеры
	docker-compose down

restart: ## Перезапустить контейнеры
	docker-compose restart

logs: ## Показать логи PostgreSQL
	docker-compose logs -f postgres

logs-all: ## Показать логи всех контейнеров
	docker-compose logs -f

clean: ## Удалить контейнеры и volumes
	docker-compose down -v
	@echo "⚠️  Все данные удалены!"

status: ## Статус контейнеров
	docker-compose ps

shell: ## Войти в PostgreSQL контейнер
	docker exec -it logistics_postgres bash

psql: ## Подключиться к БД через psql
	docker exec -it logistics_postgres psql -U logistics_admin -d logistics_5nf

backup: ## Создать резервную копию БД
	@mkdir -p ./backups
	docker exec logistics_postgres pg_dump -U logistics_admin logistics_5nf > ./backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "✅ Бэкап создан в ./backups/"

restore: ## Восстановить БД из последнего бэкапа
	@LATEST=$$(ls -t ./backups/*.sql | head -1); \
	echo "Восстановление из: $$LATEST"; \
	docker exec -i logistics_postgres psql -U logistics_admin logistics_5nf < $$LATEST

init: ## Первичная инициализация (build + up)
	@echo "🚀 Инициализация окружения..."
	make build
	make up
	@echo "⏳ Ждём готовности PostgreSQL (60 сек)..."
	sleep 60
	@echo "✅ Готово! Проверяем БД..."
	make check

check: ## Проверить состояние БД
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;"
	@echo ""
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT COUNT(*) as tables_count FROM pg_tables WHERE schemaname = 'public';"
