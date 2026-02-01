# ═══════════════════════════════════════════════════════════════
# Logistics 5NF - Manager Routes
# ═══════════════════════════════════════════════════════════════

from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from functools import wraps
from models import get_db_connection, Statistics, Cargo, Reports


bp = Blueprint('manager', __name__, url_prefix='/manager')


# ═══════════════════════════════════════════════════════════════
# ДЕКОРАТОР ПРОВЕРКИ РОЛИ
# ═══════════════════════════════════════════════════════════════

def manager_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Менеджер по заказам':
            flash('Доступ запрещен. Требуются права менеджера.', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function


# ═══════════════════════════════════════════════════════════════
# МАРШРУТЫ
# ═══════════════════════════════════════════════════════════════

@bp.route('/dashboard')
@login_required
@manager_required
def dashboard():
    """Дашборд менеджера"""

    active_orders = Statistics.get_active_orders()
    today_orders = Statistics.get_today_orders()

    return render_template('manager/dashboard.html',
                         active_orders=active_orders,
                         today_orders=today_orders)


@bp.route('/orders')
@login_required
@manager_required
def orders():
    """Список заказов"""

    status_filter = request.args.get('status', '')

    # Получение статусов для фильтра
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT наименование 
                FROM статусы_заказов 
                ORDER BY порядок_сортировки
            """)
            statuses = cur.fetchall()

    # Получение грузов
    if status_filter:
        cargos = Cargo.get_by_status(status_filter)
    else:
        cargos = Cargo.get_all(limit=50)

    return render_template('manager/orders.html', 
                         cargos=cargos, 
                         statuses=statuses)


@bp.route('/analytics')
@login_required
@manager_required
def analytics():
    """Аналитика"""

    status_distribution = Reports.get_status_distribution()

    return render_template('manager/analytics.html', 
                         status_distribution=status_distribution)
