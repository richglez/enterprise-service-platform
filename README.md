# 🏢 Enterprise Service Management Platform

A web-based internal platform that centralizes the daily operations of a company — managing employees, support tickets, inventory, suppliers, and audit logs — all under a single role-based system.

> Built as a portfolio project to demonstrate real-world backend architecture using PHP, PostgreSQL, REST/SOAP APIs, and Docker.

---

## 💡 What Problem Does It Solve?

Medium-sized companies (50–200 employees) often struggle with scattered workflows:

- IT has no structured way to track reported issues
- Inventory (laptops, equipment, licenses) is managed in spreadsheets
- There's no visibility into who did what, or when
- Different teams have no shared system to coordinate

**This platform solves that** by providing a centralized system where each role (admin, manager, support, employee, auditor) interacts with the data they need — and only that data.

---

## 🔄 How It Works — Core Flow

```
Employee  →  reports a ticket (e.g. broken laptop)
              ↓
Support   →  receives it, updates status to "in progress"
              ↓
Inventory →  replacement equipment is logged
              ↓
Supplier  →  purchase order created if stock is low
              ↓
Audit Log →  every action is automatically recorded
              ↓
Manager   →  sees full summary on the analytics dashboard
```

---

## 📦 Modules & Purpose

| Module                      | What It Does                                                                |
| --------------------------- | --------------------------------------------------------------------------- |
| **Authentication**          | Login, register, sessions, password hashing. Every feature depends on this. |
| **RBAC**                    | Each role sees and does only what they're allowed to.                       |
| **Tickets**                 | Employees report issues → support resolves them → managers supervise.       |
| **Inventory**               | Track company assets (hardware, software licenses, supplies) in real time.  |
| **Suppliers**               | Manage vendors and purchase orders tied to inventory needs.                 |
| **Departments & Employees** | Organizational structure — who belongs where.                               |
| **Audit Logs**              | Immutable record of every action: who, what, when, from where.              |
| **Analytics Dashboard**     | Visual summary for managers: open tickets, low stock, team performance.     |
| **REST API**                | Modern API layer for frontend and external integrations.                    |
| **SOAP API**                | Legacy integration layer for enterprise systems that require it.            |

---

## 👥 User Roles


| Role     | Who is?                       | Access                                                                 |
| -------- | ----------------------------- | ---------------------------------------------------------------------- |
| admin    | The IT person / system owner  | Create users, change roles, access everything, configure the system    |
| manager  | Area Manager                  | View reports, monitor your team's tickets, and approve purchase orders |
| support  | Help desk / technical support | Receive tickets, handle them, update their status, and add comments    |
| employee | Regular employee              | You can only create tickets and view your own                          |
| auditor  | External accountant / auditor | Read-only — view logs, reports, and analytics; cannot make any changes |
> The "employee" role is the default (DEFAULT 'employee') because most users who sign up are regular employees.

---

## 🛠️ Tech Stack

| Layer             | Technology              |
| ----------------- | ----------------------- |
| Frontend          | HTML / CSS / jQuery     |
| Backend           | PHP (MVC Architecture)  |
| Database          | PostgreSQL              |
| Containerization  | Docker & Docker Compose |
| IDE               | Cursor                  |
| Version Control   | Git                     |
| Hosting (planned) | Render / Railway / VPS  |

---

## Project Structure
```text
enterprise-service-platform/
├── app/                        # Core application logic (MVC + Services)
│   ├── controllers/            # Request handlers and controllers
│   ├── models/                 # Database models and data layer
│   ├── services/               # Business logic and external integrations
│   └── views/                  # UI templates and presentation layer
├── config/                     # Configuration files
│   └── database.php            # Database connection settings
├── database/                   # Database management
│   ├── migrations/             # Database schema migrations
│   ├── schema/                 # SQL schema dumps or definitions
│   └── seeds/                  # Database seeders for testing data
├── docker/                     # Docker configuration files
│   └── php/
│       └── Dockerfile          # PHP environment container definition
├── public/                     # Web root (accessible to the public)
│   ├── assets/                 # Static assets
│   │   ├── css/                # Stylesheets
│   │   └── js/                 # JavaScript files
│   └── index.php               # Application entry point
├── routes/                     # Application routing definitions
├── docker-compose.yml          # Multi-container Docker orchestration
└── README.md                   # Project documentation
```

---

## 🚀 Getting Started

### Run the app

```bash
docker compose up --build
```

| Service | URL                   |
| ------- | --------------------- |
| PHP App | http://localhost:8000 |
| pgAdmin | http://localhost:5050 |

### pgAdmin credentials

```
Email:    rich@admin.com
Password: richpassword
```

---

## 🗺️ Roadmap

### ✅ Done
- [x] MVC Architecture
- [x] Database connection
- [x] Core tables: `users`, `departments`, `employees`, `tickets`, `ticket_comments`, `products`, `inventory`, `suppliers`, `audit_logs`

### 🔧 In Progress / Upcoming
- [ ] UML & ERD diagrams

### Backlog
- [ ] RBAC (Role-Based Access Control)
- [ ] Authentication system (login, register, logout, sessions, hashing)
- [ ] REST API
- [ ] Inventory module
- [ ] SOAP API
- [ ] Analytics dashboard
- [ ] Advanced setup: Nginx + PHP-FPM
