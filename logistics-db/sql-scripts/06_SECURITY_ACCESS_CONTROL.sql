-- ═══════════════════════════════════════════════════════════════════════════════
-- ФАЙЛ: 06_SECURITY_ACCESS_CONTROL.sql
-- ТЕМА: Контроль доступа (RBAC) и безопасность данных
-- ═══════════════════════════════════════════════════════════════════════════════

\c logistics_5nf;

-- 1. СБРОС (ДЛЯ ЧИСТОГО ТЕСТА)
-- Удаляем пользователей и роли, если они существуют
DROP USER IF EXISTS user_manager;
DROP USER IF EXISTS user_analyst;
DROP USER IF EXISTS user_dispatcher;
DROP ROLE IF EXISTS role_read_only;
DROP ROLE IF EXISTS role_dispatcher;
DROP ROLE IF EXISTS role_admin;

-- 2. СОЗДАНИЕ РОЛЕЙ (ГРУПП ПРАВ)
-- -----------------------------------------------------------------------------

-- A. Роль "Аналитик" (Только чтение)
CREATE ROLE role_read_only;
GRANT CONNECT ON DATABASE logistics_5nf TO role_read_only;
GRANT USAGE ON SCHEMA public TO role_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_read_only;
-- Автоматически давать права на чтение новых таблиц
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO role_read_only;

-- B. Роль "Диспетчер" (Чтение + Оперативная работа)
CREATE ROLE role_dispatcher;
GRANT CONNECT ON DATABASE logistics_5nf TO role_dispatcher;
GRANT USAGE ON SCHEMA public TO role_dispatcher;
-- Может читать всё
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_dispatcher;
-- Может создавать и менять грузы, маршруты, историю
GRANT INSERT, UPDATE ON грузы, груз_и_средства, история_статусов TO role_dispatcher;
-- Нужен доступ к последовательностям (SERIAL), чтобы делать INSERT
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_dispatcher;

-- C. Роль "Администратор" (Полный доступ)
CREATE ROLE role_admin;
GRANT ALL PRIVILEGES ON DATABASE logistics_5nf TO role_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin;

-- 3. СОЗДАНИЕ ПОЛЬЗОВАТЕЛЕЙ
-- -----------------------------------------------------------------------------

-- Аналитик Анна (только отчеты)
CREATE USER user_analyst WITH PASSWORD 'pass_analyst_2026';
GRANT role_read_only TO user_analyst;

-- Диспетчер Дмитрий (работа с грузами)
CREATE USER user_dispatcher WITH PASSWORD 'pass_dispatcher_2026';
GRANT role_dispatcher TO user_dispatcher;

-- Менеджер Михаил (Админ)
CREATE USER user_manager WITH PASSWORD 'pass_manager_2026';
GRANT role_admin TO user_manager;

-- 4. ПРИМЕР ROW-LEVEL SECURITY (RLS)
-- Ограничение: Диспетчер видит только "свои" записи (пример для таблицы история_статусов)
-- Включаем RLS
ALTER TABLE история_статусов ENABLE ROW LEVEL SECURITY;

-- Создаем политику: "Админы видят всё"
CREATE POLICY admin_see_all ON история_статусов
    FOR ALL
    TO role_admin
    USING (true);

-- Создаем политику: "Остальные видят только то, что создали сами"
-- (Предполагается, что ид_пользователь совпадает с ID пользователя БД, 
-- либо мы используем current_user для текстового сравнения)
CREATE POLICY user_see_own ON история_статусов
    FOR SELECT
    TO role_dispatcher, role_read_only
    USING (true); -- В данном учебном примере разрешаем читать всё, 
                  -- но в реальной системе здесь было бы: using (user_name = current_user)

-- 5. ПРОВЕРКА ПРАВ
SELECT 
    r.rolname, 
    r.rolsuper, 
    r.rolcreaterole,
    ARRAY(SELECT b.rolname FROM pg_auth_members m JOIN pg_roles b ON (m.roleid = b.oid) WHERE m.member = r.oid) as memberof
FROM pg_roles r
WHERE r.rolname IN ('user_analyst', 'user_dispatcher', 'user_manager');
