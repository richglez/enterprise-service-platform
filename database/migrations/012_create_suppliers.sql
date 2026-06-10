CREATE TABLE suppliers (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
name VARCHAR(255) NOT NULL,
contact_name VARCHAR(255),
email VARCHAR(150),
phone VARCHAR(50),
address TEXT,
website VARCHAR(255),
tax_id VARCHAR(100),
is_active BOOLEAN NOT NULL DEFAULT TRUE,
notes TEXT,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ

);

CREATE INDEX idx_suppliers_name
ON suppliers(name);

CREATE INDEX idx_suppliers_email
ON suppliers(email);

CREATE INDEX idx_suppliers_is_active
ON suppliers(is_active);

CREATE INDEX idx_suppliers_deleted_at
ON suppliers(deleted_at);

CREATE TRIGGER trg_suppliers_updated_at
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
