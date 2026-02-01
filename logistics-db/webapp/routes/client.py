from flask import Blueprint, render_template, request, redirect, url_for
from flask_login import login_required, current_user
from functools import wraps
from models import Cargo

bp = Blueprint('client', __name__, url_prefix='/client')

def client_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Клиент':
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/dashboard')
@login_required
@client_required
def dashboard():
    return render_template('client/dashboard.html')

@bp.route('/track')
@login_required
@client_required
def track():
    cargo_number = request.args.get('number', '')
    cargo_info = None
    
    if cargo_number:
        cargo_info = Cargo.get_by_number(cargo_number)
    
    return render_template('client/track.html', cargo_info=cargo_info)
from flask import Blueprint, render_template, request, redirect, url_for
from flask_login import login_required, current_user
from functools import wraps
from models import Cargo

bp = Blueprint('client', __name__, url_prefix='/client')

def client_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role != 'Клиент':
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/dashboard')
@login_required
@client_required
def dashboard():
    return render_template('client/dashboard.html')

@bp.route('/track')
@login_required
@client_required
def track():
    cargo_number = request.args.get('number', '')
    cargo_info = None
    
    if cargo_number:
        cargo_info = Cargo.get_by_number(cargo_number)
    
    return render_template('client/track.html', cargo_info=cargo_info)
