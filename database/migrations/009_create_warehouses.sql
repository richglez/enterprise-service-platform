CREATE TABLE warehouses (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
name VARCHAR(150) NOT NULL,
location VARCHAR(255),
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ

);

CREATE TRIGGER trg_warehouses_updated_at
BEFORE UPDATE ON warehouses
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
