from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import login_required, current_user
from functools import wraps
from models import get_db_connection

bp = Blueprint('courier', __name__, url_prefix='/courier')

def courier_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Курьер':
            flash('Доступ запрещен', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/dashboard')
@login_required
@courier_required
def dashboard():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM грузы WHERE ид_статус = 4")
            in_transit = cur.fetchone()['count']
    
    return render_template('courier/dashboard.html', in_transit=in_transit)

@bp.route('/deliveries')
@login_required
@courier_required
def deliveries():
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT g.ид_груз, g.номер_груза, k.название as клиент,
                       c1.название as от, c2.название as до,
                       st.наименование as статус, g.дата_создания
                FROM грузы g
                JOIN клиенты k ON g.ид_клиент = k.ид_клиент
                JOIN склады s1 ON g.ид_склад_отправления = s1.ид_склад
                JOIN города c1 ON s1.ид_город = c1.ид_город
                JOIN склады s2 ON g.ид_склад_назначения = s2.ид_склад
                JOIN города c2 ON s2.ид_город = c2.ид_город
                JOIN статусы_заказов st ON g.ид_статус = st.ид_статус
                WHERE g.ид_статус IN (4, 5)
                ORDER BY g.дата_создания
            """)
            deliveries = cur.fetchall()
    
    return render_template('courier/deliveries.html', deliveries=deliveries)
