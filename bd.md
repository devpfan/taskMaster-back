# 📄 Resumen de Tablas – Gestor de Tareas (Base de Datos PostgreSQL)

Este documento describe la estructura de la base de datos del sistema de gestión de tareas.

---

## 🧑‍💼 `usuario` *(Usuarios del sistema)*
| Campo             | Tipo          | Clave        |
|------------------|---------------|--------------|
| id               | UUID          | PK           |
| nombre           | VARCHAR(100)  |              |
| apellido         | VARCHAR(100)  |              |
| correo           | VARCHAR(255)  | UNIQUE       |
| contrasena_hash  | TEXT          |              |
| verificado       | BOOLEAN       |              |
| activo           | BOOLEAN       |              |
| fecha_registro   | TIMESTAMP     |              |

---

## 🏢 `espacio_trabajo` *(Agrupación principal tipo organización o empresa)*
| Campo            | Tipo         | Clave                    |
|-----------------|--------------|--------------------------|
| id              | UUID         | PK                       |
| nombre          | VARCHAR(100) |                          |
| descripcion     | TEXT         |                          |
| creado_por      | UUID         | FK → usuario(id)         |
| fecha_creacion  | TIMESTAMP    |                          |

---

## 👥 `equipo` *(Grupo de usuarios dentro de un espacio de trabajo)*
| Campo        | Tipo         | Clave                            |
|-------------|--------------|----------------------------------|
| id          | UUID         | PK                               |
| nombre      | VARCHAR(100) |                                  |
| espacio_id  | UUID         | FK → espacio_trabajo(id)         |
| descripcion | TEXT         |                                  |

---

## 👤 `equipo_usuario` *(Relación entre usuarios y equipos)*
| Campo       | Tipo        | Clave                         |
|------------|-------------|-------------------------------|
| id         | UUID        | PK                            |
| equipo_id  | UUID        | FK → equipo(id)               |
| usuario_id | UUID        | FK → usuario(id)              |
| rol        | VARCHAR(50) | `ADMIN`, `EDITOR`, `LECTOR`   |

---

## 📁 `proyecto` *(Proyecto dentro de un espacio de trabajo)*
| Campo           | Tipo         | Clave                        |
|----------------|--------------|------------------------------|
| id             | UUID         | PK                           |
| espacio_id     | UUID         | FK → espacio_trabajo(id)     |
| nombre         | VARCHAR(100) |                              |
| descripcion    | TEXT         |                              |
| creado_por     | UUID         | FK → usuario(id)             |
| fecha_creacion | TIMESTAMP    |                              |

---

## 📂 `lista` *(Lista de tareas dentro de un proyecto)*
| Campo        | Tipo         | Clave                  |
|-------------|--------------|------------------------|
| id          | UUID         | PK                     |
| proyecto_id | UUID         | FK → proyecto(id)      |
| nombre      | VARCHAR(100) |                        |
| descripcion | TEXT         |                        |

---

## ✅ `tarea` *(Tarea individual)*
| Campo             | Tipo         | Clave                 |
|------------------|--------------|-----------------------|
| id               | UUID         | PK                    |
| lista_id         | UUID         | FK → lista(id)        |
| nombre           | VARCHAR(200) |                       |
| descripcion      | TEXT         |                       |
| estado           | VARCHAR(50)  |                       |
| prioridad        | VARCHAR(20)  |                       |
| tipo             | VARCHAR(50)  |                       |
| fecha_vencimiento| DATE         |                       |
| fecha_creacion   | TIMESTAMP    |                       |
| fecha_activacion | DATE         |                       |
| creada_por       | UUID         | FK → usuario(id)      |

---

## 🔄 `subtarea` *(Subtarea dependiente de una tarea)*
| Campo      | Tipo         | Clave              |
|-----------|--------------|--------------------|
| id        | UUID         | PK                 |
| tarea_id  | UUID         | FK → tarea(id)     |
| nombre    | VARCHAR(200) |                    |
| completada| BOOLEAN      |                    |

---

## 📎 `tarea_usuario` *(Usuarios asignados a tareas)*
| Campo       | Tipo | Clave                     |
|------------|------|---------------------------|
| id         | UUID | PK                        |
| tarea_id   | UUID | FK → tarea(id)            |
| usuario_id | UUID | FK → usuario(id)          |

---

## 🏷️ `etiqueta` *(Etiquetas personalizadas para tareas)*
| Campo  | Tipo         | Clave |
|--------|--------------|-------|
| id     | UUID         | PK    |
| nombre | VARCHAR(50)  |       |
| color  | VARCHAR(20)  |       |

---

## 🏷️ `tarea_etiqueta` *(Relación entre tareas y etiquetas)*
| Campo       | Tipo | Clave                         |
|------------|------|-------------------------------|
| id         | UUID | PK                            |
| tarea_id   | UUID | FK → tarea(id)                |
| etiqueta_id| UUID | FK → etiqueta(id)             |

---

## 💬 `comentario` *(Comentarios dentro de una tarea)*
| Campo      | Tipo      | Clave                    |
|-----------|-----------|--------------------------|
| id        | UUID      | PK                       |
| tarea_id  | UUID      | FK → tarea(id)           |
| usuario_id| UUID      | FK → usuario(id)         |
| texto     | TEXT      |                          |
| fecha     | TIMESTAMP |                          |

---

## 📎 `archivo` *(Archivos adjuntos a tareas)*
| Campo           | Tipo         | Clave                  |
|----------------|--------------|------------------------|
| id             | UUID         | PK                     |
| tarea_id       | UUID         | FK → tarea(id)         |
| nombre_original| VARCHAR(255) |                        |
| ruta_archivo   | TEXT         |                        |
| subido_por     | UUID         | FK → usuario(id)       |
| fecha_subida   | TIMESTAMP    |                        |

---

## ⏱️ `registro_tiempo` *(Control de tiempo sobre tareas)*
| Campo         | Tipo         | Clave                        |
|--------------|--------------|------------------------------|
| id           | UUID         | PK                           |
| tarea_id     | UUID         | FK → tarea(id)               |
| usuario_id   | UUID         | FK → usuario(id)             |
| fecha        | DATE         |                              |
| hora_inicio  | TIMESTAMP    |                              |
| hora_fin     | TIMESTAMP    |                              |
| duracion     | INTERVAL     |                              |
| tipo_registro| VARCHAR(20)  | `MANUAL`, `TEMPORIZADOR`     |
| comentario   | TEXT         |                              |

---

## 📥 `carga_masiva` *(Historial de cargas masivas de tareas)*
| Campo            | Tipo     | Clave                        |
|------------------|----------|------------------------------|
| id               | UUID     | PK                           |
| espacio_id       | UUID     | FK → espacio_trabajo(id)     |
| usuario_id       | UUID     | FK → usuario(id)             |
| nombre_archivo   | TEXT     |                              |
| fecha_subida     | TIMESTAMP|                              |
| total_tareas     | INT      |                              |
| tareas_validas   | INT      |                              |
| tareas_rechazadas| INT      |                              |
| errores_json     | TEXT     |                              |

---

## ⏳ `tarea_precargada_log` *(Activaciones programadas de tareas precargadas)*
| Campo                | Tipo      | Clave               |
|----------------------|-----------|---------------------|
| id                   | UUID      | PK                  |
| tarea_id             | UUID      | FK → tarea(id)      |
| fecha_programada     | DATE      |                     |
| activada             | BOOLEAN   |                     |
| fecha_activacion_real| TIMESTAMP |                     |

---

## 🔔 `notificacion` *(Notificaciones a usuarios)*
| Campo           | Tipo      | Clave                    |
|----------------|-----------|--------------------------|
| id             | UUID      | PK                       |
| usuario_id     | UUID      | FK → usuario(id)         |
| titulo         | VARCHAR(200)|                         |
| mensaje        | TEXT      |                          |
| tipo           | VARCHAR(50)|                          |
| leida          | BOOLEAN   |                          |
| origen_tarea_id| UUID      | FK → tarea(id)           |
| fecha          | TIMESTAMP|                           |

---

## 📜 `actividad` *(Registro de acciones del usuario)*
| Campo       | Tipo     | Clave                    |
|------------|----------|--------------------------|
| id         | UUID     | PK                       |
| usuario_id | UUID     | FK → usuario(id)         |
| tipo       | VARCHAR(50)|                         |
| entidad    | TEXT     |                          |
| entidad_id | UUID     |                          |
| descripcion| TEXT     |                          |
| fecha      | TIMESTAMP|                          |
