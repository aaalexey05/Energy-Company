from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import mean_absolute_error, r2_score
import joblib
import pandas as pd
import numpy as np

class DeliveryTimePredictor:
    """Прогноз времени доставки"""
    
    def __init__(self):
        self.model = RandomForestRegressor(
            n_estimators=100,
            max_depth=10,
            random_state=42
        )
        self.label_encoder = LabelEncoder()
        self.is_trained = False
        
    def prepare_features(self, df, fit_encoder=False):
        """Подготовка признаков"""
        # Копируем данные
        X = df.copy()
        
        # Кодируем тип транспорта
        if 'тип_транспорта' in X.columns:
            if fit_encoder:
                X['тип_транспорта_код'] = self.label_encoder.fit_transform(X['тип_транспорта'])
            else:
                X['тип_транспорта_код'] = self.label_encoder.transform(X['тип_транспорта'])
            X = X.drop('тип_транспорта', axis=1)
        
        # Создаём дополнительные признаки
        X['загруженность_по_весу'] = X['вес_кг'] / X['грузоподъемность_кг']
        X['загруженность_по_объему'] = X['объем_куб_м'] / X['объем_транспорта']
        
        return X
    
    def train(self, df):
        """Обучение модели"""
        print("🎓 Обучение модели прогноза времени доставки...")
        
        # Подготовка данных
        X = self.prepare_features(df, fit_encoder=True)
        y = df['время_доставки_дней']
        
        # Убираем целевую переменную из признаков
        if 'время_доставки_дней' in X.columns:
            X = X.drop('время_доставки_дней', axis=1)
        
        # Разделение на train/test
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        # Обучение
        self.model.fit(X_train, y_train)
        
        # Оценка
        y_pred = self.model.predict(X_test)
        mae = mean_absolute_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)
        
        print(f"✅ Модель обучена!")
        print(f"   MAE: {mae:.2f} дней")
        print(f"   R²: {r2:.3f}")
        print(f"   Важность признаков:")
        
        feature_importance = pd.DataFrame({
            'feature': X_train.columns,
            'importance': self.model.feature_importances_
        }).sort_values('importance', ascending=False)
        
        for idx, row in feature_importance.head(5).iterrows():
            print(f"      {row['feature']}: {row['importance']:.3f}")
        
        self.is_trained = True
        return mae, r2
    
    def predict(self, distance_km, weight_kg, volume_m3, vehicle_type):
        """Прогноз времени доставки"""
        if not self.is_trained:
            raise ValueError("Модель не обучена! Сначала вызовите train()")
        
        # Характеристики транспорта
        vehicle_specs = {
            'Газель': {'capacity': 1500, 'volume': 12},
            'Грузовик': {'capacity': 10000, 'volume': 40},
            'Фура': {'capacity': 25000, 'volume': 82}
        }
        
        specs = vehicle_specs.get(vehicle_type, vehicle_specs['Грузовик'])
        
        # Создаём DataFrame для предсказания
        data = pd.DataFrame([{
            'расстояние_км': distance_km,
            'вес_кг': weight_kg,
            'объем_куб_м': volume_m3,
            'грузоподъемность_кг': specs['capacity'],
            'объем_транспорта': specs['volume'],
            'тип_транспорта': vehicle_type
        }])
        
        # Подготовка признаков
        X = self.prepare_features(data, fit_encoder=False)
        
        # Предсказание
        days = self.model.predict(X)[0]
        
        return max(0.1, days)  # Минимум 0.1 дня
    
    def save(self, filepath='ml_service/models/delivery_time_model.pkl'):
        """Сохранение модели"""
        import os
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        joblib.dump({
            'model': self.model,
            'label_encoder': self.label_encoder,
            'is_trained': self.is_trained
        }, filepath)
        print(f"💾 Модель сохранена: {filepath}")
    
    def load(self, filepath='ml_service/models/delivery_time_model.pkl'):
        """Загрузка модели"""
        data = joblib.load(filepath)
        self.model = data['model']
        self.label_encoder = data['label_encoder']
        self.is_trained = data['is_trained']
        print(f"📂 Модель загружена: {filepath}")

if __name__ == '__main__':
    from data_preparation import generate_synthetic_data
    
    # Генерируем данные
    df = generate_synthetic_data()
    
    # Создаём и обучаем модель
    predictor = DeliveryTimePredictor()
    predictor.train(df)
    
    # Тестируем
    print("\n🧪 Примеры предсказаний:")
    examples = [
        (500, 800, 5, 'Газель'),
        (1000, 5000, 25, 'Грузовик'),
        (1500, 20000, 70, 'Фура')
    ]
    
    for dist, weight, vol, vehicle in examples:
        days = predictor.predict(dist, weight, vol, vehicle)
        print(f"   {vehicle} | {dist}км, {weight}кг, {vol}м³ → {days:.1f} дней")
    
    # Сохраняем
    predictor.save()

