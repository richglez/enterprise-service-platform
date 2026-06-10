-- Optional full database dump, backups, onboarding, documentation
-- C:\Users\Rich\Documents\enterprise-service-platform\database\schema\complete_schema.sql


-- USER TABLE -----------------------------------------------
CREATE TYPE user_role AS ENUM (
'admin',
'manager',
'support',
'employee',
'auditor'
);


CREATE TABLE users (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	role user_role NOT NULL DEFAULT 'employee',
	is_active BOOLEAN NOT NULL DEFAULT TRUE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);


CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = NOW();
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
	BEFORE UPDATE ON users
	FOR EACH ROW
	EXECUTE FUNCTION set_updated_at();





-- DEPARTMENTS TABLE -----------------------------------------------
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_departments_deleted_at ON departments(deleted_at);

CREATE TRIGGER trg_departments_updated_at
BEFORE UPDATE ON departments
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();





-- EMPLOYEES TABLE -----------------------------------------------
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





-- TICKETS TABLE -----------------------------------------------
CREATE TYPE ticket_status AS ENUM (
'open',
'in_progress',
'pending',
'resolved',
'closed'
);

CREATE TYPE ticket_priority AS ENUM (
'low',
'medium',
'high',
'urgent'
);

CREATE TABLE tickets (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
created_by UUID NOT NULL,
assigned_to UUID,
title VARCHAR(255) NOT NULL,
description TEXT NOT NULL,
status ticket_status NOT NULL DEFAULT 'open',
priority ticket_priority NOT NULL DEFAULT 'medium',
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ,

CONSTRAINT fk_tickets_created_by
    FOREIGN KEY(created_by)
    REFERENCES users(id),

CONSTRAINT fk_tickets_assigned_to
    FOREIGN KEY(assigned_to)
    REFERENCES users(id)

);

CREATE INDEX idx_tickets_status
ON tickets(status);

CREATE INDEX idx_tickets_priority
ON tickets(priority);

CREATE INDEX idx_tickets_created_by
ON tickets(created_by);

CREATE INDEX idx_tickets_assigned_to
ON tickets(assigned_to);

CREATE INDEX idx_tickets_deleted_at
ON tickets(deleted_at);

CREATE TRIGGER trg_tickets_updated_at
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();






-- TICKETS COMMENTS TABLE -----------------------------------------------
CREATE TABLE ticket_comments (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
ticket_id UUID NOT NULL,
user_id UUID NOT NULL,
comment TEXT NOT NULL,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ,

CONSTRAINT fk_ticket_comments_ticket
    FOREIGN KEY(ticket_id)
    REFERENCES tickets(id),

CONSTRAINT fk_ticket_comments_user
    FOREIGN KEY(user_id)
    REFERENCES users(id)

);

CREATE INDEX idx_ticket_comments_ticket_id
ON ticket_comments(ticket_id);

CREATE INDEX idx_ticket_comments_user_id
ON ticket_comments(user_id);

CREATE INDEX idx_ticket_comments_deleted_at
ON ticket_comments(deleted_at);

CREATE TRIGGER trg_ticket_comments_updated_at
BEFORE UPDATE ON ticket_comments
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();





-- TICKETS STATUS HISTORY TABLE -----------------------------------------------
CREATE TABLE ticket_status_history (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
ticket_id UUID NOT NULL,
changed_by UUID NOT NULL,
old_status ticket_status,
new_status ticket_status NOT NULL,
changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_ticket_status_history_ticket
    FOREIGN KEY(ticket_id)
    REFERENCES tickets(id),

CONSTRAINT fk_ticket_status_history_changed_by
    FOREIGN KEY(changed_by)
    REFERENCES users(id)

);

CREATE INDEX idx_ticket_status_history_ticket_id
ON ticket_status_history(ticket_id);






-- AUDIT-LOGS TABLE -----------------------------------------------
CREATE TYPE audit_action AS ENUM (
'create',
'update',
'delete',
'restore',
'login',
'logout',
'status_change'
);

CREATE TABLE audit_logs (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
user_id UUID,
action audit_action NOT NULL,
entity_type VARCHAR(100) NOT NULL,
entity_id UUID,
old_values JSONB,
new_values JSONB,
ip_address INET,
user_agent TEXT,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_audit_logs_user
    FOREIGN KEY(user_id)
    REFERENCES users(id)

);

CREATE INDEX idx_audit_logs_user_id
ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_action
ON audit_logs(action);

CREATE INDEX idx_audit_logs_entity_type
ON audit_logs(entity_type);

CREATE INDEX idx_audit_logs_entity_id
ON audit_logs(entity_id);

CREATE INDEX idx_audit_logs_created_at
ON audit_logs(created_at);

-- Example Real Log
-- User Ricardo updated ticket status from open to in_progress

-- Event Tracking / Change Tracking










-- PRODUCTS TABLE -----------------------------------------------
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






-- WAREHOUSES TABLE -----------------------------------------------
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







-- INVENTORY TABLE -----------------------------------------------
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





-- INVENTORY MOVEMENTS TABLE -----------------------------------------------
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







-- SUPPLIERS TABLE -----------------------------------------------
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







-- PURCHASE-ORDER TABLE -----------------------------------------------
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






-- PURCHASE-ORDER-ITEMS TABLE -----------------------------------------------
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
