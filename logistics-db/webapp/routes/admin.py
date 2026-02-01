# ═══════════════════════════════════════════════════════════════
# Logistics 5NF - Admin Routes
# ═══════════════════════════════════════════════════════════════

from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from functools import wraps
from models import get_db_connection, Statistics, Reports

bp = Blueprint('admin', __name__, url_prefix='/admin')

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Администратор':
            flash('Доступ запрещен. Требуются права администратора.', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/dashboard')
@login_required
@admin_required
def dashboard():
    total_cargos = Statistics.get_total_cargos()
    total_employees = Statistics.get_total_employees()
    total_clients = Statistics.get_total_clients()
    monthly_cargos = Statistics.get_monthly_cargos()
    
    return render_template('admin/dashboard.html',
                         total_cargos=total_cargos,
                         total_employees=total_employees,
                         total_clients=total_clients,
                         monthly_cargos=monthly_cargos)

@bp.route('/users')
@login_required
@admin_required
def users():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT 
                    с.ид_сотрудник,
                    с.имя,
                    с.фамилия,
                    с.email,
                    р.название as роль,
                    с.активен
                FROM сотрудники с
                JOIN роли р ON с.ид_роль = р.ид_роль
                ORDER BY с.фамилия, с.имя
            """)
            employees = cur.fetchall()
    
    return render_template('admin/users.html', employees=employees)

@bp.route('/reports')
@login_required
@admin_required
def reports():
    kpi_data = Reports.get_kpi_monthly()
    
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT k.название, COUNT(g.ид_груз) as количество_заказов
                FROM клиенты k
                LEFT JOIN грузы g ON k.ид_клиент = g.ид_клиент
                GROUP BY k.ид_клиент, k.название
                HAVING COUNT(g.ид_груз) > 0
                ORDER BY количество_заказов DESC
                LIMIT 10
            """)
            top_clients = cur.fetchall()
    
    return render_template('admin/reports.html', 
                         kpi_data=kpi_data, 
                         top_clients=top_clients)
