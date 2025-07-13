-- Habilitar extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabla de usuarios
DROP TABLE IF EXISTS "user" CASCADE;
CREATE TABLE "user" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    identifier VARCHAR(50),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    global_role VARCHAR(20) CHECK (global_role IN ('SUPERADMIN', 'USER')) DEFAULT 'USER',
    verified BOOLEAN DEFAULT FALSE,
    active BOOLEAN DEFAULT TRUE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Workspaces
DROP TABLE IF EXISTS workspace CASCADE;
CREATE TABLE workspace (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_by UUID REFERENCES "user"(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Usuarios por workspace con rol
DROP TABLE IF EXISTS workspace_user CASCADE;
CREATE TABLE workspace_user (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES workspace(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'MEMBER')),
    UNIQUE (workspace_id, user_id)
);

-- Proyectos
DROP TABLE IF EXISTS project CASCADE;
CREATE TABLE project (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES workspace(id),
    name VARCHAR(100),
    description TEXT,
    created_by UUID REFERENCES "user"(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Listas de tareas
DROP TABLE IF EXISTS task_list CASCADE;
CREATE TABLE task_list (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES project(id),
    name VARCHAR(100),
    description TEXT
);

-- Tareas
DROP TABLE IF EXISTS task CASCADE;
CREATE TABLE task (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_list_id UUID REFERENCES task_list(id),
    name VARCHAR(200),
    description TEXT,
    status VARCHAR(50),
    priority VARCHAR(20),
    type VARCHAR(50),
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activation_date DATE,
    created_by UUID REFERENCES "user"(id)
);

-- Subtareas
DROP TABLE IF EXISTS subtask CASCADE;
CREATE TABLE subtask (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    name VARCHAR(200),
    completed BOOLEAN DEFAULT FALSE
);

-- Usuarios asignados a tareas
DROP TABLE IF EXISTS task_user CASCADE;
CREATE TABLE task_user (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    user_id UUID REFERENCES "user"(id)
);

-- Etiquetas
DROP TABLE IF EXISTS tag CASCADE;
CREATE TABLE tag (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50),
    color VARCHAR(20)
);

-- Relación tarea-etiqueta
DROP TABLE IF EXISTS task_tag CASCADE;
CREATE TABLE task_tag (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    tag_id UUID REFERENCES tag(id)
);

-- Comentarios
DROP TABLE IF EXISTS comment CASCADE;
CREATE TABLE comment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    user_id UUID REFERENCES "user"(id),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Archivos adjuntos
DROP TABLE IF EXISTS attachment CASCADE;
CREATE TABLE attachment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    original_name VARCHAR(255),
    file_path TEXT,
    uploaded_by UUID REFERENCES "user"(id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Registros de tiempo
DROP TABLE IF EXISTS time_entry CASCADE;
CREATE TABLE time_entry (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    user_id UUID REFERENCES "user"(id),
    date DATE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INTERVAL,
    entry_type VARCHAR(20) CHECK (entry_type IN ('MANUAL', 'TIMER')),
    comment TEXT
);

-- Cargas masivas
DROP TABLE IF EXISTS bulk_upload CASCADE;
CREATE TABLE bulk_upload (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID REFERENCES workspace(id),
    user_id UUID REFERENCES "user"(id),
    filename TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_tasks INT,
    valid_tasks INT,
    rejected_tasks INT,
    error_log TEXT
);

-- Registro de activaciones programadas
DROP TABLE IF EXISTS scheduled_task_log CASCADE;
CREATE TABLE scheduled_task_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES task(id),
    scheduled_date DATE,
    activated BOOLEAN DEFAULT FALSE,
    actual_activation TIMESTAMP
);

-- Notificaciones
DROP TABLE IF EXISTS notification CASCADE;
CREATE TABLE notification (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES "user"(id),
    title VARCHAR(200),
    message TEXT,
    type VARCHAR(50),
    read BOOLEAN DEFAULT FALSE,
    origin_task_id UUID REFERENCES task(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Registro de actividad
DROP TABLE IF EXISTS activity_log CASCADE;
CREATE TABLE activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES "user"(id),
    action_type VARCHAR(50),
    entity TEXT,
    entity_id UUID,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
