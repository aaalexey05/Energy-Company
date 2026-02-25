logistics-db/
│
├── backups/                  # Автоматические и ручные резервные копии БД
├── config/                   # Конфигурационные файлы PostgreSQL (postgresql.conf)
├── logs/                     # Логи работы сервисов и БД
│
├── ml_service/               # Модуль машинного обучения
│   ├── models/               # Сериализованные обученные модели (.pkl)
│   ├── notebooks/            # Jupyter Notebooks для экспериментов и EDA
│   ├── data_preparation.py   # Скрипт сбора и подготовки данных из БД
│   ├── delivery_time_predictor.py  # Модель регрессии (время доставки)
│   ├── vehicle_selector.py   # Модель классификации (выбор транспорта)
│   └── train_models.py       # Скрипт полного цикла обучения моделей
│
├── pgadmin-config/           # Настройки подключения для pgAdmin 4
├── sql-scripts/              # SQL-миграции и скрипты инициализации
│   ├── 01_init_schema.sql    # Создание таблиц и связей
│   └── 02_seed_data.sql      # Заполнение тестовыми данными
│
├── webapp/                   # Основное веб-приложение (Flask)
│   ├── ml_service/           # Симлинк или интеграция с ML-модулем
│   ├── routes/               # Blueprints (контроллеры)
│   │   ├── auth.py           # Авторизация и аутентификация
│   │   ├── main.py           # Основные маршруты (дашборд)
│   │   ├── orders.py         # Управление заказами
│   │   └── api.py            # REST API для AJAX-запросов
│   │
│   ├── static/               # Статические файлы
│   │   ├── css/              # Стили (Bootstrap, кастомные)
│   │   ├── js/               # Скрипты (Charts.js, DataTables)
│   │   └── img/              # Изображения и иконки
│   │
│   ├── templates/            # HTML-шаблоны (Jinja2)
│   │   ├── auth/             # Шаблоны входа и регистрации
│   │   ├── orders/           # Карточки и списки заказов
│   │   ├── reports/          # Шаблоны для генерации PDF
│   │   └── base.html         # Базовый макет страницы
│   │
│   ├── app.py                # Точка входа в приложение (create_app)
│   ├── auth.py               # Логика защиты маршрутов (Flask-Login)
│   ├── config.py             # Конфигурация приложения (ENV, Secret Keys)
│   ├── models.py             # SQLAlchemy ORM модели
│   ├── pdf_service.py        # Генерация PDF-документов
│   ├── mail_service.py       # Отправка Email-уведомлений
│   ├── Dockerfile            # Инструкция сборки образа веб-приложения
│   └── requirements.txt      # Python-зависимости (Flask, Pandas, Sklearn)
│
├── .env                      # Переменные окружения (не в репозитории)
├── .gitignore                # Исключения Git
├── docker-compose.yml        # Оркестрация контейнеров (App, DB, Adminer)
├── Dockerfile                # Корневой Dockerfile (опционально)
├── Makefile                  # Команды автоматизации (make build, make up)
└── README.md                 # Документация проекта
