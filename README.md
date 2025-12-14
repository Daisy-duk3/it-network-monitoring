# IT Asset Management & Network Monitoring System
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=fff)](#)
[![GitHub Repo Size](https://img.shields.io/github/repo-size/Daisy-duk3/it-network-monitoring)](#)

---

## Contents

- [Overview](#overview)
- [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
- [Scenario](#scenario)
- [Technologies Used](#technologies-used)
- [Database Structure](#database-structure)
- [Key Features & Queries](#key-features--queries)
- [Example Use Cases](#example-use-cases)
- [Status](#status)

---

## Overview
This project is a **relational database system** designed to support IT asset management and network monitoring within an organisation.

It models users, devices, incidents, and network uptime in order to:
- Track IT assets across departments
- Log and analyse network incidents
- Identify unreliable devices and problem areas
- Support maintenance and operational decision-making

---

### Entity Relationship Diagram (ERD)
![Screenshot from 2025-09-27 11-56-03.png](images/Screenshot%20from%202025-09-27%2011-56-03.png)

#### Entity Relationships
- A **User** can be assigned **multiple Devices**
- A **Device** can have **multiple Incidents**
- A **Device** can have **multiple Network Status Log entries**
- Some devices (e.g. routers, switches) are not assigned to a specific user

---

### Scenario
A user in the Finance department reports that their laptop cannot connect to the internal server.  
An incident is logged, and analysis reveals that the router in the same area has experienced multiple outages in a short period.  
Based on historical data, the system highlights the router as a recurring issue and supports the recommendation of a maintenance ticket.

---

## Technologies Used
- **Database:** MySQL (DDL, DML, joins, constraints, functions, procedures)
- **Data Modeling:** Entity-Relationship Diagram, relational design
- **Analytical Queries:** Aggregation, filtering, joins
- **Problem-Solving:** Incident tracking, uptime analysis, automated device management

---

## Database Structure

<details>
<summary><strong>Users Table</strong></summary>

| Column Name  | Data Type     | Constraints                    | Description |
|-------------|---------------|--------------------------------|------------|
| user_id     | INT           | PK, AUTO_INCREMENT             | Unique user identifier |
| first_name  | VARCHAR(50)   | NOT NULL                       | User’s first name |
| last_name   | VARCHAR(50)   | NOT NULL                       | User’s last name |
| department  | VARCHAR(100)  | NOT NULL                       | Department name |
| email       | VARCHAR(100)  | UNIQUE, NOT NULL               | User email address |

</details>

<details>
<summary><strong>Devices Table</strong></summary>

| Column Name  | Data Type     | Constraints                                   | Description |
|-------------|---------------|-----------------------------------------------|------------|
| device_id   | INT           | PK, AUTO_INCREMENT                            | Unique device identifier |
| device_name | VARCHAR(100)  | NOT NULL                                      | Device name |
| ip_address  | VARCHAR(15)   | UNIQUE, NOT NULL                              | Device IP address |
| mac_address | VARCHAR(17)   | UNIQUE, NOT NULL                              | Device MAC address |
| device_type | VARCHAR(50)   | NOT NULL, CHECK (Laptop, Server, Router, Switch, Firewall) | Type of device |
| location    | VARCHAR(100)  | NULLABLE                                      | Physical location |
| status      | VARCHAR(20)   | DEFAULT 'active', CHECK (active, offline, maintenance) | Operational status |
| user_id     | INT           | FK → Users.user_id, NULLABLE                  | Assigned user |

</details>

<details>
<summary><strong>Incidents Table</strong></summary>

| Column Name     | Data Type    | Constraints                                   | Description |
|----------------|--------------|-----------------------------------------------|------------|
| incident_id    | INT          | PK, AUTO_INCREMENT                            | Unique incident identifier |
| device_id      | INT          | FK → Devices.device_id, NOT NULL              | Affected device |
| incident_type  | VARCHAR(50)  | CHECK (network_down, security_breach, hardware_failure, maintenance) | Type of incident |
| description    | TEXT         | NULLABLE                                      | Incident details |
| reported_at    | DATETIME     | DEFAULT NOW()                                 | Time incident was reported |
| resolved_at    | DATETIME     | NULLABLE                                      | Time incident was resolved |
| severity_level | VARCHAR(10)  | CHECK (Low, Medium, High)                     | Incident severity |

</details>

<details>
<summary><strong>NetworkStatusLog Table</strong></summary>

| Column Name | Data Type | Constraints                  | Description |
|------------|-----------|------------------------------|------------|
| log_id     | INT       | PK, AUTO_INCREMENT           | Log entry ID |
| device_id  | INT       | FK → Devices.device_id       | Associated device |
| uptime     | FLOAT     | CHECK (>= 0)                 | Uptime percentage |
| downtime   | FLOAT     | CHECK (>= 0)                 | Downtime percentage |
| log_date   | DATETIME  | DEFAULT NOW()                | Log timestamp |

</details>

<details>
<summary><strong>Relationship Summary</strong></summary>

| Parent Table | Child Table         | Relationship Type |
|-------------|---------------------|-------------------|
| Users       | Devices             | One-to-Many |
| Devices     | Incidents           | One-to-Many |
| Devices     | NetworkStatusLog    | One-to-Many |

</details>

---

## Key Features & Queries

<details>
<summary><strong>User and Device Assignment</strong></summary>

- Identify which users have devices
- Identify users without assigned devices
- Dynamically assign devices to users

</details>

<details>
<summary><strong>Incident Analysis</strong></summary>

- View incidents by device, location, and type
- Detect recurring issues in specific areas
- Analyse high-severity or unresolved incidents

</details>

<details>
<summary><strong>SQL Function</strong></summary>

**`Get_Unresolved_Incident_Count()`**  
Returns the total number of incidents that have not yet been resolved.  
Supports quick operational visibility for IT teams.

</details>

<details>
<summary><strong>Stored Procedures</strong></summary>

#### `get_least_active_device`
Identifies the device with the lowest average uptime.

#### `Delete_User_Data`
Safely removes all data for a specific user, including devices, incidents, and logs.

</details>

---

## Example Use Cases
- Identifying routers with repeated outages
- Tracking downtime across departments
- Supporting maintenance planning
- Auditing unresolved incidents
- Safely removing employee data

---

## Status
This project demonstrates database design, data integrity, and analytical querying for an IT operations context.