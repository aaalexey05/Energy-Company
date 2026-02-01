# ═══════════════════════════════════════════════════════════════
# Logistics 5NF - Database Models
# ═══════════════════════════════════════════════════════════════

import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
from config import Config


# ═══════════════════════════════════════════════════════════════
# ПОДКЛЮЧЕНИЕ К БАЗЕ ДАННЫХ
# ═══════════════════════════════════════════════════════════════

@contextmanager
def get_db_connection():
    """Контекстный менеджер для подключения к БД"""
    conn = psycopg2.connect(
        Config.get_db_connection_string(),
        cursor_factory=RealDictCursor
    )
    try:
        yield conn
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()


def get_db_cursor():
    """Получить курсор для работы с БД"""
    conn = psycopg2.connect(
        Config.get_db_connection_string(),
        cursor_factory=RealDictCursor
    )
    return conn, conn.cursor()


# ═══════════════════════════════════════════════════════════════
# МОДЕЛЬ ПОЛЬЗОВАТЕЛЯ
# ═══════════════════════════════════════════════════════════════

class User:
    """Модель пользователя (сотрудника) системы"""

    def __init__(self, employee_id, email, first_name, last_name, patronymic, role, is_active):
        self.id = employee_id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.patronymic = patronymic
        self.role = role
        self.is_active = is_active
        self.is_authenticated = True
        self.is_anonymous = False

    def get_id(self):
        """Возвращает ID пользователя (требуется для Flask-Login)"""
        return str(self.id)

    @staticmethod
    def get_by_email(email):
        """Получить пользователя по email"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        с.ид_сотрудник,
                        с.email,
                        с.имя,
                        с.фамилия,
                        с.отчество,
                        с.пароль,
                        р.название as роль,
                        с.активен
                    FROM сотрудники с
                    JOIN роли р ON с.ид_роль = р.ид_роль
                    WHERE с.email = %s AND с.активен = true
                """, (email,))

                row = cur.fetchone()
                if row:
                    return {
                        'id': row['ид_сотрудник'],
                        'email': row['email'],
                        'first_name': row['имя'],
                        'last_name': row['фамилия'],
                        'patronymic': row['отчество'],
                        'password': row['пароль'],
                        'role': row['роль'],
                        'is_active': row['активен']
                    }
                return None

    @staticmethod
    def get_by_id(user_id):
        """Получить пользователя по ID"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        с.ид_сотрудник,
                        с.email,
                        с.имя,
                        с.фамилия,
                        с.отчество,
                        р.название as роль,
                        с.активен
                    FROM сотрудники с
                    JOIN роли р ON с.ид_роль = р.ид_роль
                    WHERE с.ид_сотрудник = %s AND с.активен = true
                """, (user_id,))

                row = cur.fetchone()
                if row:
                    return User(
                        employee_id=row['ид_сотрудник'],
                        email=row['email'],
                        first_name=row['имя'],
                        last_name=row['фамилия'],
                        patronymic=row['отчество'],
                        role=row['роль'],
                        is_active=row['активен']
                    )
                return None


# ═══════════════════════════════════════════════════════════════
# МОДЕЛЬ ГРУЗА
# ═══════════════════════════════════════════════════════════════

class Cargo:
    """Модель груза"""

    @staticmethod
    def get_all(limit=100):
        """Получить список всех грузов"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        g.ид_груз,
                        g.номер_груза,
                        k.название as клиент,
                        c1.название as город_от,
                        c2.название as город_до,
                        s.наименование as статус,
                        g.дата_создания
                    FROM грузы g
                    JOIN клиенты k ON g.ид_клиент = k.ид_клиент
                    JOIN склады sk1 ON g.ид_склад_отправления = sk1.ид_склад
                    JOIN города c1 ON sk1.ид_город = c1.ид_город
                    JOIN склады sk2 ON g.ид_склад_назначения = sk2.ид_склад
                    JOIN города c2 ON sk2.ид_город = c2.ид_город
                    JOIN статусы_заказов s ON g.ид_статус = s.ид_статус
                    ORDER BY g.дата_создания DESC
                    LIMIT %s
                """, (limit,))
                return cur.fetchall()

    @staticmethod
    def get_by_status(status_name):
        """Получить грузы по статусу"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        g.ид_груз,
                        g.номер_груза,
                        k.название as клиент,
                        c1.название as город_от,
                        c2.название as город_до,
                        s.наименование as статус,
                        g.дата_создания
                    FROM грузы g
                    JOIN клиенты k ON g.ид_клиент = k.ид_клиент
                    JOIN склады sk1 ON g.ид_склад_отправления = sk1.ид_склад
                    JOIN города c1 ON sk1.ид_город = c1.ид_город
                    JOIN склады sk2 ON g.ид_склад_назначения = sk2.ид_склад
                    JOIN города c2 ON sk2.ид_город = c2.ид_город
                    JOIN статусы_заказов s ON g.ид_статус = s.ид_статус
                    WHERE s.наименование = %s
                    ORDER BY g.дата_создания DESC
                    LIMIT 100
                """, (status_name,))
                return cur.fetchall()

    @staticmethod
    def get_by_number(cargo_number):
        """Получить груз по номеру"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        g.номер_груза,
                        st.наименование as статус,
                        c1.название as от,
                        c2.название as до
                    FROM грузы g
                    JOIN склады s1 ON g.ид_склад_отправления = s1.ид_склад
                    JOIN города c1 ON s1.ид_город = c1.ид_город
                    JOIN склады s2 ON g.ид_склад_назначения = s2.ид_склад
                    JOIN города c2 ON s2.ид_город = c2.ид_город
                    JOIN статусы_заказов st ON g.ид_статус = st.ид_статус
                    WHERE g.номер_груза = %s
                """, (cargo_number,))
                return cur.fetchone()


# ═══════════════════════════════════════════════════════════════
# МОДЕЛЬ ОТЧЁТОВ
# ═══════════════════════════════════════════════════════════════

class Reports:
    """Модель для работы с отчётами и аналитикой"""

    @staticmethod
    def get_kpi_monthly():
        """Получить KPI доставок по месяцам"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        TO_CHAR(g.дата_создания, 'YYYY-MM') as месяц,
                        COUNT(*) as всего_заказов,
                        COUNT(CASE WHEN s.наименование = 'Доставлен' THEN 1 END) as доставлено
                    FROM грузы g
                    JOIN статусы_заказов s ON g.ид_статус = s.ид_статус
                    WHERE g.дата_создания >= CURRENT_DATE - INTERVAL '6 months'
                    GROUP BY TO_CHAR(g.дата_создания, 'YYYY-MM')
                    ORDER BY месяц DESC
                """)
                return cur.fetchall()

    @staticmethod
    def get_status_distribution():
        """Распределение заказов по статусам"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        s.наименование,
                        COUNT(g.ид_груз) as количество
                    FROM статусы_заказов s
                    LEFT JOIN грузы g ON s.ид_статус = g.ид_статус
                    GROUP BY s.ид_статус, s.наименование
                    ORDER BY s.порядок_сортировки
                """)
                return cur.fetchall()


# ═══════════════════════════════════════════════════════════════
# МОДЕЛЬ СТАТИСТИКИ
# ═══════════════════════════════════════════════════════════════

class Statistics:
    """Модель для статистики"""

    @staticmethod
    def get_total_cargos():
        """Получить общее количество грузов"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM грузы")
                return cur.fetchone()['count']

    @staticmethod
    def get_total_employees():
        """Получить количество активных сотрудников"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM сотрудники WHERE активен = true")
                return cur.fetchone()['count']

    @staticmethod
    def get_total_clients():
        """Получить количество активных клиентов"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM клиенты WHERE активен = true")
                return cur.fetchone()['count']

    @staticmethod
    def get_monthly_cargos():
        """Получить количество грузов за последние 30 дней"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT COUNT(*) FROM грузы 
                    WHERE дата_создания >= CURRENT_DATE - INTERVAL '30 days'
                """)
                return cur.fetchone()['count']

    @staticmethod
    def get_active_orders():
        """Получить количество активных заказов"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT COUNT(*) FROM грузы 
                    WHERE ид_статус IN (
                        SELECT ид_статус FROM статусы_заказов 
                        WHERE наименование NOT IN ('Доставлен', 'Отменён')
                    )
                """)
                return cur.fetchone()['count']

    @staticmethod
    def get_today_orders():
        """Получить количество заказов за сегодня"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT COUNT(*) FROM грузы 
                    WHERE дата_создания >= CURRENT_DATE
                """)
                return cur.fetchone()['count']
