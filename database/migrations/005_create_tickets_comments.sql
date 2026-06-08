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
