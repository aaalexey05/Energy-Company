// ═══════════════════════════════════════════════════════════════
// Logistics 5NF - Главный JavaScript файл
// ═══════════════════════════════════════════════════════════════

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    console.log('Logistics 5NF initialized');

    // Автоматическое скрытие алертов
    initAutoHideAlerts();

    // Инициализация tooltips
    initTooltips();

    // Подсветка активного пункта меню
    highlightActiveMenu();

    // Анимация карточек
    animateCards();
});

// ═══════════════════════════════════════════════════════════════
// АЛЕРТЫ
// ═══════════════════════════════════════════════════════════════

/**
 * Автоматическое скрытие алертов через 5 секунд
 */
function initAutoHideAlerts() {
    const alerts = document.querySelectorAll('.alert');

    alerts.forEach(function(alert) {
        // Добавляем анимацию появления
        alert.classList.add('fade-in');

        // Автоматическое скрытие
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
}

/**
 * Показать алерт программно
 */
function showAlert(message, type = 'info') {
    const alertHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;

    const container = document.querySelector('.container-fluid');
    if (container) {
        const div = document.createElement('div');
        div.className = 'row mt-3';
        div.innerHTML = `<div class="col-md-8 offset-md-2">${alertHTML}</div>`;
        container.insertBefore(div, container.firstChild);

        // Автоматическое скрытие
        setTimeout(function() {
            div.remove();
        }, 5000);
    }
}

// ═══════════════════════════════════════════════════════════════
// TOOLTIPS И POPOVERS
// ═══════════════════════════════════════════════════════════════

/**
 * Инициализация Bootstrap tooltips
 */
function initTooltips() {
    const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// ═══════════════════════════════════════════════════════════════
// НАВИГАЦИЯ
// ═══════════════════════════════════════════════════════════════

/**
 * Подсветка активного пункта меню
 */
function highlightActiveMenu() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(function(link) {
        const href = link.getAttribute('href');
        if (href && currentPath.includes(href)) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
}

// ═══════════════════════════════════════════════════════════════
// АНИМАЦИИ
// ═══════════════════════════════════════════════════════════════

/**
 * Анимация появления карточек
 */
function animateCards() {
    const cards = document.querySelectorAll('.stat-card, .card');

    cards.forEach(function(card, index) {
        card.style.opacity = '0';
        setTimeout(function() {
            card.classList.add('fade-in');
            card.style.opacity = '1';
        }, index * 100);
    });
}

// ═══════════════════════════════════════════════════════════════
// ПОДТВЕРЖДЕНИЯ
// ═══════════════════════════════════════════════════════════════

/**
 * Подтверждение удаления
 */
function confirmDelete(message = 'Вы уверены, что хотите удалить?') {
    return confirm(message);
}

/**
 * Подтверждение действия
 */
function confirmAction(message) {
    return confirm(message);
}

// ═══════════════════════════════════════════════════════════════
// РАБОТА С ФОРМАМИ
// ═══════════════════════════════════════════════════════════════

/**
 * Валидация формы
 */
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return false;

    let isValid = true;
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');

    inputs.forEach(function(input) {
        if (!input.value.trim()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
        }
    });

    return isValid;
}

/**
 * Очистка формы
 */
function clearForm(formId) {
    const form = document.getElementById(formId);
    if (form) {
        form.reset();
        form.querySelectorAll('.is-invalid').forEach(function(el) {
            el.classList.remove('is-invalid');
        });
    }
}

// ═══════════════════════════════════════════════════════════════
// ТАБЛИЦЫ
// ═══════════════════════════════════════════════════════════════

/**
 * Фильтрация таблицы
 */
function filterTable(inputId, tableId) {
    const input = document.getElementById(inputId);
    const table = document.getElementById(tableId);

    if (!input || !table) return;

    input.addEventListener('keyup', function() {
        const filter = input.value.toLowerCase();
        const rows = table.querySelectorAll('tbody tr');

        rows.forEach(function(row) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(filter) ? '' : 'none';
        });
    });
}

/**
 * Сортировка таблицы
 */
function sortTable(tableId, columnIndex, isNumeric = false) {
    const table = document.getElementById(tableId);
    if (!table) return;

    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));

    rows.sort(function(a, b) {
        const aValue = a.cells[columnIndex].textContent.trim();
        const bValue = b.cells[columnIndex].textContent.trim();

        if (isNumeric) {
            return parseFloat(aValue) - parseFloat(bValue);
        } else {
            return aValue.localeCompare(bValue, 'ru');
        }
    });

    rows.forEach(function(row) {
        tbody.appendChild(row);
    });
}

// ═══════════════════════════════════════════════════════════════
// AJAX ЗАПРОСЫ
// ═══════════════════════════════════════════════════════════════

/**
 * Простой AJAX GET запрос
 */
async function fetchData(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return await response.json();
    } catch (error) {
        console.error('Fetch error:', error);
        showAlert('Ошибка загрузки данных', 'danger');
        return null;
    }
}

/**
 * AJAX POST запрос
 */
async function postData(url, data) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return await response.json();
    } catch (error) {
        console.error('Post error:', error);
        showAlert('Ошибка отправки данных', 'danger');
        return null;
    }
}

// ═══════════════════════════════════════════════════════════════
// УТИЛИТЫ
// ═══════════════════════════════════════════════════════════════

/**
 * Форматирование даты
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Форматирование чисел
 */
function formatNumber(number) {
    return new Intl.NumberFormat('ru-RU').format(number);
}

/**
 * Debounce функция
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Экспорт функций для использования в шаблонах
window.LogisticsApp = {
    showAlert,
    confirmDelete,
    confirmAction,
    validateForm,
    clearForm,
    filterTable,
    sortTable,
    fetchData,
    postData,
    formatDate,
    formatNumber
};

console.log('Logistics 5NF JavaScript loaded successfully');
