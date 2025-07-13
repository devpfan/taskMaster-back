## 📄 Database Schema – Task Management System



---

### 👤 `user` *(System users)*
| Field             | Type          | Key    |
|------------------|---------------|--------|
| id               | UUID          | PK     |
| first_name       | VARCHAR(100)  |        |
| last_name        | VARCHAR(100)  |        |
| identifier       | VARCHAR(50)   |        |
| email            | VARCHAR(255)  | UNIQUE |
| password_hash    | TEXT          |        |
| global_role      | VARCHAR(20) CHECK (global_role IN ('SUPERADMIN', 'USER')) DEFAULT 'USER' |
| verified         | BOOLEAN       |        |
| active           | BOOLEAN       |        |
| registered_at    | TIMESTAMP     |        |

---

### 🏢 `workspace` *(Top-level organizational unit)*
| Field         | Type         | Key                     |
|---------------|--------------|--------------------------|
| id            | UUID         | PK                       |
| name          | VARCHAR(100) |                          |
| description   | TEXT         |                          |
| created_by    | UUID         | FK → user(id)         |
| created_at    | TIMESTAMP    |                          |

---

### 👥 `workspace_user` *(User membership and roles in a workspace)*
| Field        | Type        | Key                                      |
|--------------|-------------|------------------------------------------|
| id           | UUID        | PK                                       |
| workspace_id | UUID        | FK → workspace(id)                    |
| user_id      | UUID        | FK → user(id)                         |
| role         | VARCHAR(20) CHECK (role IN ('ADMIN', 'MEMBER'))        |

---

### 📁 `project` *(Project within a workspace)*
| Field         | Type         | Key                     |
|---------------|--------------|--------------------------|
| id            | UUID         | PK                       |
| workspace_id  | UUID         | FK → workspace(id)     |
| name          | VARCHAR(100) |                          |
| description   | TEXT         |                          |
| created_by    | UUID         | FK → user(id)         |
| created_at    | TIMESTAMP    |                          |

---

### 📂 `task_list` *(Task list inside a project)*
| Field        | Type         | Key                  |
|--------------|--------------|----------------------|
| id           | UUID         | PK                   |
| project_id   | UUID         | FK → project(id)   |
| name         | VARCHAR(100) |                      |
| description  | TEXT         |                      |

---

### ✅ `task` *(Individual task)*
| Field             | Type         | Key                |
|------------------|--------------|--------------------|
| id               | UUID         | PK                 |
| task_list_id     | UUID         | FK → task_list(id) |
| name             | VARCHAR(200) |                    |
| description      | TEXT         |                    |
| status           | VARCHAR(50)  |                    |
| priority         | VARCHAR(20)  |                    |
| type             | VARCHAR(50)  |                    |
| due_date         | DATE         |                    |
| created_at       | TIMESTAMP    |                    |
| activation_date  | DATE         |                    |
| created_by       | UUID         | FK → user(id)   |

---

### 🔄 `subtask` *(Dependent subtask)*
| Field       | Type         | Key               |
|-------------|--------------|-------------------|
| id          | UUID         | PK                |
| task_id     | UUID         | FK → task(id)  |
| name        | VARCHAR(200) |                   |
| completed   | BOOLEAN      |                   |

---

### 👤 `task_user` *(Users assigned to tasks)*
| Field      | Type | Key                    |
|-----------|------|------------------------|
| id        | UUID | PK                     |
| task_id   | UUID | FK → task(id)        |
| user_id   | UUID | FK → user(id)       |

---

### 🏷️ `tag` *(Custom task labels)*
| Field  | Type         | Key |
|--------|--------------|-----|
| id     | UUID         | PK  |
| name   | VARCHAR(50)  |     |
| color  | VARCHAR(20)  |     |

---

### 🏷️ `task_tag` *(Relation between tasks and tags)*
| Field     | Type | Key                  |
|-----------|------|----------------------|
| id        | UUID | PK                   |
| task_id   | UUID | FK → task(id)      |
| tag_id    | UUID | FK → tag(id)       |

---

### 💬 `comment` *(Comments inside a task)*
| Field     | Type      | Key                |
|-----------|-----------|--------------------|
| id        | UUID      | PK                 |
| task_id   | UUID      | FK → task(id)   |
| user_id   | UUID      | FK → user(id)  |
| content   | TEXT      |                    |
| created_at| TIMESTAMP |                    |

---

### 📎 `attachment` *(Files attached to a task)*
| Field         | Type         | Key                  |
|---------------|--------------|----------------------|
| id            | UUID         | PK                   |
| task_id       | UUID         | FK → task(id)     |
| original_name | VARCHAR(255) |                      |
| file_path     | TEXT         |                      |
| uploaded_by   | UUID         | FK → user(id)    |
| uploaded_at   | TIMESTAMP    |                      |

---

### ⏱️ `time_entry` *(Time tracking for tasks)*
| Field        | Type         | Key                           |
|--------------|--------------|-------------------------------|
| id           | UUID         | PK                            |
| task_id      | UUID         | FK → task(id)             |
| user_id      | UUID         | FK → user(id)             |
| date         | DATE         |                               |
| start_time   | TIMESTAMP    |                               |
| end_time     | TIMESTAMP    |                               |
| duration     | INTERVAL     |                               |
| entry_type   | VARCHAR(20)  | `MANUAL`, `TIMER`             |
| comment      | TEXT         |                               |

---

### 📥 `bulk_upload` *(Mass task upload history)*
| Field             | Type      | Key                        |
|-------------------|-----------|-----------------------------|
| id                | UUID      | PK                          |
| workspace_id      | UUID      | FK → workspace(id)       |
| user_id           | UUID      | FK → user(id)           |
| filename          | TEXT      |                             |
| uploaded_at       | TIMESTAMP|                             |
| total_tasks       | INT       |                             |
| valid_tasks       | INT       |                             |
| rejected_tasks    | INT       |                             |
| error_log         | TEXT      |                             |

---

### ⏳ `scheduled_task_log` *(Scheduled task activations)*
| Field              | Type      | Key               |
|--------------------|-----------|-------------------|
| id                 | UUID      | PK                |
| task_id            | UUID      | FK → task(id)  |
| scheduled_date     | DATE      |                   |
| activated          | BOOLEAN   |                   |
| actual_activation  | TIMESTAMP |                   |

---

### 🔔 `notification` *(User notifications)*
| Field         | Type      | Key                   |
|---------------|-----------|------------------------|
| id            | UUID      | PK                    |
| user_id       | UUID      | FK → user(id)     |
| title         | VARCHAR(200) |                      |
| message       | TEXT      |                        |
| type          | VARCHAR(50)|                        |
| read          | BOOLEAN   |                        |
| origin_task_id| UUID      | FK → task(id)      |
| created_at    | TIMESTAMP |                        |

---

### 📜 `activity_log` *(System activity registry)*
| Field       | Type      | Key                |
|-------------|-----------|--------------------|
| id          | UUID      | PK                 |
| user_id     | UUID      | FK → user(id)   |
| action_type | VARCHAR(50)|                    |
| entity      | TEXT      |                    |
| entity_id   | UUID      |                    |
| description | TEXT      |                    |
| created_at  | TIMESTAMP |                    |

