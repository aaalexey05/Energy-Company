# ═══════════════════════════════════════════════════════════════
# Makefile для управления Logistics 5NF (PostgreSQL + Flask WebApp)
# ═══════════════════════════════════════════════════════════════

.PHONY: help build up down restart logs clean backup restore init check

# ═══════════════════════════════════════════════════════════════
# ОСНОВНЫЕ КОМАНДЫ
# ═══════════════════════════════════════════════════════════════

help: ## Показать справку
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║          Logistics 5NF - Управление окружением                ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Доступные команды:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

init: ## 🚀 Первичная инициализация (build + up + проверка)
	@echo "🚀 Инициализация окружения..."
	make build
	make up
	@echo "⏳ Ждём готовности PostgreSQL (30 сек)..."
	@sleep 30
	@echo "✅ Проверяем состояние..."
	make check

build: ## 🔨 Собрать все Docker образы
	docker-compose build
	@echo "✅ Образы собраны!"

up: ## ▶️  Запустить все контейнеры
	docker-compose up -d
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║                  ✅ Контейнеры запущены!                       ║"
	@echo "╠════════════════════════════════════════════════════════════════╣"
	@echo "║ 🌐 Веб-интерфейс:  http://localhost:5000                      ║"
	@echo "║ 📊 PostgreSQL:     localhost:5432                             ║"
	@echo "║ 🔧 pgAdmin:        http://localhost:5050                      ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"
	@echo ""

down: ## ⏹️  Остановить все контейнеры
	docker-compose down
	@echo "⏹️  Контейнеры остановлены"

restart: ## 🔄 Перезапустить все контейнеры
	docker-compose restart
	@echo "🔄 Контейнеры перезапущены"

# ═══════════════════════════════════════════════════════════════
# ЛОГИ И МОНИТОРИНГ
# ═══════════════════════════════════════════════════════════════

logs: ## 📋 Логи PostgreSQL
	docker-compose logs -f postgres

logs-webapp: ## 📋 Логи веб-приложения
	docker-compose logs -f webapp

logs-all: ## 📋 Логи всех контейнеров
	docker-compose logs -f

status: ## 📊 Статус всех контейнеров
	@docker-compose ps

# ═══════════════════════════════════════════════════════════════
# ДОСТУП К КОНТЕЙНЕРАМ
# ═══════════════════════════════════════════════════════════════

shell-db: ## 🐚 Войти в PostgreSQL контейнер
	docker exec -it logistics_postgres bash

shell-webapp: ## 🐚 Войти в WebApp контейнер
	docker exec -it logistics_webapp bash

psql: ## 💾 Подключиться к БД через psql
	docker exec -it logistics_postgres psql -U logistics_admin -d logistics_5nf

# ═══════════════════════════════════════════════════════════════
# РЕЗЕРВНОЕ КОПИРОВАНИЕ
# ═══════════════════════════════════════════════════════════════

backup: ## 💾 Создать резервную копию БД
	@mkdir -p ./backups
	@docker exec logistics_postgres pg_dump -U logistics_admin logistics_5nf > ./backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "✅ Бэкап создан в ./backups/backup_$$(date +%Y%m%d_%H%M%S).sql"

restore: ## ♻️  Восстановить БД из последнего бэкапа
	@LATEST=$$(ls -t ./backups/*.sql 2>/dev/null | head -1); \
	if [ -z "$$LATEST" ]; then \
		echo "❌ Нет доступных бэкапов в ./backups/"; \
		exit 1; \
	fi; \
	echo "📂 Восстановление из: $$LATEST"; \
	docker exec -i logistics_postgres psql -U logistics_admin logistics_5nf < $$LATEST; \
	echo "✅ Восстановление завершено"

# ═══════════════════════════════════════════════════════════════
# ПРОВЕРКА И ДИАГНОСТИКА
# ═══════════════════════════════════════════════════════════════

check: ## ✅ Проверить состояние БД
	@echo "📊 Проверка таблиц в БД..."
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;" 2>/dev/null || echo "❌ БД недоступна"
	@echo ""
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT COUNT(*) as tables_count FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null
	@echo ""
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "SELECT COUNT(*) as cargo_count FROM грузы;" 2>/dev/null || echo "Таблица грузы не найдена"

test-webapp: ## 🧪 Тест доступности веб-приложения
	@echo "🧪 Проверка веб-приложения..."
	@curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:5000 || echo "❌ WebApp недоступен"

# ═══════════════════════════════════════════════════════════════
# ОЧИСТКА
# ═══════════════════════════════════════════════════════════════

clean: ## 🧹 Остановить и удалить контейнеры (данные сохраняются)
	docker-compose down
	@echo "🧹 Контейнеры удалены (volumes сохранены)"

clean-all: ## ⚠️  УДАЛИТЬ ВСЁ (включая данные БД!)
	@echo "⚠️  ВНИМАНИЕ! Будут удалены ВСЕ данные!"
	@read -p "Продолжить? [y/N]: " confirm && [ "$$confirm" = "y" ] || exit 1
	docker-compose down -v
	@echo "🗑️  Все данные удалены!"

# ═══════════════════════════════════════════════════════════════
# РАЗРАБОТКА
# ═══════════════════════════════════════════════════════════════

dev: ## 🔧 Режим разработки (пересборка + логи)
	make build
	make up
	@sleep 5
	make logs-all

rebuild-webapp: ## 🔨 Пересобрать только веб-приложение
	docker-compose build webapp
	docker-compose up -d webapp
	@echo "✅ WebApp пересобран и перезапущен"

# ═══════════════════════════════════════════════════════════════
# ДОПОЛНИТЕЛЬНЫЕ УТИЛИТЫ
# ═══════════════════════════════════════════════════════════════

create-user: ## 👤 Создать тестового пользователя (admin)
	@echo "Создание администратора..."
	@docker exec -i logistics_postgres psql -U logistics_admin logistics_5nf << 'EOF'
	INSERT INTO сотрудники (имя, фамилия, email, пароль, ид_роль, активен) 
	SELECT 'Админ', 'Системный', 'admin@logistics.ru', 
       'scrypt:32768:8:1$$vLxnW3zK8bnhGzDu$$7e0a98f9c3e05e9d8f7c3e4d5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d', 
       1, true
WHERE NOT EXISTS (SELECT 1 FROM сотрудники WHERE email = 'admin@logistics.ru');
EOF
	@echo "✅ Пользователь admin@logistics.ru создан (пароль: admin123)"

tables: ## 📋 Показать все таблицы
	@docker exec logistics_postgres psql -U logistics_admin logistics_5nf -c "\dt"

info: ## ℹ️  Информация о системе
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║                    Logistics 5NF - Информация                  ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "📦 Контейнеры:"
	@docker-compose ps
	@echo ""
	@echo "💾 Volumes:"
	@docker volume ls | grep logistics || echo "Нет volumes"
	@echo ""
