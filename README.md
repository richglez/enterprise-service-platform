# ENTERPRISE SERVICE MANAGMENT
A platform using PHP, JavaScript, jQuery, REST/SOAP APIs, and PostgreSQL. Implemented authentication, inventory tracking, ticketing workflows, analytics dashboards, audit logging, and API integrations using MVC architecture.

--

# Tech Stack
| **Tech**         | **Use**                                 |
| ---------------- | --------------------------------------- |
| Frontend         | HTML/CSS/jQuery                         |
| Backend          | PHP                                     |
| Database         | PostgreSQL                              |
| Docker / Compose | Php, Containerization of app + database |
| IDE              | Cursor                                  |
| Version Control  | Git                                     |
| Hosting Later    | Render/Railway/VPS                      |

---

# Starting Everything

## PHP App

Run:
```bash
docker compose up --build
```
Open:
```
http://localhost:8000
```

## pgAdmin

Open:
```
http://localhost:5050
```
```
Email: email@admin.com
Password: admin
```

---

# Models

## USER



### User Roles
| **ROLE** | **Purpose** |
| -------- | ------- |
| admin | Full system access |
| manager | Manage employees/tickets/inventory |
| support | Handle tickets/support |
| employee | Basic internal access |
| auditor | Read-only analytics/logs |

---


# Roadmap
- [x] - MVC
- [x] - Conection to Database
- [ ] - Create tables(users, departments, employees, tickets, tickets_comments, products, inventory, suppliers, audit_logs)
- [ ] - RBAC (Role-Based Access Control)
- [ ] - Authentication System(login, register, logout, sessions, password hashing, roles) everything depends on auth
- [ ] - Create database
- [ ] - Build REST API
- [ ] - Inventoty
- [ ] - Build SOAP
- [ ] - Analytics
- [ ] - Advanced Fesatures(Nginx
PHP-FPM)





