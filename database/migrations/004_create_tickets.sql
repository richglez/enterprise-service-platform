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
