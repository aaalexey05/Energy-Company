# ═══════════════════════════════════════════════════════════════
# Logistics 5NF - Authentication Module
# ═══════════════════════════════════════════════════════════════

from flask_login import LoginManager
from werkzeug.security import check_password_hash
from models import User


# ═══════════════════════════════════════════════════════════════
# ИНИЦИАЛИЗАЦИЯ FLASK-LOGIN
# ═══════════════════════════════════════════════════════════════

login_manager = LoginManager()


def init_auth(app):
    """Инициализация системы аутентификации"""
    login_manager.init_app(app)
    login_manager.login_view = 'login'
    login_manager.login_message = 'Пожалуйста, войдите для доступа к этой странице.'
    login_manager.login_message_category = 'warning'


# ═══════════════════════════════════════════════════════════════
# ЗАГРУЗКА ПОЛЬЗОВАТЕЛЯ
# ═══════════════════════════════════════════════════════════════

@login_manager.user_loader
def load_user(user_id):
    """Загрузить пользователя по ID (требуется для Flask-Login)"""
    return User.get_by_id(int(user_id))


# ═══════════════════════════════════════════════════════════════
# ФУНКЦИИ АУТЕНТИФИКАЦИИ
# ═══════════════════════════════════════════════════════════════

def authenticate_user(email, password):
    """
    Аутентификация пользователя

    Args:
        email (str): Email пользователя
        password (str): Пароль пользователя

    Returns:
        User | None: Объект пользователя или None при ошибке
    """
    user_data = User.get_by_email(email)

    if not user_data:
        return None

    # Проверка пароля
    if not check_password_hash(user_data['password'], password):
        return None

    # Создание объекта пользователя
    return User(
        employee_id=user_data['id'],
        email=user_data['email'],
        first_name=user_data['first_name'],
        last_name=user_data['last_name'],
        patronymic=user_data['patronymic'],
        role=user_data['role'],
        is_active=user_data['is_active']
    )


def get_user_dashboard_url(role):
    """
    Получить URL дашборда в зависимости от роли

    Args:
        role (str): Роль пользователя

    Returns:
        str: URL дашборда
    """
    role_dashboards = {
        'Администратор': 'admin.dashboard',
        'Менеджер по заказам': 'manager.dashboard',
        'Кладовщик': 'warehouse.dashboard',
        'Курьер': 'courier.dashboard',
        'Клиент': 'client.dashboard'
    }

    return role_dashboards.get(role, 'index')


def check_role(user, required_role):
    """
    Проверить, имеет ли пользователь необходимую роль

    Args:
        user: Объект пользователя
        required_role (str): Требуемая роль

    Returns:
        bool: True если роль совпадает
    """
    return user.role == required_role
