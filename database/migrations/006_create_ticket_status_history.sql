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
