CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE,
    department_id UUID,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    hire_date DATE,
    salary NUMERIC(12,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_employees_user
        FOREIGN KEY(user_id)
        REFERENCES users(id),

    CONSTRAINT fk_employees_department
        FOREIGN KEY(department_id)
        REFERENCES departments(id)
);

CREATE INDEX idx_employees_department_id
ON employees(department_id);

CREATE INDEX idx_employees_deleted_at
ON employees(deleted_at);

CREATE TRIGGER trg_employees_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
