import psycopg2
from psycopg2.extras import RealDictCursor
import pandas as pd
import numpy as np

DB_CONFIG = {
    'host': 'postgres',
    'port': '5432',
    'dbname': 'logistics_5nf',
    'user': 'logistics_admin',
    'password': 'secure_password_2026'
}

def get_db_connection():
    """Подключение к БД"""
    return psycopg2.connect(**DB_CONFIG)

def fetch_delivery_data():
    """
    Собираем данные для прогноза времени доставки
    Features: расстояние, вес, объем, тип транспорта
    Target: время доставки (дни)
    """
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    query = """
    SELECT 
        m.расстояние_км,
        z.вес_кг,
        z.объем_куб_м,
        ts.грузоподъемность_кг,
        ts.объем_куб_м as объем_транспорта,
        ts.наименование as тип_транспорта,
        EXTRACT(EPOCH FROM (z.дата_доставки - z.дата_отправки)) / 86400 as время_доставки_дней
    FROM заказы z
    JOIN маршруты m ON z.ид_маршрут = m.ид_маршрут
    JOIN транспортные_средства tc ON z.ід_средство = tc.ід_средство
    JOIN типы_средств_доставки ts ON tc.ід_тип_средства = ts.ід_тип_средства
    WHERE z.дата_отправки IS NOT NULL 
      AND z.дата_доставки IS NOT NULL
      AND z.статус IN ('Доставлен', 'В пути');
    """
    
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    
    df = pd.DataFrame(data)
    return df

def fetch_vehicle_selection_data():
    """
    Собираем данные для выбора оптимального транспорта
    Features: вес груза, объем, расстояние
    Target: тип транспорта
    """
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    query = """
    SELECT 
        z.вес_кг,
        z.объем_куб_м,
        m.расстояние_км,
        ts.наименование as оптимальный_транспорт,
        ts.грузоподъемность_кг,
        ts.объем_куб_м as объем_транспорта
    FROM заказы z
    JOIN маршруты m ON z.ид_маршрут = m.ид_маршрут
    JOIN транспортные_средства tc ON z.ід_средство = tc.ід_средство
    JOIN типы_средств_доставки ts ON tc.ід_тип_средства = ts.ід_тип_средства
    WHERE z.статус IN ('Доставлен', 'В пути')
      AND z.вес_кг <= ts.грузоподъемность_кг
      AND z.объем_куб_м <= ts.объем_куб_м;
    """
    
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    
    df = pd.DataFrame(data)
    return df

def generate_synthetic_data():
    """
    Генерируем синтетические данные для обучения
    (на случай если реальных данных мало)
    """
    np.random.seed(42)
    n_samples = 200
    
    # Типы транспорта
    vehicles = ['Газель', 'Грузовик', 'Фура']
    vehicle_specs = {
        'Газель': {'capacity': 1500, 'volume': 12, 'speed': 70},
        'Грузовик': {'capacity': 10000, 'volume': 40, 'speed': 60},
        'Фура': {'capacity': 25000, 'volume': 82, 'speed': 55}
    }
    
    data = []
    for _ in range(n_samples):
        vehicle = np.random.choice(vehicles)
        specs = vehicle_specs[vehicle]
        
        # Генерируем вес и объем в пределах возможностей транспорта
        weight = np.random.uniform(100, specs['capacity'] * 0.9)
        volume = np.random.uniform(1, specs['volume'] * 0.9)
        distance = np.random.uniform(50, 2000)
        
        # Рассчитываем время доставки (упрощенная формула)
        base_time = distance / specs['speed']  # часы
        load_factor = (weight / specs['capacity']) * 0.3  # штраф за загруженность
        delivery_days = (base_time * (1 + load_factor)) / 24  # дни
        
        # Добавляем случайный шум
        delivery_days += np.random.normal(0, 0.2)
        
        data.append({
            'расстояние_км': distance,
            'вес_кг': weight,
            'объем_куб_м': volume,
            'грузоподъемность_кг': specs['capacity'],
            'объем_транспорта': specs['volume'],
            'тип_транспорта': vehicle,
            'время_доставки_дней': max(0.1, delivery_days)
        })
    
    return pd.DataFrame(data)

if __name__ == '__main__':
    print("🔍 Сбор данных из БД...")
    
    try:
        df_delivery = fetch_delivery_data()
        print(f"✅ Данные доставки: {len(df_delivery)} записей")
        print(df_delivery.head())
    except Exception as e:
        print(f"⚠️  Ошибка загрузки: {e}")
        print("📊 Генерируем синтетические данные...")
        df_delivery = generate_synthetic_data()
        print(f"✅ Синтетические данные: {len(df_delivery)} записей")
    
    print("\n" + "="*50)
    print(df_delivery.describe())