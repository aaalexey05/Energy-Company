#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""RBAC Patcher - автоматически добавляет RBAC в app.py"""
import re, sys

print("="*80)
print("�� RBAC PATCHER - Автоматическое добавление RBAC в app.py")
print("="*80)

try:
    with open('app.py', 'r', encoding='utf-8') as f:
        content = f.read()
    print("✅ Файл app.py прочитан")
except FileNotFoundError:
    print("❌ ОШИБКА: app.py не найден!")
    sys.exit(1)

if 'PERMISSIONS = {' in content:
    print("⚠️  RBAC уже добавлен! Пропускаю...")
else:
    print("📝 Добавляю RBAC функции...")
    rbac_code = """
# ============ RBAC PERMISSIONS ============
PERMISSIONS = {
    'администратор': {'clients': ['read', 'create', 'update', 'delete'], 'orders': ['read', 'create', 'update', 'delete'], 'routes': ['read', 'create', 'update', 'delete'], 'warehouses': ['read', 'create', 'update', 'delete'], 'vehicles': ['read', 'create', 'update', 'delete'], 'users': ['read', 'create', 'update', 'delete']},
    'менеджер': {'clients': ['read', 'create', 'update', 'delete'], 'orders': ['read', 'create', 'update', 'delete'], 'routes': ['read', 'create'], 'warehouses': ['read'], 'vehicles': ['read'], 'users': []},
    'логист': {'clients': ['read'], 'orders': ['read', 'update'], 'routes': ['read', 'create', 'update', 'delete'], 'warehouses': ['read'], 'vehicles': ['read', 'create', 'update', 'delete'], 'users': []},
    'кладовщик': {'clients': ['read'], 'orders': ['read', 'update'], 'routes': ['read'], 'warehouses': ['read', 'update'], 'vehicles': [], 'users': []},
}

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

"""
    route_match = re.search(r'(@app\.route)', content)
    if route_match:
        insert_pos = route_match.start()
        content = content[:insert_pos] + rbac_code + "\n" + content[insert_pos:]
        print("✅ RBAC функции добавлены!")

routes_to_patch = [
    (r"(@app\.route\('/clients'\)\s*@login_required)", r"\1\n@permission_required('clients', 'read')", 'clients read'),
    (r"(@app\.route\('/admin/clients/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('clients', 'create')", 'clients create'),
    (r"(@app\.route\('/admin/clients/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('clients', 'update')", 'clients edit'),
    (r"(@app\.route\('/admin/clients/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('clients', 'delete')", 'clients delete'),
    (r"(@app\.route\('/orders'\)\s*@login_required)", r"\1\n@permission_required('orders', 'read')", 'orders read'),
    (r"(@app\.route\('/admin/orders/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('orders', 'create')", 'orders create'),
    (r"(@app\.route\('/admin/orders/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('orders', 'update')", 'orders edit'),
    (r"(@app\.route\('/admin/orders/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('orders', 'delete')", 'orders delete'),
    (r"(@app\.route\('/routes'\)\s*@login_required)", r"\1\n@permission_required('routes', 'read')", 'routes read'),
    (r"(@app\.route\('/admin/routes/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('routes', 'create')", 'routes create'),
    (r"(@app\.route\('/admin/routes/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('routes', 'update')", 'routes edit'),
    (r"(@app\.route\('/admin/routes/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('routes', 'delete')", 'routes delete'),
    (r"(@app\.route\('/warehouses'\)\s*@login_required)", r"\1\n@permission_required('warehouses', 'read')", 'warehouses read'),
    (r"(@app\.route\('/admin/warehouses/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('warehouses', 'create')", 'warehouses create'),
    (r"(@app\.route\('/admin/warehouses/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('warehouses', 'update')", 'warehouses edit'),
    (r"(@app\.route\('/admin/warehouses/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('warehouses', 'delete')", 'warehouses delete'),
    (r"(@app\.route\('/vehicles'\)\s*@login_required)", r"\1\n@permission_required('vehicles', 'read')", 'vehicles read'),
    (r"(@app\.route\('/admin/vehicles/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('vehicles', 'create')", 'vehicles create'),
    (r"(@app\.route\('/admin/vehicles/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('vehicles', 'update')", 'vehicles edit'),
    (r"(@app\.route\('/admin/vehicles/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('vehicles', 'delete')", 'vehicles delete'),
    (r"(@app\.route\('/employees'\)\s*@login_required)", r"\1\n@permission_required('users', 'read')", 'employees read'),
    (r"(@app\.route\('/admin/users'\)\s*@login_required)", r"\1\n@permission_required('users', 'read')", 'admin users read'),
    (r"(@app\.route\('/admin/users/create'[^)]*\)\s*@login_required)", r"\1\n@permission_required('users', 'create')", 'users create'),
    (r"(@app\.route\('/admin/users/edit/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('users', 'update')", 'users edit'),
    (r"(@app\.route\('/admin/users/delete/<[^>]+>'[^)]*\)\s*@login_required)", r"\1\n@permission_required('users', 'delete')", 'users delete'),
    (r"(@app\.route\('/admin'\)\s*@login_required)", r"\1\n@permission_required('users', 'read')", 'admin panel'),
]

print("\n📝 Добавляю декораторы...")
patched_count = 0
for pattern, replacement, name in routes_to_patch:
    check_pattern = pattern.replace('@login_required', '@login_required.*@permission_required')
    if not re.search(check_pattern, content, re.DOTALL):
        if re.search(pattern, content, re.DOTALL):
            content = re.sub(pattern, replacement, content, flags=re.DOTALL)
            print(f"  ✅ {name}")
            patched_count += 1

print(f"\n✅ Добавлено декораторов: {patched_count}")

try:
    with open('app.py.backup', 'w', encoding='utf-8') as f:
        with open('app.py', 'r', encoding='utf-8') as orig:
            f.write(orig.read())
    print("\n💾 Создан бэкап: app.py.backup")
except: pass

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(content)

print("\n" + "="*80)
print("🎉 ГОТОВО! RBAC успешно добавлен!")
print("="*80)
print("\n🔐 Тестовые пользователи:")
print("  - admin (администратор) - все права")
print("  - manager (менеджер) - клиенты + заказы")
print("  - logist (логист) - маршруты + транспорт")
print("  - warehouse (кладовщик) - только склады")
print("\n  Пароль для всех: admin123")
print("="*80)
