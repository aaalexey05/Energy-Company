from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import login_required, current_user
from functools import wraps
from models import get_db_connection

bp = Blueprint('warehouse', __name__, url_prefix='/warehouse')

def warehouse_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Кладовщик':
            flash('Доступ запрещен', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/dashboard')
@login_required
@warehouse_required
def dashboard():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT COUNT(*) FROM грузы 
                WHERE ид_статус IN (2, 3, 4)
            """)
            pending_shipments = cur.fetchone()['count']
    
    return render_template('warehouse/dashboard.html', 
                         pending_shipments=pending_shipments)

@bp.route('/inventory')
@login_required
@warehouse_required
def inventory():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT s.ид_склад, s.название, c.название as город,
                       COUNT(g.ид_груз) as количество_грузов
                FROM склады s
                JOIN города c ON s.ид_город = c.ид_город
                LEFT JOIN грузы g ON s.ид_склад = g.ид_склад_отправления
                GROUP BY s.ид_склад, s.название, c.название
                ORDER BY s.название
            """)
            warehouses = cur.fetchall()
    
    return render_template('warehouse/inventory.html', warehouses=warehouses)

@bp.route('/shipments')
@login_required
@warehouse_required
def shipments():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT g.ид_груз, g.номер_груза, k.название as клиент,
                       s.название as склад, st.наименование as статус
                FROM грузы g
                JOIN клиенты k ON g.ид_клиент = k.ид_клиент
                JOIN склады s ON g.ид_склад_отправления = s.ид_склад
                JOIN статусы_заказов st ON g.ид_статус = st.ид_статус
                WHERE g.ид_статус IN (2, 3, 4)
                ORDER BY g.дата_создания DESC
                LIMIT 50
            """)
            shipments = cur.fetchall()
    
    return render_template('warehouse/shipments.html', shipments=shipments)
