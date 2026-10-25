USE dg250149508_db;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    organisation VARCHAR(100) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL,
    preferred_contact ENUM('email','post') NOT NULL DEFAULT 'email',
    added_on DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE pool_members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    work_address VARCHAR(150),
    home_address VARCHAR(150),
    joined DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(60) NOT NULL,
    skill_type VARCHAR(60) NOT NULL,
    UNIQUE KEY (skill_name, skill_type)
);

CREATE TABLE member_skills (
    member_id INT NOT NULL,
    skill_id INT NOT NULL,
    level ENUM('Junior','Mid','Senior','Expert') NOT NULL DEFAULT 'Junior',
    PRIMARY KEY (member_id, skill_id),
    FOREIGN KEY (member_id) REFERENCES pool_members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE RESTRICT
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    title VARCHAR(120) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    budget DECIMAL(10,2),
    phase ENUM('design','development','testing','deployment','complete') DEFAULT 'design',
    created DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE RESTRICT
);

CREATE TABLE assignments (
    project_id INT NOT NULL,
    member_id INT NOT NULL,
    assigned_on DATE DEFAULT (CURRENT_DATE),
    role VARCHAR(80),
    PRIMARY KEY (project_id, member_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES pool_members(member_id) ON DELETE RESTRICT
);

CREATE TABLE required_skills (
    project_id INT NOT NULL,
    skill_id INT NOT NULL,
    min_level ENUM('Junior','Mid','Senior','Expert') DEFAULT 'Mid',
    PRIMARY KEY (project_id, skill_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE RESTRICT
);