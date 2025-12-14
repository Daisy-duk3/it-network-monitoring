/* IT Asset Management and Network Monitoring System
---
A user in the Finance department reports that their laptop 
is unable to connect to the internal server. An incident is 
logged. Upon review, it’s found that the router in their area 
had 3 incidents in the past week. The system recommends a 
maintenance ticket. The IT department uses the system to identify 
problem areas, track downtime, and ensure high uptime across the 
company’s internal network.*/

CREATE DATABASE ITNetworkMonitoring;
USE ITNetworkMonitoring;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    ip_address VARCHAR(15) UNIQUE NOT NULL,
    mac_address VARCHAR(17) UNIQUE NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    user_id INT,
    
    CONSTRAINT chk_device_type CHECK (device_type IN ('Laptop', 'Server', 'Router', 'Switch', 'Firewall')),
    CONSTRAINT chk_status CHECK (status IN ('active', 'offline', 'maintenance')),
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Incidents (
    incident_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    incident_type VARCHAR(50) NOT NULL,
    description TEXT,
    reported_at DATETIME NOT NULL DEFAULT NOW(),
    resolved_at DATETIME,
    severity_level VARCHAR(10),
    
    CONSTRAINT chk_incident_type CHECK (incident_type IN ('network_down', 'security_breach', 'hardware_failure', 'maintenance')),
    CONSTRAINT chk_severity CHECK (severity_level IN ('Low', 'Medium', 'High')),
    
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

CREATE TABLE NetworkStatusLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    uptime FLOAT NOT NULL CHECK (uptime >= 0),
    downtime FLOAT NOT NULL CHECK (downtime >= 0),
    log_date DATETIME NOT NULL DEFAULT NOW(),
    
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

INSERT INTO Users (first_name, last_name, department, email) VALUES
('Alice', 'Johnson', 'Finance', 'alice.johnson@company.com'),
('Bob', 'Smith', 'IT', 'bob.smith@company.com'),
('Clara', 'Williams', 'HR', 'clara.williams@company.com'),
('David', 'Brown', 'Finance', 'david.brown@company.com'),
('Eva', 'Miller', 'Operations', 'eva.miller@company.com'),
('Frank', 'Davis', 'IT', 'frank.davis@company.com'),
('Grace', 'Taylor', 'Finance', 'grace.taylor@company.com'),
('Henry', 'Wilson', 'IT', 'henry.wilson@company.com');

INSERT INTO Devices (device_name, ip_address, mac_address, device_type, location, status, user_id) VALUES
('Alice-Laptop', '192.168.1.101', '00:1A:2B:3C:4D:5E', 'Laptop', 'Finance Office', 'active', 1),
('Finance-Router-1', '192.168.1.1', '00:1A:2B:3C:4D:AA', 'Router', 'Finance Office', 'active', NULL),
('IT-Server-1', '192.168.2.10', '00:1A:2B:3C:4D:BB', 'Server', 'Data Center', 'active', 2),
('HR-Laptop-Clara', '192.168.3.101', '00:1A:2B:3C:4D:CC', 'Laptop', 'HR Office', 'active', 3),
('Ops-Switch-1', '192.168.4.20', '00:1A:2B:3C:4D:DD', 'Switch', 'Operations Floor', 'active', NULL),
('David-Laptop', '192.168.1.102', '00:1A:2B:3C:4D:EE', 'Laptop', 'Finance Office', 'active', 4),
('Eva-Desktop', '192.168.4.30', '00:1A:2B:3C:4D:FF', 'Laptop', 'Operations Floor', 'active', 5),
('IT-Firewall-1', '192.168.2.1', '00:1A:2B:3C:4D:11', 'Firewall', 'Data Center', 'active', NULL),
('Grace-Laptop', '192.168.1.103', '00:1A:2B:3C:4D:22', 'Laptop', 'Finance Office', 'active', 7),
('Henry-Laptop', '192.168.2.101', '00:1A:2B:3C:4D:33', 'Laptop', 'IT Office', 'active', 8);

INSERT INTO Incidents (device_id, incident_type, description, reported_at, resolved_at, severity_level) VALUES
(1, 'network_down', 'User in Finance unable to connect to internal server.', '2025-09-20 09:15:00', '2025-09-20 10:00:00', 'Medium'),
(2, 'network_down', 'Router outage detected in Finance office.', '2025-09-18 14:20:00', '2025-09-18 15:00:00', 'High'),
(2, 'network_down', 'Repeated router failure in Finance office.', '2025-09-19 11:00:00', '2025-09-19 12:30:00', 'High'),
(2, 'maintenance', 'Router scheduled for preventive maintenance.', '2025-09-21 08:00:00', NULL, 'Low'),
(3, 'hardware_failure', 'Server disk failure reported by monitoring system.', '2025-09-15 03:10:00', '2025-09-15 07:30:00', 'High'),
(4, 'network_down', 'HR laptop unable to access email server.', '2025-09-22 09:45:00', '2025-09-22 10:15:00', 'Low'),
(5, 'maintenance', 'Switch updated with latest firmware.', '2025-09-17 12:00:00', '2025-09-17 12:30:00', 'Low'),
(6, 'network_down', 'Laptop losing connection intermittently.', '2025-09-19 16:00:00', '2025-09-19 16:30:00', 'Medium'),
(8, 'security_breach', 'Firewall detected unusual inbound traffic.', '2025-09-23 01:00:00', NULL, 'High');

INSERT INTO NetworkStatusLog (device_id, uptime, downtime, log_date) VALUES
(1, 99.5, 0.5, '2025-09-20 23:59:59'),
(2, 92.0, 8.0, '2025-09-20 23:59:59'),
(2, 85.0, 15.0, '2025-09-21 23:59:59'),
(3, 98.7, 1.3, '2025-09-20 23:59:59'),
(5, 99.9, 0.1, '2025-09-20 23:59:59'),
(6, 97.8, 2.2, '2025-09-19 23:59:59'),
(7, 95.5, 4.5, '2025-09-20 23:59:59'),
(8, 96.2, 3.8, '2025-09-21 23:59:59'),
(9, 99.2, 0.8, '2025-09-20 23:59:59'),
(10, 97.0, 3.0, '2025-09-22 23:59:59');

-- First let's see all users with their assigned devices
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.department,
    d.device_name,
    d.device_type
FROM Users u
JOIN Devices d ON u.user_id = d.user_id
ORDER BY u.user_id;

-- Some users are without a device
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.department,
    COALESCE(d.device_name, 'No Device Assigned') AS device_name,
    COALESCE(d.device_type, 'N/A') AS device_type
FROM Users u
LEFT JOIN Devices d ON u.user_id = d.user_id
ORDER BY u.user_id;

-- Let's assign Frank a laptop
INSERT INTO Devices (device_name, ip_address, mac_address, device_type, location, status, user_id) 
VALUES
('Frank-Laptop', '192.168.2.120', '00:1A:2B:3C:4D:44', 'Laptop', 'IT Office', 'active', 6);

-- If we check now, frank has a laptop
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.department,
    d.device_name,
    d.device_type
FROM Users u
JOIN Devices d ON u.user_id = d.user_id
ORDER BY u.user_id;

-- function to count all unresolved incidents by checking if there's a resolved date
DELIMITER //

CREATE FUNCTION Get_Unresolved_Incident_Count()
RETURNS INT
DETERMINISTIC -- If the database was dynamic with changing data then this would be NOT DETERMINISTIC
BEGIN
    DECLARE unresolved_count INT;
    
    -- Count unresolved incidents
    SELECT COUNT(*) INTO unresolved_count
    FROM Incidents i
    WHERE i.resolved_at IS NULL;
    
    -- Return the count
    RETURN unresolved_count;
END //

DELIMITER ;
-- using the function
SELECT Get_Unresolved_Incident_Count();


-- Checking for the devices with the highest number of incidents
SELECT d.device_name, COUNT(i.incident_id) AS total_incidents
FROM Devices d
JOIN Incidents i ON d.device_id = i.device_id
GROUP BY d.device_name
ORDER BY total_incidents DESC;

-- procedure to check LEast active device so it checks the lowest uptime procedure
DELIMITER //

CREATE PROCEDURE get_least_active_device()
BEGIN
    SELECT d.device_name, ROUND(AVG(n.uptime), 2) AS avg_uptime
    FROM Devices d
    JOIN NetworkStatusLog n ON d.device_id = n.device_id
    GROUP BY d.device_name
    ORDER BY avg_uptime ASC
    LIMIT 1;
END//

DELIMITER ;

CALL get_least_active_device();


-- Alice Johnson can't connect with her laptop so she is going to create a ticket
INSERT INTO Incidents (device_id, incident_type, description, reported_at, severity_level)
VALUES
(1, 'network_down', 'Alice Johnson (Finance) unable to connect to internal server.', NOW(), 'Medium');

-- IT is going to review the router in her area to investigate further
INSERT INTO Incidents (device_id, incident_type, description, reported_at, resolved_at, severity_level)
VALUES
(2, 'network_down', 'Router outage detected in Finance office.', '2025-09-21 10:20:00', '2025-09-18 15:00:00', 'High'),
(2, 'network_down', 'Repeated router failure in Finance office.', '2025-09-21 10:00:00', '2025-09-19 12:30:00', 'High'),
(2, 'network_down', 'Router downtime again in Finance office.', '2025-09-21 09:45:00', '2025-09-21 10:30:00', 'High');
/*
We can see a lot of routers going down in this area, but a maintenance ticket can also be seen. We can also see a 
maintenance ticket for the router before the other router ticket so we can assume this is why. */

SELECT 
    i.incident_id,
    d.device_name,
    d.device_type,
    d.location,
    i.incident_type,
    i.description,
    i.reported_at,
    i.resolved_at,
    i.severity_level
FROM Incidents i
JOIN Devices d ON i.device_id = d.device_id
WHERE d.location = 'Finance Office'
  AND d.device_type = 'Router'
ORDER BY i.reported_at DESC;

/* Eva Miller has left the company and we need to safely remove her data
from all tables in the database. */

DELIMITER //

CREATE PROCEDURE Delete_User_Data(IN target_user_id INT)
BEGIN
    -- Step 1: Delete from NetworkStatusLog
    DELETE n
    FROM NetworkStatusLog n
    JOIN Devices d ON n.device_id = d.device_id
    WHERE d.user_id = target_user_id;

    -- Step 2: Delete from Incidents
    DELETE i
    FROM Incidents i
    JOIN Devices d ON i.device_id = d.device_id
    WHERE d.user_id = target_user_id;

    -- Step 3: Delete from Devices
    DELETE FROM Devices
    WHERE user_id = target_user_id;

    -- Step 4: Delete from Users
    DELETE FROM Users
    WHERE user_id = target_user_id;

END //

DELIMITER ;

-- to call stored procedure to delete Ava Miller's data
CALL Delete_User_Data(5);