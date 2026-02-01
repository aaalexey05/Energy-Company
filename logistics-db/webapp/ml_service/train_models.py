"""Скрипт для обучения всех моделей"""
from data_preparation import generate_synthetic_data
from delivery_time_predictor import DeliveryTimePredictor
from vehicle_selector import VehicleSelector

def train_all_models():
    """Обучить все ML модели"""
    print("=" * 60)
    print("🚀 ОБУЧЕНИЕ ВСЕХ ML МОДЕЛЕЙ")
    print("=" * 60)
    
    # Генерируем данные
    print("\n📊 Генерация данных...")
    df = generate_synthetic_data()
    print(f"✅ Сгенерировано {len(df)} записей")
    
    # Модель 1: Прогноз времени
    print("\n" + "=" * 60)
    predictor = DeliveryTimePredictor()
    predictor.train(df)
    predictor.save()
    
    # Модель 2: Выбор транспорта
    print("\n" + "=" * 60)
    selector = VehicleSelector()
    selector.train(df)
    selector.save()
    
    print("\n" + "=" * 60)
    print("✅ ВСЕ МОДЕЛИ ОБУЧЕНЫ И СОХРАНЕНЫ!")
    print("=" * 60)

if __name__ == '__main__':
    train_all_models()
