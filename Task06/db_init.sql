DROP TABLE IF EXISTS work_records;
DROP TABLE IF EXISTS appointment_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    position TEXT NOT NULL,
    hire_date TEXT NOT NULL,
    dismissal_date TEXT,
    salary_percentage REAL NOT NULL CHECK(salary_percentage >= 0 AND salary_percentage <= 100),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'fired')),
    phone TEXT,
    email TEXT
);

CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    duration_minutes INTEGER NOT NULL CHECK(duration_minutes > 0),
    price REAL NOT NULL CHECK(price >= 0)
);

CREATE TABLE schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL CHECK(day_of_week >= 1 AND day_of_week <= 7),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    client_name TEXT NOT NULL,
    client_phone TEXT,
    appointment_date TEXT NOT NULL,
    appointment_time TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK(status IN ('scheduled', 'completed', 'cancelled')),
    total_price REAL NOT NULL DEFAULT 0 CHECK(total_price >= 0),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT
);

CREATE TABLE appointment_services (
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

CREATE TABLE work_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    work_date TEXT NOT NULL,
    work_time TEXT NOT NULL,
    revenue REAL NOT NULL CHECK(revenue >= 0),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE RESTRICT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_employees_name ON employees(name);
CREATE INDEX idx_services_name ON services(name);
CREATE INDEX idx_schedules_employee_id ON schedules(employee_id);
CREATE INDEX idx_appointments_employee_id ON appointments(employee_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_work_records_employee_id ON work_records(employee_id);
CREATE INDEX idx_work_records_date ON work_records(work_date);

INSERT INTO employees (id, name, position, hire_date, dismissal_date, salary_percentage, status, phone, email) VALUES
(1, 'Иванов Иван Иванович', 'Мастер', '2026-01-15', NULL, 25.5, 'active', '+7-900-123-45-67', 'ivanov@sto.ru'),
(2, 'Петров Петр Петрович', 'Мастер', '2026-03-20', NULL, 30.0, 'active', '+7-900-234-56-78', 'petrov@sto.ru'),
(3, 'Сидоров Сидор Сидорович', 'Мастер', '2025-11-10', '2026-10-15', 28.0, 'fired', '+7-900-345-67-89', 'sidorov@sto.ru'),
(4, 'Кузнецов Кузьма Кузьмич', 'Мастер', '2026-05-05', NULL, 27.5, 'active', '+7-900-456-78-90', 'kuznetsov@sto.ru'),
(5, 'Смирнов Семен Семенович', 'Мастер', '2025-08-12', NULL, 26.0, 'active', '+7-900-567-89-01', 'smirnov@sto.ru');

INSERT INTO services (id, name, duration_minutes, price) VALUES
(1, 'Замена масла', 30, 1500.00),
(2, 'Замена тормозных колодок', 60, 3500.00),
(3, 'Диагностика двигателя', 45, 2500.00),
(4, 'Замена фильтров', 40, 2000.00),
(5, 'Шиномонтаж', 20, 1200.00),
(6, 'Развал-схождение', 90, 4000.00),
(7, 'Ремонт подвески', 120, 8000.00),
(8, 'Замена аккумулятора', 25, 3000.00),
(9, 'Промывка системы охлаждения', 60, 2800.00),
(10, 'Замена свечей зажигания', 35, 1800.00);

INSERT INTO schedules (id, employee_id, day_of_week, start_time, end_time) VALUES
(1, 1, 1, '09:00', '18:00'),
(2, 1, 2, '09:00', '18:00'),
(3, 1, 3, '09:00', '18:00'),
(4, 1, 4, '09:00', '18:00'),
(5, 1, 5, '09:00', '18:00'),
(6, 2, 2, '10:00', '19:00'),
(7, 2, 3, '10:00', '19:00'),
(8, 2, 4, '10:00', '19:00'),
(9, 2, 5, '10:00', '19:00'),
(10, 2, 6, '10:00', '19:00'),
(11, 4, 1, '08:00', '17:00'),
(12, 4, 2, '08:00', '17:00'),
(13, 4, 3, '08:00', '17:00'),
(14, 4, 4, '08:00', '17:00'),
(15, 4, 5, '08:00', '17:00'),
(16, 5, 1, '11:00', '20:00'),
(17, 5, 2, '11:00', '20:00'),
(18, 5, 3, '11:00', '20:00'),
(19, 5, 4, '11:00', '20:00'),
(20, 5, 5, '11:00', '20:00'),
(21, 5, 6, '11:00', '16:00');

INSERT INTO appointments (id, employee_id, client_name, client_phone, appointment_date, appointment_time, status, total_price) VALUES
(1, 1, 'Волков Алексей Сергеевич', '+7-911-111-11-11', '2026-11-25', '10:00', 'completed', 4000.00),
(2, 1, 'Орлов Дмитрий Викторович', '+7-911-222-22-22', '2026-11-25', '14:00', 'completed', 5500.00),
(3, 2, 'Соколов Михаил Александрович', '+7-911-333-33-33', '2026-11-26', '11:00', 'completed', 3000.00),
(4, 2, 'Лебедев Андрей Николаевич', '+7-911-444-44-44', '2026-11-26', '15:00', 'scheduled', 8000.00),
(5, 4, 'Медведев Сергей Петрович', '+7-911-555-55-55', '2026-11-27', '09:00', 'completed', 4300.00),
(6, 5, 'Новиков Игорь Владимирович', '+7-911-666-66-66', '2026-11-27', '12:00', 'scheduled', 2500.00),
(7, 1, 'Морозов Виктор Иванович', '+7-911-777-77-77', '2026-11-28', '10:00', 'scheduled', 6800.00),
(8, 2, 'Павлов Роман Олегович', '+7-911-888-88-88', '2026-11-28', '13:00', 'scheduled', 1500.00);

INSERT INTO appointment_services (appointment_id, service_id) VALUES
(1, 6),
(2, 2),
(2, 4),
(3, 8),
(4, 7),
(5, 1),
(5, 4),
(6, 3),
(7, 2),
(7, 4),
(8, 1);

INSERT INTO work_records (id, appointment_id, employee_id, service_id, work_date, work_time, revenue) VALUES
(1, 1, 1, 6, '2026-11-25', '10:00', 4000.00),
(2, 2, 1, 2, '2026-11-25', '14:00', 3500.00),
(3, 2, 1, 4, '2026-11-25', '15:30', 2000.00),
(4, 3, 2, 8, '2026-11-26', '11:00', 3000.00),
(5, 5, 4, 1, '2026-11-27', '09:00', 1500.00),
(6, 5, 4, 4, '2026-11-27', '09:40', 2000.00),
(7, 5, 4, 10, '2026-11-27', '10:20', 800.00);

