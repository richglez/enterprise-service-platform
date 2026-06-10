CREATE TYPE inventory_movement_type AS ENUM (
'purchase',
'sale',
'adjustment',
'transfer_in',
'transfer_out',
'return',
'damage'
);

CREATE TABLE inventory_movements (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
inventory_id UUID NOT NULL,
product_id UUID NOT NULL,
warehouse_id UUID NOT NULL,
user_id UUID,
movement_type inventory_movement_type NOT NULL,
quantity INTEGER NOT NULL,
reference_id UUID,
notes TEXT,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_inventory_movements_inventory
    FOREIGN KEY(inventory_id)
    REFERENCES inventory(id),

CONSTRAINT fk_inventory_movements_product
    FOREIGN KEY(product_id)
    REFERENCES products(id),

CONSTRAINT fk_inventory_movements_warehouse
    FOREIGN KEY(warehouse_id)
    REFERENCES warehouses(id),

CONSTRAINT fk_inventory_movements_user
    FOREIGN KEY(user_id)
    REFERENCES users(id)

);

CREATE INDEX idx_inventory_movements_inventory_id
ON inventory_movements(inventory_id);

CREATE INDEX idx_inventory_movements_product_id
ON inventory_movements(product_id);

CREATE INDEX idx_inventory_movements_warehouse_id
ON inventory_movements(warehouse_id);

CREATE INDEX idx_inventory_movements_user_id
ON inventory_movements(user_id);

CREATE INDEX idx_inventory_movements_type
ON inventory_movements(movement_type);

CREATE INDEX idx_inventory_movements_created_at
ON inventory_movements(created_at);
