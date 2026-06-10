CREATE TABLE purchase_order_items (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
purchase_order_id UUID NOT NULL,
product_id UUID NOT NULL,
quantity INTEGER NOT NULL,
unit_price NUMERIC(12,2) NOT NULL,
total_price NUMERIC(12,2) NOT NULL,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_purchase_order_items_purchase_order
    FOREIGN KEY(purchase_order_id)
    REFERENCES purchase_orders(id),

CONSTRAINT fk_purchase_order_items_product
    FOREIGN KEY(product_id)
    REFERENCES products(id)

);

CREATE INDEX idx_purchase_order_items_purchase_order_id
ON purchase_order_items(purchase_order_id);

CREATE INDEX idx_purchase_order_items_product_id
ON purchase_order_items(product_id);
