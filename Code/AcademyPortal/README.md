# 🌸 AcademyPortal

> A full-stack Online Academy Enrollment & Management System built with **Blazor Server**, **Entity Framework Core**, and **SQLite** — designed for overseas Pakistani students.


---

## 📌 About the Project

AcademyPortal is an online academy management system that connects students, teachers, and administrators on a single platform. It was developed as a Visual Programming course project using Blazor Server with a rose-gold dark theme UI.

The system supports three distinct user roles — each with their own dedicated portal, dashboard, and feature set.

---

## 👥 User Roles

| Role | Access | Key Features |
|------|--------|-------------|
| 🎓 **Student** | `/student/login` | Register, enroll in subjects, view schedule, chat with teacher, receive notifications |
| 🏫 **Teacher** | `/teacher/login` | Register (admin approval required), manage students, set class schedules, assign meeting links, chat |
| 🔐 **Admin** | `/admin` → password: `academy2024` | Monitor students & teachers, approve teachers, manage enrollments & trial requests, send notifications |

---

## ✨ Features

### Student Portal
- Register with auto-generated roll number (e.g. `CS-2025-0001`)
- Login and access personal dashboard
- Enroll in CS subjects by semester
- View class schedule with meeting links
- Real-time chat with teacher (per subject/semester channel)
- Receive and mark notifications from admin

### Teacher Portal
- Register with qualification and subject details
- Login after admin approval
- View enrolled students for their subject
- Add class schedules (day, time, meeting link)
- Chat with students in their subject channel
- Receive notifications from admin

### Admin Panel
- Secure login (hardcoded password)
- Dashboard with live stats (students, teachers, enrollments, trials)
- Approve or remove teacher accounts
- Manage all enrollment submissions (approve/delete)
- Manage free trial requests (update status, assign meeting links)
- Send notifications to specific students, specific teachers, or everyone

---

## 📚 CS Subjects (4 Semesters)

| Semester 1 | Semester 2 |
|-----------|-----------|
| Introduction to Computing | Object Oriented Programming |
| Calculus & Analytical Geometry | Discrete Mathematics |
| English Composition | Digital Logic Design |
| Islamic Studies | Communication Skills |
| Functional English | Pakistan Studies |

| Semester 3 | Semester 4 |
|-----------|-----------|
| Data Structures & Algorithms | Operating Systems |
| Database Systems | Software Engineering |
| Computer Organization | Computer Networks |
| Linear Algebra | Visual Programming |
| Probability & Statistics | Web Technologies |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Blazor Server (Razor Components) |
| Backend | C# .NET 8.0 |
| Database | SQLite via Entity Framework Core |
| ORM | EF Core (Code-First, EnsureCreated) |
| Styling | Custom CSS (Rose Gold Dark Theme) |
| IDE | Visual Studio 2022 |

---

## 📁 Project Structure

```
AcademyPortal/
├── Components/
│   ├── Layout/
│   │   └── MainLayout.razor
│   ├── Pages/
│   │   ├── Admin/
│   │   │   ├── Login.razor
│   │   │   ├── Dashboard.razor
│   │   │   ├── Students.razor
│   │   │   ├── Teachers.razor
│   │   │   ├── Enrollments.razor
│   │   │   ├── Trials.razor
│   │   │   └── Notifications.razor
│   │   ├── Student/
│   │   │   ├── Register.razor
│   │   │   ├── Login.razor
│   │   │   └── Dashboard.razor
│   │   ├── Teacher/
│   │   │   ├── Register.razor
│   │   │   ├── Login.razor
│   │   │   └── Dashboard.razor
│   │   ├── Home.razor
│   │   ├── Enroll.razor
│   │   ├── Trial.razor
│   │   └── Contact.razor
├── Data/
│   └── ApplicationDbContext.cs
├── Models/
│   ├── Enrollment.cs
│   ├── TrialRequest.cs
│   ├── StudentUser.cs
│   ├── TeacherUser.cs
│   ├── ClassSchedule.cs
│   ├── ChatMessage.cs
│   └── Notification.cs
├── Services/
│   ├── EnrollmentService.cs
│   ├── TrialService.cs
│   ├── StudentService.cs
│   ├── TeacherService.cs
│   ├── ChatService.cs
│   ├── NotificationService.cs
│   └── ScheduleService.cs
├── wwwroot/
│   └── css/
│       └── app.css
└── Program.cs
```

---

## 🚀 Getting Started

### Prerequisites
- Visual Studio 2022
- .NET 8.0 SDK
- No external database setup needed (SQLite auto-creates)

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/121-Hina/AcademyPortal.git
cd AcademyPortal
```

**2. Open in Visual Studio**
```
File → Open → Project/Solution → AcademyPortal.sln
```

**3. Restore NuGet packages**
```
Tools → NuGet Package Manager → Package Manager Console
```
```bash
Install-Package Microsoft.EntityFrameworkCore.Sqlite
Install-Package Microsoft.EntityFrameworkCore.Tools
Install-Package Microsoft.EntityFrameworkCore.Design
```

**4. Run the project**
```
Press F5 or click the green Run button
```

The database (`academy.db`) is created automatically on first run.

---

## 🔐 Login Credentials

| Role | URL | Credential |
|------|-----|-----------|
| Admin | `/admin` | Password: `academy2024` |
| Student | `/student/login` | Register first at `/student/register` |
| Teacher | `/teacher/login` | Register + wait for admin approval |

---

## 👩‍💻 Developer

**Hina Naeem**
Roll Number: 242679
Air University — BS Computer Science
Visual Programming — Semester 4


