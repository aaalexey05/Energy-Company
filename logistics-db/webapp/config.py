# ═══════════════════════════════════════════════════════════════
# Logistics 5NF - Configuration
# ═══════════════════════════════════════════════════════════════

import os
from datetime import timedelta


class Config:
    """Базовая конфигурация приложения"""

    # Секретный ключ для сессий и CSRF защиты
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'

    # Конфигурация базы данных PostgreSQL
    DB_HOST = os.environ.get('DB_HOST', 'localhost')
    DB_PORT = os.environ.get('DB_PORT', '5432')
    DB_NAME = os.environ.get('DB_NAME', 'logistics_5nf')
    DB_USER = os.environ.get('DB_USER', 'logistics_admin')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', 'secure_password_2026')

    # Flask конфигурация
    FLASK_ENV = os.environ.get('FLASK_ENV', 'production')
    DEBUG = os.environ.get('FLASK_DEBUG', '0') == '1'

    # Сессии
    PERMANENT_SESSION_LIFETIME = timedelta(hours=24)
    SESSION_COOKIE_SECURE = False  # True для HTTPS
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'

    # Безопасность
    WTF_CSRF_ENABLED = True
    WTF_CSRF_TIME_LIMIT = None

    # Локализация
    BABEL_DEFAULT_LOCALE = 'ru'
    BABEL_DEFAULT_TIMEZONE = 'Asia/Novosibirsk'

    @staticmethod
    def get_db_connection_string():
        """Получить строку подключения к БД"""
        return (
            f"host={Config.DB_HOST} "
            f"port={Config.DB_PORT} "
            f"dbname={Config.DB_NAME} "
            f"user={Config.DB_USER} "
            f"password={Config.DB_PASSWORD}"
        )

    @staticmethod
    def init_app(app):
        """Инициализация конфигурации приложения"""
        pass


class DevelopmentConfig(Config):
    """Конфигурация для разработки"""
    DEBUG = True
    FLASK_ENV = 'development'


class ProductionConfig(Config):
    """Конфигурация для продакшена"""
    DEBUG = False
    FLASK_ENV = 'production'
    SESSION_COOKIE_SECURE = True


class TestingConfig(Config):
    """Конфигурация для тестирования"""
    TESTING = True
    WTF_CSRF_ENABLED = False


# Словарь конфигураций
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}
