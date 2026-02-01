from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import joblib
import pandas as pd
import numpy as np

class VehicleSelector:
    """Выбор оптимального транспорта"""
    
    def __init__(self):
        self.model = DecisionTreeClassifier(
            max_depth=8,
            min_samples_split=10,
            random_state=42
        )
        self.is_trained = False
        
    def train(self, df):
        """Обучение модели"""
        print("🎓 Обучение модели выбора транспорта...")
        
        # Признаки
        X = df[['вес_кг', 'объем_куб_м', 'расстояние_км']].copy()
        
        # Целевая переменная (используем тип_транспорта из синтетических данных)
        y = df['тип_транспорта']
        
        # Разделение
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        # Обучение
        self.model.fit(X_train, y_train)
        
        # Оценка
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        
        print(f"✅ Модель обучена!")
        print(f"   Accuracy: {accuracy:.3f}")
        print(f"\n📊 Отчёт по классам:")
        print(classification_report(y_test, y_pred, zero_division=0))
        
        # Важность признаков
        print("📈 Важность признаков:")
        features = ['вес_кг', 'объем_куб_м', 'расстояние_км']
        for feat, imp in zip(features, self.model.feature_importances_):
            print(f"   {feat}: {imp:.3f}")
        
        self.is_trained = True
        return accuracy
    
    def predict(self, weight_kg, volume_m3, distance_km):
        """Рекомендация транспорта"""
        if not self.is_trained:
            raise ValueError("Модель не обучена!")
        
        data = pd.DataFrame([{
            'вес_кг': weight_kg,
            'объем_куб_м': volume_m3,
            'расстояние_км': distance_km
        }])
        
        vehicle = self.model.predict(data)[0]
        
        # Получаем вероятности
        probabilities = self.model.predict_proba(data)[0]
        classes = self.model.classes_
        
        recommendations = []
        for cls, prob in zip(classes, probabilities):
            recommendations.append({
                'vehicle': cls,
                'probability': prob
            })
        
        recommendations.sort(key=lambda x: x['probability'], reverse=True)
        
        return vehicle, recommendations
    
    def save(self, filepath='ml_service/models/vehicle_selector_model.pkl'):
        """Сохранение модели"""
        import os
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        joblib.dump({
            'model': self.model,
            'is_trained': self.is_trained
        }, filepath)
        print(f"💾 Модель сохранена: {filepath}")

    def load(self, filepath='ml_service/models/vehicle_selector_model.pkl'):
        """Загрузка сохранённой модели"""
        import joblib
        data = joblib.load(filepath)
        self.model = data['model']
        self.is_trained = data['is_trained']
        print(f"📂 Модель загружена из {filepath}")

if __name__ == '__main__':
    from data_preparation import generate_synthetic_data
    
    df = generate_synthetic_data()
    
    selector = VehicleSelector()
    selector.train(df)
    
    print("\n🧪 Примеры рекомендаций:")
    examples = [
        (500, 3, 200),
        (5000, 25, 800),
        (20000, 70, 1500)
    ]
    
    for weight, volume, distance in examples:
        vehicle, recs = selector.predict(weight, volume, distance)
        print(f"\n📦 {weight}кг, {volume}м³, {distance}км")
        print(f"   ✅ Рекомендация: {vehicle}")
        print(f"   Варианты:")
        for rec in recs:
            print(f"      {rec['vehicle']}: {rec['probability']*100:.1f}%")
    
    selector.save()

