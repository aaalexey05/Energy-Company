from flask import jsonify, render_template, Flask, request, redirect, url_for, flash, session
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from functools import wraps
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import random
import string

app = Flask(__name__)
app.secret_key = 'super_secret_key_logistics_2026'

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

class User(UserMixin):
    def __init__(self, id, username, full_name, role):
        self.id = id
        self.username = username
        self.full_name = full_name
        self.role = role

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'администратор':
            flash('Доступ запрещён. Требуются права администратора.', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

def get_db_connection():
    return psycopg2.connect(
        host='postgres', 
        port='5432', 
        dbname='logistics_5nf', 
        user='logistics_admin', 
        password='secure_password_2026',
        cursor_factory=RealDictCursor
    )

@login_manager.user_loader
def load_user(user_id):
    conn = psycopg2.connect(host='postgres', port='5432', dbname='logistics_5nf', user='logistics_admin', password='secure_password_2026')
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT id_пользователя, имя_пользователя, полное_имя, роль FROM пользователи WHERE id_пользователя = %s', (user_id,))
    user_data = cursor.fetchone()
    cursor.close()
    conn.close()
    if user_data:
        return User(user_data['id_пользователя'], user_data['имя_пользователя'], user_data['полное_имя'], user_data['роль'])
    return None

print("=" * 60)
print("🚀 Logistics 5NF - Starting Application")
print("=" * 60)
print(f"Environment: {os.getenv('FLASK_ENV', 'development')}")
print(f"Host: 0.0.0.0")
print(f"Port: 5000")
print(f"Debug: True")
print(f"Database: postgres:5432")
print("=" * 60)

BASE_TEMPLATE = '''<!DOCTYPE html>
<html>
<head>
    <title>{title} - Logistics 5NF</title>
    <meta charset="UTF-8">
    <style>
        * {{box-sizing:border-box;margin:0;padding:0}}
        body {{font-family:Arial,sans-serif;background:#ecf0f1}}
        .header {{background:#2c3e50;color:white;padding:20px;box-shadow:0 2px 4px rgba(0,0,0,0.1)}}
        .header h1 {{font-size:28px;display:inline-block}}
        .user-info {{float:right;font-size:14px;margin-top:5px}}
        .user-info a {{color:#ecf0f1;text-decoration:none}}
        .user-info a:hover {{text-decoration:underline}}
        .nav {{background:#34495e;padding:15px;overflow:hidden}}
        .nav a {{color:white;text-decoration:none;margin:0 10px;padding:10px 20px;background:#3498db;border-radius:5px;display:inline-block;transition:0.3s}}
        .nav a:hover {{background:#2980b9}}
        .nav a.admin {{background:#e74c3c}}
        .nav a.admin:hover {{background:#c0392b}}
        .container {{max-width:1400px;margin:30px auto;padding:0 20px}}
        .page-title {{color:#2c3e50;margin-bottom:20px;font-size:32px}}
        table {{width:100%;background:white;border-collapse:collapse;box-shadow:0 2px 8px rgba(0,0,0,0.1);border-radius:8px;overflow:hidden}}
        thead {{background:#34495e;color:white}}
        thead th {{padding:15px;text-align:left;font-weight:bold}}
        tbody tr {{border-bottom:1px solid #ddd}}
        tbody tr:hover {{background:#f5f5f5}}
        tbody td {{padding:12px 15px}}
        .stats {{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:20px;margin-bottom:30px}}
        .stat-card {{background:white;padding:25px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.1);text-align:center}}
        .stat-card h3 {{margin:0 0 10px 0;color:#7f8c8d;font-size:14px;text-transform:uppercase}}
        .stat-card .number {{font-size:48px;font-weight:bold;margin:10px 0}}
        .stat-card.blue .number {{color:#3498db}}
        .stat-card.purple .number {{color:#9b59b6}}
        .stat-card.orange .number {{color:#e67e22}}
        .stat-card.green .number {{color:#16a085}}
        .badge {{padding:5px 10px;border-radius:4px;font-size:12px;font-weight:bold}}
        .badge-success {{background:#d4edda;color:#155724}}
        .badge-warning {{background:#fff3cd;color:#856404}}
        .badge-danger {{background:#f8d7da;color:#721c24}}
        .badge-info {{background:#d1ecf1;color:#0c5460}}
        .btn {{padding:8px 16px;border:none;border-radius:5px;cursor:pointer;text-decoration:none;display:inline-block;font-size:14px;transition:0.3s}}
        .btn-primary {{background:#3498db;color:white}}
        .btn-primary:hover {{background:#2980b9}}
        .btn-success {{background:#27ae60;color:white}}
        .btn-success:hover {{background:#229954}}
        .btn-danger {{background:#e74c3c;color:white}}
        .btn-danger:hover {{background:#c0392b}}
        .btn-edit {{background:#f39c12;color:white}}
        .btn-edit:hover {{background:#e67e22}}
        .actions {{display:flex;gap:5px}}
        .toolbar {{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center}}
        .form-group {{margin-bottom:20px}}
        .form-group label {{display:block;margin-bottom:8px;color:#34495e;font-weight:bold}}
        .form-group input, .form-group select, .form-group textarea {{width:100%;padding:10px;border:2px solid #ddd;border-radius:5px;font-size:14px}}
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {{outline:none;border-color:#3498db}}
        .form-actions {{display:flex;gap:10px;justify-content:flex-end;margin-top:30px}}
        .alert {{padding:15px;margin-bottom:20px;border-radius:5px}}
        .alert-success {{background:#d4edda;color:#155724;border:1px solid #c3e6cb}}
        .alert-error {{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}}
        .alert-info {{background:#d1ecf1;color:#0c5460;border:1px solid #bee5eb}}
        .form-box {{background:white;padding:30px;border-radius:8px;max-width:800px}}
        .form-row {{display:grid;grid-template-columns:1fr 1fr;gap:20px}}
    </style>
</head>
<body>
    <div class="header">
        <div class="user-info">👤 {user_name} | {user_role} | <a href="/logout">Выход</a></div>
        <h1>📊 Логистическая система 5NF</h1>
    </div>
    <div class="nav">
        <a href="/">🏠 Главная</a>
        <a href="/orders">📦 Заказы</a>
        <a href="/routes">🗺️ Маршруты</a>
        <a href="/warehouses">🏭 Склады</a>
        <a href="/vehicles">🚚 Транспорт</a>
        <a href="/clients">👥 Клиенты</a>
        <a href="/employees">👔 Сотрудники</a>
        {admin_menu}
    </div>
    <div class="container">
        {alerts}
        {content}
    </div>
    <script>
        function confirmDelete(entity, id) {{
            return confirm('Вы уверены, что хотите удалить ' + entity + ' #' + id + '?');
        }}
    </script>
</body>
</html>'''


# ============ RBAC PERMISSIONS ============
PERMISSIONS = {
    'администратор': {
        'clients': ['read', 'create', 'update', 'delete'],
        'orders': ['read', 'create', 'update', 'delete'],
        'routes': ['read', 'create', 'update', 'delete'],
        'warehouses': ['read', 'create', 'update', 'delete'],
        'vehicles': ['read', 'create', 'update', 'delete'],
        'users': ['read', 'create', 'update', 'delete'],
        'employees': ['read', 'create', 'update', 'delete'],
        'admin': ['read', 'create', 'update', 'delete'],  # Админ-панель
    },
    'менеджер': {
        'clients': ['read', 'create', 'update', 'delete'],
        'orders': ['read', 'create', 'update', 'delete'],
        'routes': ['read', 'create'],
        'warehouses': ['read'],
        'vehicles': ['read'],
        'users': [],  # Нет доступа к пользователям
        'employees': ['read'],
        'admin': [],  # Нет доступа в админку
    },
    'логист': {
        'clients': ['read'],
        'orders': ['read', 'update'],
        'routes': ['read', 'create', 'update', 'delete'],
        'warehouses': ['read'],
        'vehicles': ['read', 'create', 'update', 'delete'],
        'users': [],
        'employees': ['read'],
        'admin': [],
    },
    'водитель': {
        'clients': ['read'],
        'orders': ['read', 'update'],
        'routes': ['read'],
        'warehouses': ['read', 'update'],
        'vehicles': ['read'],
        'users': [],
        'employees': ['read'],
        'admin': [],
    },
    'клиент': {
        'clients': ['read'],  # Клиент видит только свои данные
        'orders': ['read', 'create'],  # Может создавать заказы
        'routes': ['read'],
        'warehouses': [],
        'vehicles': [],
        'users': [],
        'employees': [],
        'admin': [],
    },
}

# ============= ФУНКЦИЯ РЕНДЕРА СТРАНИЦ =============
def render_page(title, content, user):
    """Универсальный шаблон страницы с навигацией"""
    
    # Получаем flash-сообщения
    from flask import get_flashed_messages
    flashes = get_flashed_messages(with_categories=True)
    
    flash_html = ""
    if flashes:
        for category, message in flashes:
            color = '#27ae60' if category == 'success' else '#e74c3c'
            flash_html += f'<div style="padding:15px;margin-bottom:20px;background:{color};color:white;border-radius:5px">{message}</div>'
    
    return f"""<!DOCTYPE html>
<html><head><title>{title} - Logistics 5NF</title><meta charset="UTF-8">
<style>
*{{margin:0;padding:0;box-sizing:border-box}}
body{{font-family:Arial,sans-serif;background:#f5f5f5}}
.header{{background:#2c3e50;color:white;padding:15px 30px;display:flex;justify-content:space-between;align-items:center}}
.header h1{{font-size:24px}}
.nav{{display:flex;gap:20px}}
.nav a{{color:white;text-decoration:none;padding:8px 15px;border-radius:5px}}
.nav a:hover{{background:#34495e}}
.container{{max-width:1200px;margin:30px auto;padding:0 20px}}
table{{width:100%;border-collapse:collapse;background:white;box-shadow:0 2px 10px rgba(0,0,0,0.1);margin-top:20px}}
th,td{{padding:12px;text-align:left;border-bottom:1px solid #ddd}}
th{{background:#34495e;color:white}}
tr:hover{{background:#f5f5f5}}
a{{color:#3498db;text-decoration:none}}
a:hover{{text-decoration:underline}}
</style>
</head>
<body>
<div class="header">
    <h1>🚚 Logistics 5NF</h1>
    <div class="nav">
        <a href="/">Главная</a>
        <a href="/orders">Заказы</a>
        <a href="/routes">Маршруты</a>
        <a href="/warehouses">Склады</a>
        <a href="/vehicles">Транспорт</a>
        <a href="/clients">Клиенты</a>
        <a href="/employees">Сотрудники</a>
        {'<a href="/admin" style="background:#e74c3c">Админка</a>' if user.role == 'администратор' else ''}
        <a href="/logout">Выход ({user.full_name})</a>
    </div>
</div>
<div class="container">{flash_html}{content}</div>
</body>
</html>"""


def has_permission(role, resource, action):
    if role not in PERMISSIONS:
        return False
    return action in PERMISSIONS[role].get(resource, [])

def permission_required(resource, action):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                flash('Требуется авторизация', 'error')
                return redirect(url_for('login'))
            if not has_permission(current_user.role, resource, action):
                flash(f'У вас нет прав: {action} на {resource}', 'error')
                return redirect(url_for('index'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def require_permission(resource, action):
    """Декоратор для проверки прав доступа"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                flash('Требуется авторизация', 'error')
                return redirect(url_for('login'))
            
            user_role = current_user.role
            
            # Администратор имеет полный доступ ко всему
            if user_role == 'администратор':
                return f(*args, **kwargs)
            
            # Проверяем права для других ролей
            permissions = PERMISSIONS.get(user_role, {})
            resource_permissions = permissions.get(resource, [])
            
            if action not in resource_permissions:
                flash(f'У вас нет прав: {action} на {resource}', 'error')
                return redirect(url_for('index'))
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if not username or not password:
            flash('Введите логин и пароль', 'error')
            return redirect(url_for('login'))
        
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute('SELECT id_пользователя, пароль_хеш, полное_имя, роль, активен FROM пользователи WHERE имя_пользователя = %s', (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if user and user['активен']:
            stored_password = user['пароль_хеш']
            password_valid = False
            
            # Проверка пароля с защитой от пустых значений
            if stored_password:
                stored_password = stored_password.strip()  # убираем пробелы
                
                if stored_password.startswith('$2b$'):
                    # BCrypt хеш
                    try:
                        password_valid = check_password_hash(stored_password, password)
                    except (ValueError, Exception):
                        password_valid = False
                else:
                    # Обычный текст
                    password_valid = (stored_password == password)
            
            if password_valid:
                user_obj = User(user['id_пользователя'], username, user['полное_имя'], user['роль'])
                login_user(user_obj)
                flash(f'Добро пожаловать, {user["полное_имя"]}!', 'success')
                return redirect(url_for('index'))
        
        flash('Неверный логин или пароль', 'error')
        return redirect(url_for('login'))
    
    # GET request
    return """<!DOCTYPE html>
<html><head><title>Вход</title><meta charset="UTF-8">
<style>body{font-family:Arial;margin:0;padding:0;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;display:flex;align-items:center;justify-content:center}
.login-box{background:white;padding:40px;border-radius:10px;width:400px;box-shadow:0 10px 40px rgba(0,0,0,0.3)}
h1{margin:0 0 30px;text-align:center;color:#2c3e50}.form-group{margin-bottom:20px}label{display:block;margin-bottom:8px;color:#34495e;font-weight:bold}
input{width:100%;padding:12px;border:2px solid #ddd;border-radius:5px;font-size:14px;box-sizing:border-box}
button{width:100%;padding:14px;background:#667eea;color:white;border:none;border-radius:5px;font-size:16px;font-weight:bold;cursor:pointer}
button:hover{background:#5568d3}.test-users{margin-top:30px;padding:20px;background:#ecf0f1;border-radius:8px}
.test-users h3{margin:0 0 15px;font-size:14px;color:#2c3e50}.test-users ul{list-style:none;padding:0;margin:0}
.test-users li{padding:5px 0;font-size:12px;color:#555}</style></head><body><div class="login-box"><h1>🔐 Вход</h1>
<form method="POST"><div class="form-group"><label>Логин:</label><input type="text" name="username" required autofocus></div>
<div class="form-group"><label>Пароль:</label><input type="password" name="password" required></div><button type="submit">Войти</button></form>
<div class="test-users"><h3>Тестовые аккаунты (пароль: admin123):</h3><ul>
<li><strong>admin</strong> - Администратор</li><li><strong>manager</strong> - Менеджер</li>
<li><strong>logist</strong> - Логист</li><li><strong>warehouse</strong> - Водитель</li></ul></div></div></body></html>"""


@app.route('/')
@login_required
def index():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute('SELECT COUNT(*) as count FROM грузы')
    result = cursor.fetchone()
    total_orders = result['count'] if result else 0
    
    cursor.execute('SELECT COUNT(*) as count FROM транспортные_средства WHERE статус = %s', ('свободно',))
    result = cursor.fetchone()
    active_vehicles = result['count'] if result else 0
    
    cursor.execute('SELECT COUNT(*) as count FROM клиенты WHERE статус = %s', ('активный',))
    result = cursor.fetchone()
    active_clients = result['count'] if result else 0
    
    cursor.execute('SELECT COUNT(*) as count FROM маршруты WHERE статус = %s', ('активный',))
    result = cursor.fetchone()
    active_routes = result['count'] if result else 0
    
    cursor.close()
    conn.close()
    
    return f"""<!DOCTYPE html>
<html><head><title>Главная - Logistics 5NF</title><meta charset="UTF-8">
<style>*{{margin:0;padding:0;box-sizing:border-box}}body{{font-family:Arial,sans-serif;background:#f5f5f5}}
.header{{background:#2c3e50;color:white;padding:15px 30px;display:flex;justify-content:space-between;align-items:center}}
.header h1{{font-size:24px}}.nav{{display:flex;gap:20px}}.nav a{{color:white;text-decoration:none;padding:8px 15px;border-radius:5px}}
.nav a:hover{{background:#34495e}}.container{{max-width:1200px;margin:30px auto;padding:0 20px}}
.stats{{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:20px;margin-bottom:30px}}
.stat-card{{background:white;padding:25px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);text-align:center}}
.stat-card h3{{color:#7f8c8d;font-size:14px;margin-bottom:10px}}.stat-card .number{{font-size:36px;font-weight:bold;color:#2c3e50}}
.user-info{{background:white;padding:20px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}}
.user-info h2{{margin-bottom:15px;color:#2c3e50}}.user-info p{{color:#7f8c8d;margin:5px 0}}</style></head><body>
<div class="header"><h1>🚚 Logistics 5NF</h1><div class="nav">
<a href="/">Главная</a><a href="/orders">Заказы</a><a href="/routes">Маршруты</a>
<a href="/warehouses">Склады</a><a href="/vehicles">Транспорт</a><a href="/clients">Клиенты</a>
<a href="/employees">Сотрудники</a><a href="/admin">Админка</a><a href="/logout">Выход</a></div></div>
<div class="container"><h1 style="margin-bottom:20px">Панель управления</h1>
<div class="stats"><div class="stat-card"><h3>Всего заказов</h3><div class="number">{total_orders}</div></div>
<div class="stat-card"><h3>Свободных машин</h3><div class="number">{active_vehicles}</div></div>
<div class="stat-card"><h3>Активных клиентов</h3><div class="number">{active_clients}</div></div>
<div class="stat-card"><h3>Активных маршрутов</h3><div class="number">{active_routes}</div></div></div>
<div class="user-info"><h2>👤 Информация о пользователе</h2>
<p><strong>Имя:</strong> {current_user.full_name}</p>
<p><strong>Логин:</strong> {current_user.username}</p>
<p><strong>Роль:</strong> {current_user.role}</p></div></div></body></html>"""


@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Вы вышли из системы', 'success')
    return redirect(url_for('login'))

# ========== ADMIN PANEL ==========

@app.route('/admin')
@login_required
@admin_required
def admin_panel():
    content = '''
        <h2 class="page-title">⚙️ Панель администрирования</h2>
        <div class="stats">
            <div class="stat-card blue">
                <h3>Управление заказами</h3>
                <a href="/admin/orders" class="btn btn-primary" style="margin-top:20px">Управление грузами</a>
            </div>
            <div class="stat-card purple">
                <h3>Управление маршрутами</h3>
                <a href="/admin/routes" class="btn btn-primary" style="margin-top:20px">Управление маршрутами</a>
            </div>
            <div class="stat-card orange">
                <h3>Управление складами</h3>
                <a href="/admin/warehouses" class="btn btn-primary" style="margin-top:20px">Управление складами</a>
            </div>
            <div class="stat-card green">
                <h3>Управление транспортом</h3>
                <a href="/admin/vehicles" class="btn btn-primary" style="margin-top:20px">Управление ТС</a>
            </div>
        </div>
        <div class="stats">
            <div class="stat-card blue">
                <h3>Управление клиентами</h3>
                <a href="/admin/clients" class="btn btn-primary" style="margin-top:20px">Управление клиентами</a>
            </div>
            <div class="stat-card purple">
                <h3>Управление пользователями</h3>
                <a href="/admin/users" class="btn btn-primary" style="margin-top:20px">Управление пользователями</a>
            </div>
        </div>
    '''
    return render_page('Администрирование', content, current_user)

# ========== ADMIN CRUD: CLIENTS ==========

@app.route('/admin/clients')
@login_required
@admin_required
def admin_clients():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT 
            к.ид_клиент, к.название, к.инн, к.контактный_телефон, 
            к.электронная_почта, к.адрес_регистрации, к.статус, к.дата_создания::date
        FROM клиенты к
        ORDER BY к.название
    ''')
    clients = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for client in clients:
        status_class = 'success' if client['статус'] == 'активный' else 'warning'
        table_rows += f'''
        <tr>
            <td>{client['ид_клиент']}</td>
            <td><strong>{client['название']}</strong></td>
            <td>{client['инн'] or '-'}</td>
            <td>{client['контактный_телефон'] or '-'}</td>
            <td>{client['электронная_почта'] or '-'}</td>
            <td><span class="badge badge-{status_class}">{client['статус']}</span></td>
            <td class="actions">
                <a href="/admin/clients/edit/{client['ид_клиент']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/clients/delete/{client['ид_клиент']}" style="display:inline" onsubmit="return confirmDelete('клиента', {client['ид_клиент']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">👥 Управление клиентами</h2>
            <a href="/admin/clients/create" class="btn btn-success">➕ Добавить клиента</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Название</th>
                    <th>ИНН</th>
                    <th>Телефон</th>
                    <th>Email</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление клиентами', content, current_user)

# ============= СОЗДАНИЕ КЛИЕНТА =============
@app.route('/admin/clients/create', methods=['GET', 'POST'])
@login_required
@require_permission('clients', 'create')
def admin_clients_create():
    if request.method == 'POST':
        название = request.form.get('название')
        тип_клиента = request.form.get('тип_клиента')
        контактный_телефон = request.form.get('контактный_телефон')
        электронная_почта = request.form.get('электронная_почта')
        адрес_регистрации = request.form.get('адрес_регистрации')
        инн = request.form.get('инн')
        кпп = request.form.get('кпп')
        
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        try:
            cursor.execute('''
                INSERT INTO клиенты 
                (название, тип_клиента, контактный_телефон, электронная_почта, 
                 адрес_регистрации, инн, кпп, статус)
                VALUES (%s, %s, %s, %s, %s, %s, %s, 'активный')
            ''', (название, тип_клиента, контактный_телефон, электронная_почта,
                  адрес_регистрации, инн, кпп))
            conn.commit()
            flash('Клиент успешно создан', 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Ошибка при создании клиента: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('clients'))
    
    # GET - показываем форму
    content = """
    <h1>➕ Создание клиента</h1>
    <form method="POST" style="background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);max-width:600px">
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Название организации *</label>
            <input type="text" name="название" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Тип клиента</label>
            <select name="тип_клиента" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
                <option value="юридическое лицо">Юридическое лицо</option>
                <option value="физическое лицо">Физическое лицо</option>
                <option value="ИП">ИП</option>
            </select>
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Контактный телефон</label>
            <input type="tel" name="контактный_телефон" placeholder="+7 (999) 123-45-67" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Email</label>
            <input type="email" name="электронная_почта" placeholder="email@example.com" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">ИНН</label>
            <input type="text" name="инн" placeholder="1234567890" maxlength="12" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">КПП</label>
            <input type="text" name="кпп" placeholder="123456789" maxlength="9" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Адрес регистрации</label>
            <textarea name="адрес_регистрации" rows="3" placeholder="г. Москва, ул. Ленина, д. 1" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px"></textarea>
        </div>
        
        <div style="display:flex;gap:10px">
            <button type="submit" style="padding:12px 30px;background:#27ae60;color:white;border:none;border-radius:5px;cursor:pointer;font-size:16px">✅ Создать</button>
            <a href="/clients" style="padding:12px 30px;background:#95a5a6;color:white;border-radius:5px;text-decoration:none;display:inline-block">❌ Отмена</a>
        </div>
    </form>
    """
    return render_page('Создание клиента', content, current_user)


# ============= РЕДАКТИРОВАНИЕ КЛИЕНТА =============
@app.route('/admin/clients/edit/<int:client_id>', methods=['GET', 'POST'])
@login_required
@require_permission('clients', 'update')
def admin_clients_edit(client_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        название = request.form.get('название')
        тип_клиента = request.form.get('тип_клиента')
        контактный_телефон = request.form.get('контактный_телефон')
        электронная_почта = request.form.get('электронная_почта')
        адрес_регистрации = request.form.get('адрес_регистрации')
        инн = request.form.get('инн')
        кпп = request.form.get('кпп')
        статус = request.form.get('статус')
        
        try:
            cursor.execute('''
                UPDATE клиенты SET
                    название = %s,
                    тип_клиента = %s,
                    контактный_телефон = %s,
                    электронная_почта = %s,
                    адрес_регистрации = %s,
                    инн = %s,
                    кпп = %s,
                    статус = %s
                WHERE ид_клиент = %s
            ''', (название, тип_клиента, контактный_телефон, электронная_почта,
                  адрес_регистрации, инн, кпп, статус, client_id))
            conn.commit()
            flash('Клиент успешно обновлен', 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Ошибка при обновлении клиента: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('clients'))
    
    # GET - показываем форму с данными
    cursor.execute('SELECT * FROM клиенты WHERE ид_клиент = %s', (client_id,))
    client = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if not client:
        flash('Клиент не найден', 'error')
        return redirect(url_for('clients'))
    
    content = f"""
    <h1>✏️ Редактирование клиента #{client['ид_клиент']}</h1>
    <form method="POST" style="background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);max-width:600px">
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Название организации *</label>
            <input type="text" name="название" value="{client['название']}" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Тип клиента</label>
            <select name="тип_клиента" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
                <option value="юридическое лицо" {'selected' if client.get('тип_клиента') == 'юридическое лицо' else ''}>Юридическое лицо</option>
                <option value="физическое лицо" {'selected' if client.get('тип_клиента') == 'физическое лицо' else ''}>Физическое лицо</option>
                <option value="ИП" {'selected' if client.get('тип_клиента') == 'ИП' else ''}>ИП</option>
            </select>
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Контактный телефон</label>
            <input type="tel" name="контактный_телефон" value="{client.get('контактный_телефон', '')}" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Email</label>
            <input type="email" name="электронная_почта" value="{client.get('электронная_почта', '')}" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">ИНН</label>
            <input type="text" name="инн" value="{client.get('инн', '')}" maxlength="12" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">КПП</label>
            <input type="text" name="кпп" value="{client.get('кпп', '')}" maxlength="9" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Адрес регистрации</label>
            <textarea name="адрес_регистрации" rows="3" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">{client.get('адрес_регистрации', '')}</textarea>
        </div>
        
        <div style="margin-bottom:20px">
            <label style="display:block;margin-bottom:5px;font-weight:bold">Статус</label>
            <select name="статус" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:5px">
                <option value="активный" {'selected' if client['статус'] == 'активный' else ''}>Активный</option>
                <option value="неактивный" {'selected' if client['статус'] == 'неактивный' else ''}>Неактивный</option>
            </select>
        </div>
        
        <div style="display:flex;gap:10px">
            <button type="submit" style="padding:12px 30px;background:#3498db;color:white;border:none;border-radius:5px;cursor:pointer;font-size:16px">💾 Сохранить</button>
            <a href="/clients" style="padding:12px 30px;background:#95a5a6;color:white;border-radius:5px;text-decoration:none;display:inline-block">❌ Отмена</a>
        </div>
    </form>
    """
    return render_page(f'Редактирование клиента', content, current_user)


# ============= УДАЛЕНИЕ КЛИЕНТА =============
@app.route('/admin/clients/delete/<int:client_id>', methods=['POST'])
@login_required
@require_permission('clients', 'delete')
def admin_clients_delete(client_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cursor.execute('DELETE FROM клиенты WHERE ид_клиент = %s', (client_id,))
        conn.commit()
        flash('Клиент успешно удален', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка при удалении клиента: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('clients'))


# ========== ADMIN CRUD: WAREHOUSES ==========
@app.route('/admin/warehouses')
@login_required
@admin_required
def admin_warehouses():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT с.ид_склад, с.название, г.название AS город, с.адрес_полный,
               с.площадь_кв_м, с.вместимость_куб_м, с.статус
        FROM склады с
        LEFT JOIN города г ON с.ид_город = г.ид_город
        ORDER BY с.название
    ''')
    warehouses = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for w in warehouses:
        status_class = 'success' if w['статус'] == 'активен' else 'warning'
        table_rows += f'''
        <tr>
            <td>{w['ид_склад']}</td>
            <td><strong>{w['название']}</strong></td>
            <td>{w['город'] or '-'}</td>
            <td>{(w['адрес_полный'] or '-')[:50]}</td>
            <td>{w['площадь_кв_м']} м²</td>
            <td><span class="badge badge-{status_class}">{w['статус']}</span></td>
            <td class="actions">
                <a href="/admin/warehouses/edit/{w['ид_склад']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/warehouses/delete/{w['ид_склад']}" style="display:inline" onsubmit="return confirmDelete('склад', {w['ид_склад']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">🏭 Управление складами</h2>
            <a href="/admin/warehouses/create" class="btn btn-success">➕ Добавить склад</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Название</th>
                    <th>Город</th>
                    <th>Адрес</th>
                    <th>Площадь</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление складами', content, current_user)

@app.route('/admin/warehouses/create', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_warehouses_create():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        название = request.form.get('название')
        город_id = request.form.get('город_id') or None
        адрес = request.form.get('адрес')
        площадь = request.form.get('площадь')
        вместимость = request.form.get('вместимость')
        телефон = request.form.get('телефон')
        руководитель = request.form.get('руководитель')
        
        if not название or not площадь:
            flash('Название и площадь обязательны', 'error')
            return redirect(url_for('admin_warehouses_create'))
        
        cursor.execute('''
            INSERT INTO склады (название, ид_город, адрес_полный, площадь_кв_м, вместимость_куб_м, телефон, руководитель_фио)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        ''', (название, город_id, адрес, площадь, вместимость, телефон, руководитель))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Склад "{название}" успешно создан!', 'success')
        return redirect(url_for('admin_warehouses'))
    
    cursor.execute('SELECT ид_город, название FROM города ORDER BY название')
    cities = cursor.fetchall()
    cursor.close()
    conn.close()
    
    cities_options = '<option value="">-- Не выбран --</option>'
    for city in cities:
        cities_options += f'<option value="{city["ид_город"]}">{city["название"]}</option>'
    
    content = f'''
        <h2 class="page-title">➕ Добавить склад</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-group">
                    <label>Название *</label>
                    <input type="text" name="название" required>
                </div>
                <div class="form-group">
                    <label>Город</label>
                    <select name="город_id">
                        {cities_options}
                    </select>
                </div>
                <div class="form-group">
                    <label>Адрес</label>
                    <textarea name="адрес" rows="2"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Площадь (м²) *</label>
                        <input type="number" step="0.01" name="площадь" required>
                    </div>
                    <div class="form-group">
                        <label>Вместимость (м³)</label>
                        <input type="number" step="0.01" name="вместимость">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Телефон</label>
                        <input type="text" name="телефон">
                    </div>
                    <div class="form-group">
                        <label>Руководитель</label>
                        <input type="text" name="руководитель">
                    </div>
                </div>
                <div class="form-actions">
                    <a href="/admin/warehouses" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Создать</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Добавить склад', content, current_user)

@app.route('/admin/warehouses/edit/<int:warehouse_id>', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_warehouses_edit(warehouse_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        название = request.form.get('название')
        город_id = request.form.get('город_id') or None
        адрес = request.form.get('адрес')
        площадь = request.form.get('площадь')
        вместимость = request.form.get('вместимость')
        телефон = request.form.get('телефон')
        руководитель = request.form.get('руководитель')
        статус = request.form.get('статус')
        
        cursor.execute('''
            UPDATE склады 
            SET название = %s, ид_город = %s, адрес_полный = %s, площадь_кв_м = %s,
                вместимость_куб_м = %s, телефон = %s, руководитель_фио = %s, статус = %s
            WHERE ид_склад = %s
        ''', (название, город_id, адрес, площадь, вместимость, телефон, руководитель, статус, warehouse_id))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Склад "{название}" успешно обновлён!', 'success')
        return redirect(url_for('admin_warehouses'))
    
    cursor.execute('SELECT * FROM склады WHERE ид_склад = %s', (warehouse_id,))
    warehouse = cursor.fetchone()
    
    cursor.execute('SELECT ид_город, название FROM города ORDER BY название')
    cities = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not warehouse:
        flash('Склад не найден', 'error')
        return redirect(url_for('admin_warehouses'))
    
    cities_options = '<option value="">-- Не выбран --</option>'
    for city in cities:
        selected = 'selected' if warehouse['ид_город'] == city['ид_город'] else ''
        cities_options += f'<option value="{city["ид_город"]}" {selected}>{city["название"]}</option>'
    
    content = f'''
        <h2 class="page-title">✏️ Редактировать склад #{warehouse_id}</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-group">
                    <label>Название *</label>
                    <input type="text" name="название" value="{warehouse['название']}" required>
                </div>
                <div class="form-group">
                    <label>Город</label>
                    <select name="город_id">
                        {cities_options}
                    </select>
                </div>
                <div class="form-group">
                    <label>Адрес</label>
                    <textarea name="адрес" rows="2">{warehouse['адрес_полный'] or ''}</textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Площадь (м²) *</label>
                        <input type="number" step="0.01" name="площадь" value="{warehouse['площадь_кв_м']}" required>
                    </div>
                    <div class="form-group">
                        <label>Вместимость (м³)</label>
                        <input type="number" step="0.01" name="вместимость" value="{warehouse['вместимость_куб_м'] or ''}">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Телефон</label>
                        <input type="text" name="телефон" value="{warehouse['телефон'] or ''}">
                    </div>
                    <div class="form-group">
                        <label>Руководитель</label>
                        <input type="text" name="руководитель" value="{warehouse['руководитель_фио'] or ''}">
                    </div>
                </div>
                <div class="form-group">
                    <label>Статус</label>
                    <select name="статус">
                        <option value="активен" {'selected' if warehouse['статус'] == 'активен' else ''}>Активен</option>
                        <option value="неактивен" {'selected' if warehouse['статус'] == 'неактивен' else ''}>Неактивен</option>
                    </select>
                </div>
                <div class="form-actions">
                    <a href="/admin/warehouses" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Сохранить</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Редактировать склад', content, current_user)

@app.route('/admin/warehouses/delete/<int:warehouse_id>', methods=['POST'])
@login_required
@admin_required
def admin_warehouses_delete(warehouse_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute('DELETE FROM склады WHERE ид_склад = %s', (warehouse_id,))
        conn.commit()
        flash(f'Склад #{warehouse_id} успешно удалён!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка удаления: связанные записи существуют', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('admin_warehouses'))

# ========== ADMIN CRUD: ROUTES ==========

@app.route('/admin/routes')
@login_required
@admin_required
def admin_routes():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT ид_маршрут, код_маршрута, наименование, общее_расстояние_км,
               ожидаемое_время_часов, статус
        FROM маршруты
        ORDER BY дата_создания DESC
    ''')
    routes = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for r in routes:
        status_class = 'success' if r['статус'] == 'активный' else 'warning'
        table_rows += f'''
        <tr>
            <td>{r['ид_маршрут']}</td>
            <td><strong>{r['код_маршрута']}</strong></td>
            <td>{r['наименование']}</td>
            <td>{r['общее_расстояние_км']} км</td>
            <td>{r['ожидаемое_время_часов']} ч</td>
            <td><span class="badge badge-{status_class}">{r['статус']}</span></td>
            <td class="actions">
                <a href="/admin/routes/edit/{r['ид_маршрут']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/routes/delete/{r['ид_маршрут']}" style="display:inline" onsubmit="return confirmDelete('маршрут', {r['ид_маршрут']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">🗺️ Управление маршрутами</h2>
            <a href="/admin/routes/create" class="btn btn-success">➕ Добавить маршрут</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Код</th>
                    <th>Наименование</th>
                    <th>Расстояние</th>
                    <th>Время</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление маршрутами', content, current_user)

@app.route('/admin/routes/create', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_routes_create():
    if request.method == 'POST':
        код = request.form.get('код')
        название = request.form.get('название')
        расстояние = request.form.get('расстояние')
        время = request.form.get('время')
        описание = request.form.get('описание')
        
        if not all([код, название, расстояние, время]):
            flash('Все основные поля обязательны', 'error')
            return redirect(url_for('admin_routes_create'))
        
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute('''
            INSERT INTO маршруты (код_маршрута, наименование, общее_расстояние_км, ожидаемое_время_часов, описание)
            VALUES (%s, %s, %s, %s, %s)
        ''', (код, название, расстояние, время, описание))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Маршрут "{название}" успешно создан!', 'success')
        return redirect(url_for('admin_routes'))
    
    content = '''
        <h2 class="page-title">➕ Добавить маршрут</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Код маршрута *</label>
                        <input type="text" name="код" required>
                    </div>
                    <div class="form-group">
                        <label>Наименование *</label>
                        <input type="text" name="название" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Расстояние (км) *</label>
                        <input type="number" step="0.01" name="расстояние" required>
                    </div>
                    <div class="form-group">
                        <label>Время (ч) *</label>
                        <input type="number" step="0.01" name="время" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Описание</label>
                    <textarea name="описание" rows="3"></textarea>
                </div>
                <div class="form-actions">
                    <a href="/admin/routes" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Создать</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Добавить маршрут', content, current_user)

@app.route('/admin/routes/edit/<int:route_id>', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_routes_edit(route_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        код = request.form.get('код')
        название = request.form.get('название')
        расстояние = request.form.get('расстояние')
        время = request.form.get('время')
        описание = request.form.get('описание')
        статус = request.form.get('статус')
        
        cursor.execute('''
            UPDATE маршруты 
            SET код_маршрута = %s, наименование = %s, общее_расстояние_км = %s,
                ожидаемое_время_часов = %s, описание = %s, статус = %s
            WHERE ид_маршрут = %s
        ''', (код, название, расстояние, время, описание, статус, route_id))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Маршрут "{название}" успешно обновлён!', 'success')
        return redirect(url_for('admin_routes'))
    
    cursor.execute('SELECT * FROM маршруты WHERE ид_маршрут = %s', (route_id,))
    route = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if not route:
        flash('Маршрут не найден', 'error')
        return redirect(url_for('admin_routes'))
    
    content = f'''
        <h2 class="page-title">✏️ Редактировать маршрут #{route_id}</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Код маршрута *</label>
                        <input type="text" name="код" value="{route['код_маршрута']}" required>
                    </div>
                    <div class="form-group">
                        <label>Наименование *</label>
                        <input type="text" name="название" value="{route['наименование']}" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Расстояние (км) *</label>
                        <input type="number" step="0.01" name="расстояние" value="{route['общее_расстояние_км']}" required>
                    </div>
                    <div class="form-group">
                        <label>Время (ч) *</label>
                        <input type="number" step="0.01" name="время" value="{route['ожидаемое_время_часов']}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Описание</label>
                    <textarea name="описание" rows="3">{route['описание'] or ''}</textarea>
                </div>
                <div class="form-group">
                    <label>Статус</label>
                    <select name="статус">
                        <option value="активный" {'selected' if route['статус'] == 'активный' else ''}>Активный</option>
                        <option value="неактивный" {'selected' if route['статус'] == 'неактивный' else ''}>Неактивный</option>
                    </select>
                </div>
                <div class="form-actions">
                    <a href="/admin/routes" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Сохранить</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Редактировать маршрут', content, current_user)

@app.route('/admin/routes/delete/<int:route_id>', methods=['POST'])
@login_required
@admin_required
def admin_routes_delete(route_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute('DELETE FROM маршруты WHERE ид_маршрут = %s', (route_id,))
        conn.commit()
        flash(f'Маршрут #{route_id} успешно удалён!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка удаления: связанные записи существуют', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('admin_routes'))

# ========== ADMIN CRUD: VEHICLES ==========

@app.route('/admin/vehicles')
@login_required
@admin_required
def admin_vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT т.ид_средство, т.госномер, тип.наименование AS тип,
               т.марка, т.модель, т.статус, т.состояние
        FROM транспортные_средства т
        LEFT JOIN типы_средств_доставки тип ON т.ид_тип_средства = тип.ид_тип_средства
        ORDER BY т.госномер
    ''')
    vehicles = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for v in vehicles:
        status_class = 'success' if v['статус'] == 'свободно' else 'danger'
        condition_class = 'success' if v['состояние'] == 'исправен' else 'warning'
        table_rows += f'''
        <tr>
            <td>{v['ид_средство']}</td>
            <td><strong>{v['госномер']}</strong></td>
            <td>{v['тип'] or '-'}</td>
            <td>{v['марка']} {v['модель']}</td>
            <td><span class="badge badge-{status_class}">{v['статус']}</span></td>
            <td><span class="badge badge-{condition_class}">{v['состояние']}</span></td>
            <td class="actions">
                <a href="/admin/vehicles/edit/{v['ид_средство']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/vehicles/delete/{v['ид_средство']}" style="display:inline" onsubmit="return confirmDelete('ТС', {v['ид_средство']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">🚚 Управление транспортом</h2>
            <a href="/admin/vehicles/create" class="btn btn-success">➕ Добавить ТС</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Госномер</th>
                    <th>Тип</th>
                    <th>Марка/Модель</th>
                    <th>Статус</th>
                    <th>Состояние</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление транспортом', content, current_user)

@app.route('/admin/vehicles/create', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_vehicles_create():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        госномер = request.form.get('госномер')
        тип_id = request.form.get('тип_id')
        марка = request.form.get('марка')
        модель = request.form.get('модель')
        цвет = request.form.get('цвет')
        год = request.form.get('год')
        
        if not all([госномер, тип_id, марка, модель]):
            flash('Все основные поля обязательны', 'error')
            return redirect(url_for('admin_vehicles_create'))
        
        cursor.execute('''
            INSERT INTO транспортные_средства (госномер, ид_тип_средства, марка, модель, цвет, год_выпуска)
            VALUES (%s, %s, %s, %s, %s, %s)
        ''', (госномер, тип_id, марка, модель, цвет, год))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Транспортное средство "{госномер}" успешно создано!', 'success')
        return redirect(url_for('admin_vehicles'))
    
    cursor.execute('SELECT ид_тип_средства, наименование FROM типы_средств_доставки ORDER BY наименование')
    types = cursor.fetchall()
    cursor.close()
    conn.close()
    
    types_options = ''
    for t in types:
        types_options += f'<option value="{t["ид_тип_средства"]}">{t["наименование"]}</option>'
    
    content = f'''
        <h2 class="page-title">➕ Добавить транспортное средство</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Госномер *</label>
                        <input type="text" name="госномер" required>
                    </div>
                    <div class="form-group">
                        <label>Тип ТС *</label>
                        <select name="тип_id" required>
                            <option value="">-- Выберите --</option>
                            {types_options}
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Марка *</label>
                        <input type="text" name="марка" required>
                    </div>
                    <div class="form-group">
                        <label>Модель *</label>
                        <input type="text" name="модель" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Цвет</label>
                        <input type="text" name="цвет">
                    </div>
                    <div class="form-group">
                        <label>Год выпуска</label>
                        <input type="number" name="год" min="1990" max="2026">
                    </div>
                </div>
                <div class="form-actions">
                    <a href="/admin/vehicles" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Создать</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Добавить ТС', content, current_user)

@app.route('/admin/vehicles/edit/<int:vehicle_id>', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_vehicles_edit(vehicle_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        госномер = request.form.get('госномер')
        тип_id = request.form.get('тип_id')
        марка = request.form.get('марка')
        модель = request.form.get('модель')
        цвет = request.form.get('цвет')
        год = request.form.get('год')
        статус = request.form.get('статус')
        состояние = request.form.get('состояние')
        
        cursor.execute('''
            UPDATE транспортные_средства 
            SET госномер = %s, ид_тип_средства = %s, марка = %s, модель = %s,
                цвет = %s, год_выпуска = %s, статус = %s, состояние = %s
            WHERE ид_средство = %s
        ''', (госномер, тип_id, марка, модель, цвет, год, статус, состояние, vehicle_id))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'ТС "{госномер}" успешно обновлено!', 'success')
        return redirect(url_for('admin_vehicles'))
    
    cursor.execute('SELECT * FROM транспортные_средства WHERE ид_средство = %s', (vehicle_id,))
    vehicle = cursor.fetchone()
    
    cursor.execute('SELECT ид_тип_средства, наименование FROM типы_средств_доставки ORDER BY наименование')
    types = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not vehicle:
        flash('ТС не найдено', 'error')
        return redirect(url_for('admin_vehicles'))
    
    types_options = ''
    for t in types:
        selected = 'selected' if vehicle['ид_тип_средства'] == t['ид_тип_средства'] else ''
        types_options += f'<option value="{t["ид_тип_средства"]}" {selected}>{t["наименование"]}</option>'
    
    content = f'''
        <h2 class="page-title">✏️ Редактировать ТС #{vehicle_id}</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Госномер *</label>
                        <input type="text" name="госномер" value="{vehicle['госномер']}" required>
                    </div>
                    <div class="form-group">
                        <label>Тип ТС *</label>
                        <select name="тип_id" required>
                            {types_options}
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Марка *</label>
                        <input type="text" name="марка" value="{vehicle['марка']}" required>
                    </div>
                    <div class="form-group">
                        <label>Модель *</label>
                        <input type="text" name="модель" value="{vehicle['модель']}" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Цвет</label>
                        <input type="text" name="цвет" value="{vehicle['цвет'] or ''}">
                    </div>
                    <div class="form-group">
                        <label>Год выпуска</label>
                        <input type="number" name="год" value="{vehicle['год_выпуска'] or ''}" min="1990" max="2026">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Статус</label>
                        <select name="статус">
                            <option value="свободно" {'selected' if vehicle['статус'] == 'свободно' else ''}>Свободно</option>
                            <option value="занято" {'selected' if vehicle['статус'] == 'занято' else ''}>Занято</option>
                            <option value="на_ремонте" {'selected' if vehicle['статус'] == 'на_ремонте' else ''}>На ремонте</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Состояние</label>
                        <select name="состояние">
                            <option value="исправен" {'selected' if vehicle['состояние'] == 'исправен' else ''}>Исправен</option>
                            <option value="требует ремонта" {'selected' if vehicle['состояние'] == 'требует ремонта' else ''}>Требует ремонта</option>
                            <option value="неисправен" {'selected' if vehicle['состояние'] == 'неисправен' else ''}>Неисправен</option>
                        </select>
                    </div>
                </div>
                <div class="form-actions">
                    <a href="/admin/vehicles" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Сохранить</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Редактировать ТС', content, current_user)

@app.route('/admin/vehicles/delete/<int:vehicle_id>', methods=['POST'])
@login_required
@admin_required
def admin_vehicles_delete(vehicle_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute('DELETE FROM транспортные_средства WHERE ид_средство = %s', (vehicle_id,))
        conn.commit()
        flash(f'ТС #{vehicle_id} успешно удалено!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка удаления: связанные записи существуют', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('admin_vehicles'))

# ========== ADMIN CRUD: ORDERS ==========

@app.route('/admin/orders')
@login_required
@admin_required
def admin_orders():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT г.ид_груз, г.номер_груза, к.название AS клиент,
               г.вес_кг, г.объем_куб_м, с.наименование AS статус
        FROM грузы г
        LEFT JOIN статусы_заказов ст ON г.ид_статус = ст.ид_статус
        LEFT JOIN клиенты к ON г.ид_клиент = к.ид_клиент
        LEFT JOIN статусы_заказов с ON г.ид_статус = с.ид_статус
        ORDER BY г.дата_создания DESC
    ''')
    orders = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for o in orders:
        status_class = 'success' if 'доставлен' in (o['статус'] or '').lower() else 'info'
        table_rows += f'''
        <tr>
            <td>{o['ид_груз']}</td>
            <td><strong>{o['номер_груза']}</strong></td>
            <td>{o['клиент'] or '-'}</td>
            <td>{o['вес_кг']} кг</td>
            <td>{o['объем_куб_м'] or '-'} м³</td>
            <td><span class="badge badge-{status_class}">{o['статус'] or '-'}</span></td>
            <td class="actions">
                <a href="/admin/orders/edit/{o['ид_груз']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/orders/delete/{o['ид_груз']}" style="display:inline" onsubmit="return confirmDelete('груз', {o['ид_груз']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">📦 Управление заказами (грузами)</h2>
            <a href="/admin/orders/create" class="btn btn-success">➕ Добавить груз</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Номер груза</th>
                    <th>Клиент</th>
                    <th>Вес</th>
                    <th>Объем</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление заказами', content, current_user)



# ============= СОЗДАНИЕ ЗАКАЗА =============
@app.route('/admin/orders/create', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_orders_create():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        клиент_id = request.form.get('клиент_id')
        склад_отправки_id = request.form.get('склад_отправки_id')
        склад_доставки_id = request.form.get('склад_доставки_id')
        вес = request.form.get('вес')
        объем = request.form.get('объем')
        описание = request.form.get('описание')
        
        try:
            cursor.execute('''
                INSERT INTO грузы (ид_клиент, ид_склад_отправки, ид_склад_доставки, 
                                   вес_кг, объем_куб_м, описание_груза, статус)
                VALUES (%s, %s, %s, %s, %s, %s, 'ожидает отправки')
            ''', (клиент_id, склад_отправки_id, склад_доставки_id, вес, объем, описание))
            conn.commit()
            flash('Заказ успешно создан!', 'success')
            return redirect(url_for('admin_orders'))
        except Exception as e:
            conn.rollback()
            flash(f'Ошибка при создании заказа: {str(e)}', 'error')
    
    # GET - показываем форму
    cursor.execute('SELECT ид_клиент, название FROM клиенты WHERE статус = %s ORDER BY название', ('активный',))
    clients = cursor.fetchall()
    
    cursor.execute("SELECT ід_склад, название FROM склады WHERE статус = 'работает' ORDER BY название")
    warehouses = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    clients_options = ''.join([f'<option value="{c["ид_клиент"]}">{c["название"]}</option>' for c in clients])
    warehouses_options = ''.join([f'<option value="{w["ид_склад"]}">{w["название"]}</option>' for w in warehouses])
    
    content = f'''
        <h2 class="page-title">➕ Создание заказа</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-group">
                    <label>Клиент *</label>
                    <select name="клиент_id" required>
                        <option value="">-- Выберите клиента --</option>
                        {clients_options}
                    </select>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Склад отправки *</label>
                        <select name="склад_отправки_id" required>
                            <option value="">-- Выберите склад --</option>
                            {warehouses_options}
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Склад доставки *</label>
                        <select name="склад_доставки_id" required>
                            <option value="">-- Выберите склад --</option>
                            {warehouses_options}
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Вес (кг) *</label>
                        <input type="number" step="0.01" name="вес" required>
                    </div>
                    <div class="form-group">
                        <label>Объем (м³) *</label>
                        <input type="number" step="0.01" name="объем" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Описание груза</label>
                    <textarea name="описание" rows="3"></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-success">✅ Создать заказ</button>
                    <a href="/admin/orders" class="btn btn-danger">❌ Отмена</a>
                </div>
            </form>
        </div>
    '''
    return render_page('Создание заказа', content, current_user)

@app.route('/admin/orders/edit/<int:order_id>', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_orders_edit(order_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        номер = request.form.get('номер')
        клиент_id = request.form.get('клиент_id')
        вес = request.form.get('вес')
        объем = request.form.get('объем')
        описание = request.form.get('описание')
        статус_id = request.form.get('статус_id')
        
        cursor.execute('''
            UPDATE грузы 
            SET номер_груза = %s, ид_клиент = %s, вес_кг = %s, объем_куб_м = %s,
                описание = %s, ид_статус = %s
            WHERE ид_груз = %s
        ''', (номер, клиент_id, вес, объем, описание, статус_id, order_id))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Груз "{номер}" успешно обновлён!', 'success')
        return redirect(url_for('admin_orders'))
    
    cursor.execute('SELECT * FROM грузы WHERE ид_груз = %s', (order_id,))
    order = cursor.fetchone()
    
    cursor.execute('SELECT ид_клиент, название FROM клиенты ORDER BY название')
    clients = cursor.fetchall()
    
    cursor.execute('SELECT ид_статус, наименование FROM статусы_заказов ORDER BY порядок_сортировки')
    statuses = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not order:
        flash('Груз не найден', 'error')
        return redirect(url_for('admin_orders'))
    
    clients_options = ''
    for c in clients:
        selected = 'selected' if order['ид_клиент'] == c['ид_клиент'] else ''
        clients_options += f'<option value="{c["ид_клиент"]}" {selected}>{c["название"]}</option>'
    
    statuses_options = ''
    for s in statuses:
        selected = 'selected' if order['ид_статус'] == s['ид_статус'] else ''
        statuses_options += f'<option value="{s["ид_статус"]}" {selected}>{s["наименование"]}</option>'
    
    content = f'''
        <h2 class="page-title">✏️ Редактировать груз #{order_id}</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Номер груза *</label>
                        <input type="text" name="номер" value="{order['номер_груза']}" required>
                    </div>
                    <div class="form-group">
                        <label>Клиент *</label>
                        <select name="клиент_id" required>
                            {clients_options}
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Вес (кг) *</label>
                        <input type="number" step="0.01" name="вес" value="{order['вес_кг']}" required>
                    </div>
                    <div class="form-group">
                        <label>Объем (м³)</label>
                        <input type="number" step="0.01" name="объем" value="{order['объем_куб_м'] or ''}">
                    </div>
                </div>
                <div class="form-group">
                    <label>Описание</label>
                    <textarea name="описание" rows="3">{order['описание'] or ''}</textarea>
                </div>
                <div class="form-group">
                    <label>Статус</label>
                    <select name="статус_id">
                        {statuses_options}
                    </select>
                </div>
                <div class="form-actions">
                    <a href="/admin/orders" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Сохранить</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Редактировать груз', content, current_user)

@app.route('/admin/orders/delete/<int:order_id>', methods=['POST'])
@login_required
@admin_required
def admin_orders_delete(order_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute('DELETE FROM грузы WHERE ид_груз = %s', (order_id,))
        conn.commit()
        flash(f'Груз #{order_id} успешно удалён!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка удаления: связанные записи существуют', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('admin_orders'))

# ========== ADMIN CRUD: USERS ==========

@app.route('/admin/users')
@login_required
@admin_required
def admin_users():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT id_пользователя, имя_пользователя, полное_имя, email, роль, активен
        FROM пользователи
        ORDER BY полное_имя
    ''')
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for u in users:
        status_class = 'success' if u['активен'] else 'danger'
        status_text = 'Активен' if u['активен'] else 'Заблокирован'
        table_rows += f'''
        <tr>
            <td>{u['id_пользователя']}</td>
            <td><strong>{u['имя_пользователя']}</strong></td>
            <td>{u['полное_имя']}</td>
            <td>{u['email'] or '-'}</td>
            <td><span class="badge badge-info">{u['роль']}</span></td>
            <td><span class="badge badge-{status_class}">{status_text}</span></td>
            <td class="actions">
                <a href="/admin/users/edit/{u['id_пользователя']}" class="btn btn-edit">✏️</a>
                <form method="POST" action="/admin/users/delete/{u['id_пользователя']}" style="display:inline" onsubmit="return confirmDelete('пользователя', {u['id_пользователя']})">
                    <button type="submit" class="btn btn-danger">🗑️</button>
                </form>
            </td>
        </tr>
        '''
    
    content = f'''
        <div class="toolbar">
            <h2 class="page-title">👔 Управление пользователями</h2>
            <a href="/admin/users/create" class="btn btn-success">➕ Добавить пользователя</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Логин</th>
                    <th>ФИО</th>
                    <th>Email</th>
                    <th>Роль</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="7" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Управление пользователями', content, current_user)

@app.route('/admin/users/create', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_users_create():
    if request.method == 'POST':
        логин = request.form.get('логин')
        полное_имя = request.form.get('полное_имя')
        email = request.form.get('email')
        роль = request.form.get('роль')
        пароль = request.form.get('пароль')
        
        if not all([логин, полное_имя, роль, пароль]):
            flash('Все основные поля обязательны', 'error')
            return redirect(url_for('admin_users_create'))
        
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Проверка уникальности логина
        cursor.execute('SELECT 1 FROM пользователи WHERE имя_пользователя = %s', (логин,))
        if cursor.fetchone():
            flash('Пользователь с таким логином уже существует', 'error')
            cursor.close()
            conn.close()
            return redirect(url_for('admin_users_create'))
        
        пароль_хеш = generate_password_hash(пароль)
        
        cursor.execute('''
            INSERT INTO пользователи (имя_пользователя, полное_имя, email, роль, пароль_хеш)
            VALUES (%s, %s, %s, %s, %s)
        ''', (логин, полное_имя, email, роль, пароль_хеш))
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Пользователь "{логин}" успешно создан!', 'success')
        return redirect(url_for('admin_users'))
    
    content = '''
        <h2 class="page-title">➕ Добавить пользователя</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Логин *</label>
                        <input type="text" name="логин" required>
                    </div>
                    <div class="form-group">
                        <label>ФИО *</label>
                        <input type="text" name="полное_имя" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email">
                    </div>
                    <div class="form-group">
                        <label>Роль *</label>
                        <select name="роль" required>
                            <option value="администратор">Администратор</option>
                            <option value="менеджер">Менеджер</option>
                            <option value="кладовщик">Кладовщик</option>
                            <option value="диспетчер">Диспетчер</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Пароль *</label>
                    <input type="password" name="пароль" required minlength="6">
                </div>
                <div class="form-actions">
                    <a href="/admin/users" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Создать</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Добавить пользователя', content, current_user)

@app.route('/admin/users/edit/<int:user_id>', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_users_edit(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        логин = request.form.get('логин')
        полное_имя = request.form.get('полное_имя')
        email = request.form.get('email')
        роль = request.form.get('роль')
        активен = request.form.get('активен') == 'true'
        пароль = request.form.get('пароль')
        
        if пароль:
            пароль_хеш = generate_password_hash(пароль)
            cursor.execute('''
                UPDATE пользователи 
                SET имя_пользователя = %s, полное_имя = %s, email = %s, роль = %s, активен = %s, пароль_хеш = %s
                WHERE id_пользователя = %s
            ''', (логин, полное_имя, email, роль, активен, пароль_хеш, user_id))
        else:
            cursor.execute('''
                UPDATE пользователи 
                SET имя_пользователя = %s, полное_имя = %s, email = %s, роль = %s, активен = %s
                WHERE id_пользователя = %s
            ''', (логин, полное_имя, email, роль, активен, user_id))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        flash(f'Пользователь "{логин}" успешно обновлён!', 'success')
        return redirect(url_for('admin_users'))
    
    cursor.execute('SELECT * FROM пользователи WHERE id_пользователя = %s', (user_id,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if not user:
        flash('Пользователь не найден', 'error')
        return redirect(url_for('admin_users'))
    
    content = f'''
        <h2 class="page-title">✏️ Редактировать пользователя #{user_id}</h2>
        <div class="form-box">
            <form method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Логин *</label>
                        <input type="text" name="логин" value="{user['имя_пользователя']}" required>
                    </div>
                    <div class="form-group">
                        <label>ФИО *</label>
                        <input type="text" name="полное_имя" value="{user['полное_имя']}" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="{user['email'] or ''}">
                    </div>
                    <div class="form-group">
                        <label>Роль *</label>
                        <select name="роль" required>
                            <option value="администратор" {'selected' if user['роль'] == 'администратор' else ''}>Администратор</option>
                            <option value="менеджер" {'selected' if user['роль'] == 'менеджер' else ''}>Менеджер</option>
                            <option value="кладовщик" {'selected' if user['роль'] == 'кладовщик' else ''}>Кладовщик</option>
                            <option value="диспетчер" {'selected' if user['роль'] == 'диспетчер' else ''}>Диспетчер</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Новый пароль (оставьте пустым, чтобы не менять)</label>
                    <input type="password" name="пароль" minlength="6">
                </div>
                <div class="form-group">
                    <label>Статус</label>
                    <select name="активен">
                        <option value="true" {'selected' if user['активен'] else ''}>Активен</option>
                        <option value="false" {'selected' if not user['активен'] else ''}>Заблокирован</option>
                    </select>
                </div>
                <div class="form-actions">
                    <a href="/admin/users" class="btn btn-danger">Отмена</a>
                    <button type="submit" class="btn btn-success">Сохранить</button>
                </div>
            </form>
        </div>
    '''
    return render_page('Редактировать пользователя', content, current_user)

@app.route('/admin/users/delete/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def admin_users_delete(user_id):
    if user_id == current_user.id:
        flash('Нельзя удалить самого себя!', 'error')
        return redirect(url_for('admin_users'))
    
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute('DELETE FROM пользователи WHERE id_пользователя = %s', (user_id,))
        conn.commit()
        flash(f'Пользователь #{user_id} успешно удалён!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Ошибка удаления: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('admin_users'))

# ========== VIEW-ONLY PAGES ==========
@app.route('/orders')
@login_required
@require_permission('orders', 'read')
def orders():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT 
            г.ид_груз,
            г.описание,
            г.вес_кг,
            г.объем_куб_м,
            ст.наименование,
            г.дата_создания,
            к.название as клиент
        FROM грузы г
        LEFT JOIN статусы_заказов ст ON г.ид_статус = ст.ид_статус
        LEFT JOIN клиенты к ON г.ид_клиент = к.ид_клиент
        ORDER BY г.дата_создания DESC
    ''')
    orders_list = cursor.fetchall()
    cursor.close()
    conn.close()
    
    user_role = current_user.role
    can_create = user_role == 'администратор' or 'create' in PERMISSIONS.get(user_role, {}).get('orders', [])
    can_edit = user_role == 'администратор' or 'update' in PERMISSIONS.get(user_role, {}).get('orders', [])
    can_delete = user_role == 'администратор' or 'delete' in PERMISSIONS.get(user_role, {}).get('orders', [])
    
    content = f"""
    <h1>📦 Заказы</h1>
    {'<a href="/admin/orders/create" style="display:inline-block;padding:10px 20px;background:#27ae60;color:white;text-decoration:none;border-radius:5px;margin-bottom:20px">➕ Создать заказ</a>' if can_create else ''}
    <table>
        <tr>
            <th>ID</th><th>Клиент</th><th>Описание</th><th>Вес</th><th>Объем</th><th>Статус</th><th>Дата</th>
            {'<th>Действия</th>' if can_edit or can_delete else ''}
        </tr>
    """
    
    for order in orders_list:
        actions = ""
        if can_edit:
            actions += f'<a href="/admin/orders/edit/{order["ид_груз"]}" style="margin-right:10px;color:#3498db">✏️ Изменить</a>'
        if can_delete:
            actions += f'<a href="#" onclick="if(confirm(\'Удалить?\')){{fetch(\'/admin/orders/delete/{order["ид_груз"]}\',{{method:\'POST\'}}).then(()=>location.reload())}}; return false;" style="color:#e74c3c">🗑️ Удалить</a>'
        
        status_colors = {'ожидает': '#f39c12', 'в пути': '#3498db', 'доставлен': '#27ae60', 'отменен': '#e74c3c'}
        status_color = status_colors.get(order['наименование'], '#95a5a6')
        
        content += f"""
        <tr>
            <td>{order['ид_груз']}</td>
            <td>{order.get('клиент', '-')}</td>
            <td>{order['описание']}</td>
            <td>{order.get('вес', '-')} кг</td>
            <td>{order.get('объем', '-')} м³</td>
            <td><span style="padding:5px 10px;background:{status_color};color:white;border-radius:5px;font-size:12px">{order['наименование']}</span></td>
            <td>{order['дата_создания'].strftime('%d.%m.%Y') if order.get('дата_создания') else '-'}</td>
            {'<td>' + actions + '</td>' if actions else ''}
        </tr>
        """
    
    content += "</table>"
    return render_page('Заказы', content, current_user)

@app.route('/routes')
@login_required
@require_permission('routes', 'read')
def routes():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM маршруты ORDER BY ид_маршрут')
    routes_list = cursor.fetchall()
    cursor.close()
    conn.close()
    
    user_role = current_user.role
    can_create = user_role == 'администратор' or 'create' in PERMISSIONS.get(user_role, {}).get('routes', [])
    can_edit = user_role == 'администратор' or 'update' in PERMISSIONS.get(user_role, {}).get('routes', [])
    can_delete = user_role == 'администратор' or 'delete' in PERMISSIONS.get(user_role, {}).get('routes', [])
    
    content = f"""
    <h1>🗺️ Маршруты</h1>
    {'<a href="/admin/routes/create" style="display:inline-block;padding:10px 20px;background:#27ae60;color:white;text-decoration:none;border-radius:5px;margin-bottom:20px">➕ Создать маршрут</a>' if can_create else ''}
    <table>
        <tr>
            <th>ID</th><th>Название</th><th>Статус</th>
            {'<th>Действия</th>' if can_edit or can_delete else ''}
        </tr>
    """
    
    for route in routes_list:
        actions = ""
        if can_edit:
            actions += f'<a href="/admin/routes/edit/{route["ид_маршрут"]}" style="margin-right:10px;color:#3498db">✏️ Изменить</a>'
        if can_delete:
            actions += f'<a href="#" onclick="if(confirm(\'Удалить?\')){{fetch(\'/admin/routes/delete/{route["ид_маршрут"]}\',{{method:\'POST\'}}).then(()=>location.reload())}}; return false;" style="color:#e74c3c">🗑️ Удалить</a>'
        
        content += f"""
        <tr>
            <td>{route['ид_маршрут']}</td>
            <td><strong>{route.get('наименование', 'N/A')}</strong></td>
            <td><span style="padding:5px 10px;background:{'#27ae60' if route['статус'] == 'активный' else '#95a5a6'};color:white;border-radius:5px;font-size:12px">{route['статус']}</span></td>
            {'<td>' + actions + '</td>' if actions else ''}
        </tr>
        """
    
    content += "</table>"
    return render_page('Маршруты', content, current_user)

@app.route('/warehouses')
@login_required
@require_permission('warehouses', 'read')
def warehouses():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM склады ORDER BY ид_склад')
    warehouses_list = cursor.fetchall()
    cursor.close()
    conn.close()
    
    user_role = current_user.role
    can_create = user_role == 'администратор' or 'create' in PERMISSIONS.get(user_role, {}).get('warehouses', [])
    can_edit = user_role == 'администратор' or 'update' in PERMISSIONS.get(user_role, {}).get('warehouses', [])
    can_delete = user_role == 'администратор' or 'delete' in PERMISSIONS.get(user_role, {}).get('warehouses', [])
    
    content = f"""
    <h1>🏭 Склады</h1>
    {'<a href="/admin/warehouses/create" style="display:inline-block;padding:10px 20px;background:#27ae60;color:white;text-decoration:none;border-radius:5px;margin-bottom:20px">➕ Создать склад</a>' if can_create else ''}
    <table>
        <tr>
            <th>ID</th><th>Название</th><th>Адрес</th><th>Общая площадь</th><th>Свободная площадь</th><th>Занято</th>
            {'<th>Действия</th>' if can_edit or can_delete else ''}
        </tr>
    """
    
    for warehouse in warehouses_list:
        actions = ""
        if can_edit:
            actions += f'<a href="/admin/warehouses/edit/{warehouse["ид_склад"]}" style="margin-right:10px;color:#3498db">✏️ Обновить</a>'
        if can_delete:
            actions += f'<a href="#" onclick="if(confirm(\'Удалить?\')){{fetch(\'/admin/warehouses/delete/{warehouse["ид_склад"]}\',{{method:\'POST\'}}).then(()=>location.reload())}}; return false;" style="color:#e74c3c">🗑️ Удалить</a>'
        
        общая = warehouse.get('общая_площадь', 0) or 0
        свободная = warehouse.get('свободная_площадь', 0) or 0
        занято_процент = int(((общая - свободная) / общая * 100)) if общая > 0 else 0
        
        content += f"""
        <tr>
            <td>{warehouse['ид_склад']}</td>
            <td><strong>{warehouse['название']}</strong></td>
            <td>{warehouse.get('адрес', '-')}</td>
            <td>{общая} м²</td>
            <td>{свободная} м²</td>
            <td>
                <div style="width:100px;background:#ecf0f1;border-radius:10px;overflow:hidden;height:20px">
                    <div style="width:{занято_процент}%;background:{'#e74c3c' if занято_процент > 80 else '#3498db'};height:100%;display:flex;align-items:center;justify-content:center;color:white;font-size:11px">{занято_процент}%</div>
                </div>
            </td>
            {'<td>' + actions + '</td>' if actions else ''}
        </tr>
        """
    
    content += "</table>"
    return render_page('Склады', content, current_user)


@app.route('/vehicles')
@login_required
@require_permission('vehicles', 'read')
def vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM транспортные_средства ORDER BY ид_средство')
    vehicles_list = cursor.fetchall()
    cursor.close()
    conn.close()
    
    user_role = current_user.role
    can_create = user_role == 'администратор' or 'create' in PERMISSIONS.get(user_role, {}).get('vehicles', [])
    can_edit = user_role == 'администратор' or 'update' in PERMISSIONS.get(user_role, {}).get('vehicles', [])
    can_delete = user_role == 'администратор' or 'delete' in PERMISSIONS.get(user_role, {}).get('vehicles', [])
    
    content = f"""
    <h1>🚛 Транспорт</h1>
    {'<a href="/admin/vehicles/create" style="display:inline-block;padding:10px 20px;background:#27ae60;color:white;text-decoration:none;border-radius:5px;margin-bottom:20px">➕ Добавить транспорт</a>' if can_create else ''}
    <table>
        <tr>
            <th>ID</th><th>Гос. номер</th><th>Марка</th><th>Модель</th><th>Грузоподъемность</th><th>Статус</th>
            {'<th>Действия</th>' if can_edit or can_delete else ''}
        </tr>
    """
    
    for vehicle in vehicles_list:
        actions = ""
        if can_edit:
            actions += f'<a href="/admin/vehicles/edit/{vehicle["ид_средство"]}" style="margin-right:10px;color:#3498db">✏️ Изменить</a>'
        if can_delete:
            actions += f'<a href="#" onclick="if(confirm(\'Удалить?\')){{fetch(\'/admin/vehicles/delete/{vehicle["ид_средство"]}\',{{method:\'POST\'}}).then(()=>location.reload())}}; return false;" style="color:#e74c3c">🗑️ Удалить</a>'
        
        status_colors = {'свободно': '#27ae60', 'в рейсе': '#3498db', 'на ремонте': '#e74c3c'}
        status_color = status_colors.get(vehicle['статус'], '#95a5a6')
        
        content += f"""
        <tr>
            <td>{vehicle['ид_средство']}</td>
            <td><strong>{vehicle['госномер']}</strong></td>
            <td>{vehicle['марка']}</td>
            <td>{vehicle.get('модель', '-')}</td>
            <td>{vehicle.get('грузоподъемность', '-')} т</td>
            <td><span style="padding:5px 10px;background:{status_color};color:white;border-radius:5px;font-size:12px">{vehicle['статус']}</span></td>
            {'<td>' + actions + '</td>' if actions else ''}
        </tr>
        """
    
    content += "</table>"
    return render_page('Транспорт', content, current_user)


@app.route('/clients')
@login_required
@require_permission('clients', 'read')
def clients():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    # ИСПРАВЛЕНО: правильные имена колонок из БД
    cursor.execute('''
        SELECT 
            ид_клиент,
            название,
            тип_клиента,
            контактный_телефон,
            электронная_почта,
            адрес_регистрации,
            инн,
            кпп,
            статус,
            дата_создания
        FROM клиенты 
        ORDER BY ид_клиент
    ''')
    clients_list = cursor.fetchall()
    cursor.close()
    conn.close()
    
    # Проверяем права на создание
    user_role = current_user.role
    can_create = user_role == 'администратор' or 'create' in PERMISSIONS.get(user_role, {}).get('clients', [])
    can_edit = user_role == 'администратор' or 'update' in PERMISSIONS.get(user_role, {}).get('clients', [])
    can_delete = user_role == 'администратор' or 'delete' in PERMISSIONS.get(user_role, {}).get('clients', [])
    
    content = f"""
    <h1>👥 Клиенты</h1>
    {'<a href="/admin/clients/create" style="display:inline-block;padding:10px 20px;background:#27ae60;color:white;text-decoration:none;border-radius:5px;margin-bottom:20px">➕ Создать клиента</a>' if can_create else ''}
    <table>
        <tr>
            <th>ID</th>
            <th>Название</th>
            <th>Тип</th>
            <th>Телефон</th>
            <th>Email</th>
            <th>ИНН</th>
            <th>Адрес</th>
            <th>Статус</th>
            {'<th>Действия</th>' if can_edit or can_delete else ''}
        </tr>
    """
    
    for client in clients_list:
        actions = ""
        if can_edit:
            actions += f'<a href="/admin/clients/edit/{client["ид_клиент"]}" style="margin-right:10px;color:#3498db">✏️ Изменить</a>'
        if can_delete:
            actions += f'<a href="#" onclick="if(confirm(\'Удалить клиента {client["название"]}?\')){{fetch(\'/admin/clients/delete/{client["ид_клиент"]}\',{{method:\'POST\'}}).then(()=>location.reload())}}; return false;" style="color:#e74c3c">🗑️ Удалить</a>'
        
        content += f"""
        <tr>
            <td>{client['ид_клиент']}</td>
            <td><strong>{client['название']}</strong></td>
            <td>{client.get('тип_клиента', '-')}</td>
            <td>{client.get('контактный_телефон', '-')}</td>
            <td>{client.get('электронная_почта', '-')}</td>
            <td>{client.get('инн', '-')}</td>
            <td>{client.get('адрес_регистрации', '-') or '-'}</td>
            <td><span style="padding:5px 10px;background:{'#27ae60' if client['статус'] == 'активный' else '#95a5a6'};color:white;border-radius:5px;font-size:12px">{client['статус']}</span></td>
            {'<td>' + actions + '</td>' if actions else ''}
        </tr>
        """
    
    content += "</table>"
    return render_page('Клиенты', content, current_user)



@app.route('/employees')
@login_required
@require_permission('users', 'read')
def employees():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('''
        SELECT 
            п.id_пользователя, п.имя_пользователя, п.полное_имя, п.email,
            п.роль, п.активен, п.дата_создания::date, п.последний_вход::date
        FROM пользователи п
        ORDER BY п.полное_имя
    ''')
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    
    table_rows = ''
    for row in rows:
        status_class = 'success' if row['активен'] else 'danger'
        status_text = 'Активен' if row['активен'] else 'Неактивен'
        table_rows += f'''
        <tr>
            <td>{row['id_пользователя']}</td>
            <td><strong>{row['имя_пользователя']}</strong></td>
            <td>{row['полное_имя']}</td>
            <td>{row['email'] or '-'}</td>
            <td><span class="badge badge-info">{row['роль']}</span></td>
            <td><span class="badge badge-{status_class}">{status_text}</span></td>
            <td>{row['дата_создания']}</td>
            <td>{row['последний_вход'] or 'Никогда'}</td>
        </tr>
        '''
    
    content = f'''
        <h2 class="page-title">👔 Сотрудники (Пользователи)</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Логин</th>
                    <th>ФИО</th>
                    <th>Email</th>
                    <th>Роль</th>
                    <th>Статус</th>
                    <th>Дата создания</th>
                    <th>Последний вход</th>
                </tr>
            </thead>
            <tbody>
                {table_rows or '<tr><td colspan="8" style="text-align:center">Нет данных</td></tr>'}
            </tbody>
        </table>
    '''
    return render_page('Сотрудники', content, current_user)



# ========================================
# УПРАВЛЕНИЕ ГОРОДАМИ (Админ)
# ========================================
@app.route('/admin/cities', methods=['GET', 'POST'])
@login_required
@admin_required
def admin_cities():
    """Управление городами"""
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        action = request.form.get('action')
        
        if action == 'add':
            название = request.form.get('название')
            регион = request.form.get('регион')
            население = request.form.get('население')
            
            cursor.execute("""
                INSERT INTO города (название, регион, население)
                VALUES (%s, %s, %s)
            """, (название, регион, население))
            conn.commit()
            flash('Город успешно добавлен!', 'success')
            
        elif action == 'delete':
            ід_город = request.form.get('ід_город')
            cursor.execute("DELETE FROM города WHERE ід_город = %s", (ід_город,))
            conn.commit()
            flash('Город удален!', 'info')
    
    cursor.execute("SELECT * FROM города ORDER BY название")
    cities = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    html = f'''
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Управление городами</title>
        <style>
            body {{ font-family: Arial; margin: 20px; }}
            .form-group {{ margin: 10px 0; }}
            input, button {{ padding: 8px; margin: 5px; }}
            table {{ border-collapse: collapse; width: 100%; margin-top: 20px; }}
            th, td {{ border: 1px solid #ddd; padding: 12px; text-align: left; }}
            th {{ background: #4CAF50; color: white; }}
            .btn-delete {{ background: #f44336; color: white; border: none; cursor: pointer; }}
        </style>
    </head>
    <body>
        <h1>🏙️ Управление городами</h1>
        <a href="/admin">← Назад в админку</a>
        
        <h2>Добавить новый город</h2>
        <form method="POST">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <input type="text" name="название" placeholder="Название города" required>
            </div>
            <div class="form-group">
                <input type="text" name="регион" placeholder="Регион/Область">
            </div>
            <div class="form-group">
                <input type="number" name="население" placeholder="Население">
            </div>
            <button type="submit">Добавить город</button>
        </form>
        
        <h2>Список городов</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Название</th>
                <th>Регион</th>
                <th>Население</th>
                <th>Действие</th>
            </tr>
            {''.join([f"""
            <tr>
                <td>{city['ід_город']}</td>
                <td>{city['название']}</td>
                <td>{city.get('регион', 'N/A')}</td>
                <td>{city.get('население', 'N/A')}</td>
                <td>
                    <form method="POST" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="ід_город" value="{city['ід_город']}">
                        <button type="submit" class="btn-delete" onclick="return confirm('Удалить город?')">Удалить</button>
                    </form>
                </td>
            </tr>
            """ for city in cities])}
        </table>
    </body>
    </html>
    '''
    return html



# ============================================================
# ML PREDICTIONS API
# ============================================================

@app.route('/api/ml/predict_delivery_time', methods=['POST'])
@login_required
def predict_delivery_time():
    try:
        from ml_service.delivery_time_predictor import DeliveryTimePredictor
        
        data = request.get_json()
        distance = float(data.get('distance_km'))
        weight = float(data.get('weight_kg'))
        volume = float(data.get('volume_m3'))
        vehicle = data.get('vehicle_type', 'Грузовик')
        
        predictor = DeliveryTimePredictor()
        predictor.load()
        
        days = predictor.predict(distance, weight, volume, vehicle)
        hours = days * 24
        
        return jsonify({
            'success': True,
            'prediction': {
                'days': round(days, 2),
                'hours': round(hours, 1),
                'vehicle_type': vehicle
            }
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/ml/recommend_vehicle', methods=['POST'])
@login_required
def recommend_vehicle():
    try:
        from ml_service.vehicle_selector import VehicleSelector
        
        data = request.get_json()
        weight = float(data.get('weight_kg'))
        volume = float(data.get('volume_m3'))
        distance = float(data.get('distance_km'))
        
        selector = VehicleSelector()
        selector.load()
        
        vehicle, recommendations = selector.predict(weight, volume, distance)
        
        return jsonify({
            'success': True,
            'recommended_vehicle': vehicle,
            'alternatives': recommendations
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/ml/demo')
@login_required
def ml_demo_page():
    return render_template('ml_demo.html')



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

