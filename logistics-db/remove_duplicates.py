#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Читаем исходный файл
with open('webapp/app.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"📄 Исходный файл: {len(lines)} строк")

# Находим все определения функций admin_*
import re

function_positions = {}  # {имя_функции: [номера_строк]}

for i, line in enumerate(lines, start=1):
    # Ищем @app.route с admin
    if '@app.route(' in line and '/admin/' in line:
        # Следующая строка должна быть def
        if i < len(lines):
            next_line = lines[i]  # i уже на 1 больше индекса
            match = re.search(r'^def (admin_\w+)\(', next_line)
            if match:
                func_name = match.group(1)
                if func_name not in function_positions:
                    function_positions[func_name] = []
                function_positions[func_name].append(i)

# Находим дубли
duplicates = {name: positions for name, positions in function_positions.items() if len(positions) > 1}

if duplicates:
    print("\n🔍 НАЙДЕННЫЕ ДУБЛИ:")
    for func_name, positions in sorted(duplicates.items()):
        print(f"  {func_name}: строки {positions}")
    
    # Находим МИНИМАЛЬНУЮ строку второго вхождения любого дубля
    first_duplicate_line = min(positions[1] for positions in duplicates.values())
    
    print(f"\n✂️ ОБРЕЗАЕМ с строки: {first_duplicate_line}")
    
    # Берем строки ДО первого дубля
    cutoff_index = first_duplicate_line - 1
    new_lines = lines[:cutoff_index]
    
    # Убираем trailing пустые строки
    while new_lines and new_lines[-1].strip() == '':
        new_lines.pop()
    
    # Добавляем финальную часть
    new_lines.append("\n\n")
    new_lines.append("if __name__ == '__main__':\n")
    new_lines.append("    app.run(host='0.0.0.0', port=5000, debug=True)\n")
    
    print(f"📝 Новый файл: {len(new_lines)} строк")
    
    # Создаем бэкап
    with open('webapp/app.py.backup_before_dedup', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    # Сохраняем новый файл
    with open('webapp/app.py', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print("✅ ДУБЛИ УДАЛЕНЫ!")
    print(f"   Было: {len(lines)} строк")
    print(f"   Стало: {len(new_lines)} строк")
    print(f"   Бэкап: webapp/app.py.backup_before_dedup")
else:
    print("✅ ДУБЛЕЙ НЕ НАЙДЕНО!")

