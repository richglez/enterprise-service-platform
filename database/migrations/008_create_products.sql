CREATE TABLE products (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
name VARCHAR(255) NOT NULL,
sku VARCHAR(100) NOT NULL UNIQUE,
description TEXT,
price NUMERIC(12,2) NOT NULL DEFAULT 0,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ

);

CREATE INDEX idx_products_sku
ON products(sku);

CREATE INDEX idx_products_is_active
ON products(is_active);

CREATE INDEX idx_products_deleted_at
ON products(deleted_at);

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
