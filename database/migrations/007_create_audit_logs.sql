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
