CREATE TABLE inventory (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
product_id UUID NOT NULL,
warehouse_id UUID NOT NULL,
quantity INTEGER NOT NULL DEFAULT 0,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_inventory_product
    FOREIGN KEY(product_id)
    REFERENCES products(id),

CONSTRAINT fk_inventory_warehouse
    FOREIGN KEY(warehouse_id)
    REFERENCES warehouses(id),

CONSTRAINT unique_product_warehouse
    UNIQUE(product_id, warehouse_id)

);

CREATE INDEX idx_inventory_product_id
ON inventory(product_id);

CREATE INDEX idx_inventory_warehouse_id
ON inventory(warehouse_id);

CREATE TRIGGER trg_inventory_updated_at
BEFORE UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
