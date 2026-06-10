CREATE TYPE purchase_order_status AS ENUM (
'draft',
'pending',
'approved',
'received',
'cancelled'
);

CREATE TABLE purchase_orders (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
supplier_id UUID NOT NULL,
created_by UUID NOT NULL,
order_number VARCHAR(100) NOT NULL UNIQUE,
status purchase_order_status NOT NULL DEFAULT 'draft',
total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
notes TEXT,
ordered_at TIMESTAMPTZ,
received_at TIMESTAMPTZ,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ,

CONSTRAINT fk_purchase_orders_supplier
    FOREIGN KEY(supplier_id)
    REFERENCES suppliers(id),

CONSTRAINT fk_purchase_orders_created_by
    FOREIGN KEY(created_by)
    REFERENCES users(id)

);

CREATE INDEX idx_purchase_orders_supplier_id
ON purchase_orders(supplier_id);

CREATE INDEX idx_purchase_orders_created_by
ON purchase_orders(created_by);

CREATE INDEX idx_purchase_orders_status
ON purchase_orders(status);

CREATE INDEX idx_purchase_orders_deleted_at
ON purchase_orders(deleted_at);

CREATE TRIGGER trg_purchase_orders_updated_at
BEFORE UPDATE ON purchase_orders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
