
-- ═══════════════════════════════════════════════════════════════════════════════
-- 08_PERFORMANCE_TESTING.sql (FIXED V3)
-- ═══════════════════════════════════════════════════════════════════════════════
\c logistics_5nf;

-- 1. ГЕНЕРАЦИЯ НАГРУЗКИ
CREATE OR REPLACE FUNCTION generate_load_v3(cnt INT) RETURNS VOID AS $$
DECLARE
    g_ids INT[];
BEGIN
    SELECT ARRAY_AGG(ид_груз) INTO g_ids FROM грузы;
    IF g_ids IS NULL THEN RETURN; END IF;

    FOR i IN 1..cnt LOOP
        INSERT INTO история_статусов(ид_груз, ид_статус_старый, ид_статус_новый, дата_изменения, комментарий)
        VALUES (
            g_ids[1 + floor(random() * array_length(g_ids, 1))::int],
            1, 2, NOW(), 'perf_test'
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT generate_load_v3(1000);

-- 2. ТЕСТ ИНДЕКСА
EXPLAIN ANALYZE SELECT * FROM история_статусов WHERE дата_изменения > NOW() - INTERVAL '1 day';

-- 3. РАЗМЕР ТАБЛИЦ (Исправлено relname)
SELECT relname as table_name, n_live_tup as rows_count 
FROM pg_stat_user_tables 
WHERE schemaname = 'public' 
ORDER BY n_live_tup DESC;
