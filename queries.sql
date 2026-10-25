USE dg250149508_db;

INSERT INTO skills (skill_name, skill_type) VALUES
('Java', 'Backend'),
('Python', 'Backend'),
('JavaScript', 'Frontend'),
('React', 'Frontend'),
('MySQL', 'Database'),
('Selenium', 'Testing'),
('Figma', 'Design');

INSERT INTO pool_members (first_name, last_name, email, phone, work_address, home_address) VALUES
('Ethan', 'Clarke', 'ethan.clarke.dev@outlook.com', '07700 901234',
 'Level 2, Centre City House, 7 Hill Street, Birmingham B5 4UA',
 '42 High Street, Edgbaston, Birmingham B15 3DU'),
('Sophie', 'Walker', 'sophie.walker92@gmail.com', '07891 234567',
 '86 Vyse Street, Jewellery Quarter, Birmingham B18 6JZ',
 '17 Corporation Street, City Centre, Birmingham B2 4LS');

INSERT INTO member_skills (member_id, skill_id, level) VALUES
(1, 1, 'Senior'),
(1, 3, 'Mid'),
(1, 4, 'Senior'),
(1, 6, 'Expert');

INSERT INTO member_skills (member_id, skill_id, level) VALUES
(2, 3, 'Expert'),
(2, 4, 'Senior'),
(2, 5, 'Mid'),
(2, 7, 'Mid');

INSERT INTO clients (organisation, first_name, last_name, email, address, preferred_contact) VALUES
('SparkVibe Digital', 'Mason', 'Green', 'm.green@sparkvibe.co.uk',
 'The Bond, 180-182 Fazeley Street, Birmingham B5 5SE', 'email'),
('ForgeAhead Solutions', 'Freya', 'Taylor', 'freya@forgeahead.uk',
 'ICentrum, Holt Street, Birmingham B7 4BP', 'post');

INSERT INTO projects (client_id, title, description, start_date, end_date, budget, phase) VALUES
(1, 'Client Portal Upgrade',
 'Redesign and rebuild the main customer portal - better UI and faster loading',
 '2026-03-20', '2026-07-31', 38500.00, 'design');

INSERT INTO required_skills (project_id, skill_id, min_level) VALUES
(1, 3, 'Mid'),
(1, 4, 'Mid');

-- Select members who satisfy all required skills for the project
SELECT
    pm.first_name,
    pm.last_name,
    pm.email,
    GROUP_CONCAT(CONCAT(s.skill_name, ' - ', ms.level) SEPARATOR ', ') AS skills
FROM pool_members pm
JOIN member_skills ms ON pm.member_id = ms.member_id
JOIN skills s ON ms.skill_id = s.skill_id
WHERE s.skill_id IN (
    SELECT skill_id FROM required_skills WHERE project_id = 1
)
GROUP BY pm.member_id
HAVING COUNT(DISTINCT s.skill_id) = 2;

INSERT INTO assignments (project_id, member_id, role) VALUES
(1, 2, 'Frontend Developer');

SELECT
    p.title,
    p.phase,
    c.organisation AS client,
    p.start_date,
    p.budget
FROM projects p
JOIN clients c ON p.client_id = c.client_id
ORDER BY p.start_date;

SELECT
    pm.first_name,
    pm.last_name,
    COUNT(a.project_id) AS projects_count,
    GROUP_CONCAT(p.title SEPARATOR ' | ') AS projects
FROM pool_members pm
LEFT JOIN assignments a ON pm.member_id = a.member_id
LEFT JOIN projects p ON a.project_id = p.project_id
GROUP BY pm.member_id
ORDER BY projects_count DESC;

SELECT
    s.skill_name,
    COUNT(ms.member_id) AS number_of_members
FROM skills s
LEFT JOIN member_skills ms ON s.skill_id = ms.skill_id
GROUP BY s.skill_id;