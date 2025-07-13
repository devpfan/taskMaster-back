## 📌 Resumen de Endpoints RESTful – Task Master

Este resumen cubre todos los endpoints identificados hasta ahora, organizados por módulo funcional. Se sigue una convención RESTful clara, con versionado (`/api/v1`) y buenas prácticas de nombres, verbos HTTP y jerarquía de recursos.

---

### 🧑‍💼 Users (`/api/v1/users`)

* `POST /` → Registrar nuevo usuario
* `GET /{id}` → Obtener detalle de un usuario
* `PUT /{id}` → Actualizar datos de un usuario
* `DELETE /{id}` → Eliminar usuario (soft delete o desactivación)
* `GET /` → Listar usuarios (filtros por rol, estado, verificación, etc.)

### 🔐 Authentication (`/api/v1/auth`)

* `POST /login` → Iniciar sesión
* `POST /logout` → Cerrar sesión (si aplica)
* `POST /verify` → Verificar cuenta por token
* `POST /resend-verification` → Reenviar correo de verificación

---

### 🏢 Workspaces (`/api/v1/workspaces`)

* `POST /` → Crear nuevo workspace (solo SUPERADMIN)
* `GET /{id}` → Obtener detalles de un workspace
* `PUT /{id}` → Actualizar workspace (ADMIN o SUPERADMIN)
* `DELETE /{id}` → Eliminar workspace (solo SUPERADMIN)
* `GET /` → Listar workspaces visibles para el usuario actual

### 👥 Workspace Members (`/api/v1/workspaces/{workspaceId}/users`)

* `GET /` → Listar usuarios y roles del workspace
* `POST /` → Agregar usuario al workspace con rol (ADMIN o MEMBER)
* `PUT /{userId}` → Cambiar rol del usuario en el workspace
* `DELETE /{userId}` → Quitar usuario del workspace

### 🎨 Task Statuses (`/api/v1/workspaces/{workspaceId}/task-statuses`)

* `GET /` → Listar todos los estados del workspace
* `POST /` → Crear un nuevo estado de tarea
* `PUT /{statusId}` → Editar nombre, color u orden del estado
* `DELETE /{statusId}` → Desactivar o eliminar estado de tarea

---

### 📁 Projects (`/api/v1/projects`)

* `POST /` → Crear proyecto
* `GET /{id}` → Obtener detalle del proyecto
* `PUT /{id}` → Actualizar proyecto
* `DELETE /{id}` → Eliminar proyecto
* `GET /workspace/{workspaceId}` → Listar proyectos de un workspace

### 📂 Task Lists (`/api/v1/task-lists`)

* `POST /` → Crear lista dentro de un proyecto
* `GET /{id}` → Obtener lista
* `PUT /{id}` → Actualizar lista
* `DELETE /{id}` → Eliminar lista
* `GET /project/{projectId}` → Listar listas por proyecto

---

### ✅ Tasks (`/api/v1/tasks`)

* `POST /` → Crear tarea
* `GET /{id}` → Ver tarea
* `PUT /{id}` → Editar tarea
* `DELETE /{id}` → Eliminar tarea
* `GET /list/{listId}` → Listar tareas por lista
* `GET /assigned/{userId}` → Tareas asignadas a usuario
* `GET /filter` → Buscar tareas por filtros avanzados

### 🔄 Subtasks (`/api/v1/subtasks`)

* `POST /` → Crear subtarea
* `PUT /{id}` → Actualizar subtarea
* `DELETE /{id}` → Eliminar subtarea

### 👥 Task Assignment (`/api/v1/tasks/{taskId}/users`)

* `POST /` → Asignar usuario
* `DELETE /{userId}` → Quitar usuario
* `GET /` → Ver usuarios asignados

### 🏷️ Tags (`/api/v1/workspaces/{workspaceId}/tags`)

* `POST /` → Crear etiqueta dentro del workspace
* `GET /` → Listar etiquetas del workspace
* `PUT /{id}` → Editar etiqueta
* `DELETE /{id}` → Eliminar etiqueta

### 📌 Task Tags (`/api/v1/tasks/{taskId}/tags`)

* `POST /` → Asignar etiqueta
* `DELETE /{tagId}` → Quitar etiqueta
* `GET /` → Listar etiquetas de una tarea (`/api/v1/tasks/{taskId}/tags`)
* `POST /` → Asignar etiqueta
* `DELETE /{tagId}` → Quitar etiqueta
* `GET /` → Listar etiquetas de una tarea

---

### 💬 Comments (`/api/v1/comments`)

* `POST /` → Crear comentario
* `GET /task/{taskId}` → Listar comentarios de tarea
* `DELETE /{id}` → Eliminar comentario

### 📎 Attachments (`/api/v1/attachments`)

* `POST /` → Subir archivo a tarea
* `GET /task/{taskId}` → Listar archivos
* `DELETE /{id}` → Eliminar archivo

---

### ⏱️ Time Entries (`/api/v1/time-entries`)

* `POST /` → Crear registro de tiempo
* `PUT /{id}` → Editar registro
* `GET /task/{taskId}` → Ver tiempos de una tarea
* `GET /user/{userId}` → Ver tiempos por usuario
* `DELETE /{id}` → Eliminar registro

---

### 📥 Bulk Uploads (`/api/v1/bulk-uploads`)

* `POST /` → Subir archivo de carga masiva (solo ADMIN de workspace o SUPERADMIN)
* `GET /history` → Ver historial de cargas
* `GET /detail/{id}` → Ver detalle de una carga

### ⏳ Scheduled Tasks (`/api/v1/scheduled-tasks`)

* `GET /pending` → Tareas aún no activadas
* `POST /activate/{taskId}` → Activar manualmente
* `GET /task/{taskId}` → Ver log de precarga

---

### 🔔 Notifications (`/api/v1/notifications`)

* `GET /` → Listar notificaciones del usuario
* `PUT /{id}/read` → Marcar como leída
* `DELETE /{id}` → Eliminar notificación

### 📜 Activity Log (`/api/v1/activity-log`)

* `GET /user/{userId}` → Ver historial de actividad

---

### 🧪 Utilities (optional)

* `GET /ping` → Comprobar estado del backend
* `GET /version` → Mostrar versión del sistema
