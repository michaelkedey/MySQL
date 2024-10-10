--Drop and create the database
DROP DATABASE IF EXISTS tmapp_db;
CREATE DATABASE tmapp_db;
\c tmapp_db;


--Create tasks table
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    priority INT DEFAULT 1 CHECK (priority BETWEEN 1 AND 3),  -- Constrain priority to a valid range
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Index on status to quickly fetch tasks based on their status
CREATE INDEX idx_tasks_status ON tasks(status);

-- Index on priority for performance on sorting/filtering tasks by priority
CREATE INDEX idx_tasks_priority ON tasks(priority);

-- Index on due_date for quick sorting by deadlines
CREATE INDEX idx_tasks_due_date ON tasks(due_date);


-- Ensure that task priority is within a certain range
ALTER TABLE tasks
ADD CONSTRAINT priority_check CHECK (priority BETWEEN 1 AND 3);


-- Insert additional tasks
INSERT INTO tasks (title, description, status, priority, due_date) VALUES 
('Task 1', 'Complete the project documentation.', 'pending', 1, '2024-10-10'),
('Task 2', 'Prepare presentation slides for the meeting.', 'in progress', 2, '2024-10-12'),
('Task 3', 'Write tests for the new feature.', 'in progress', 1, NULL),
('Task 5', 'Write tests for the new feature.', 'pending', 2, NULL),
('Task 4', 'Deploy the application to production.', 'pending', 3, '2024-10-15');


--Delete task function
CREATE OR REPLACE FUNCTION delete_task(p_task_id INT) RETURNS VOID AS $$
BEGIN
    DELETE FROM tasks WHERE task_id = p_task_id;
END;
$$ LANGUAGE plpgsql;


--Update task function
CREATE OR REPLACE FUNCTION update_task(
    p_task_id INT,
    p_title VARCHAR(255), 
    p_description TEXT, 
    p_status VARCHAR(50), 
    p_priority INT, 
    p_due_date DATE
) RETURNS VOID AS $$
BEGIN
    UPDATE tasks SET
        title = p_title,
        description = p_description,
        status = p_status,
        priority = p_priority,
        due_date = p_due_date,
        updated_at = CURRENT_TIMESTAMP
    WHERE task_id = p_task_id;
END;
$$ LANGUAGE plpgsql;


--Insert task function
CREATE OR REPLACE FUNCTION insert_task(
    p_title VARCHAR(255), 
    p_description TEXT, 
    p_status VARCHAR(50), 
    p_priority INT, 
    p_due_date DATE
) RETURNS VOID AS $$
BEGIN
    INSERT INTO tasks (title, description, status, priority, due_date)
    VALUES (p_title, p_description, p_status, p_priority, p_due_date);
END;
$$ LANGUAGE plpgsql;


--Get task function
CREATE OR REPLACE FUNCTION get_task_by_id(p_task_id INT) 
RETURNS TABLE(
    task_id INT, 
    title VARCHAR(255), 
    description TEXT, 
    status VARCHAR(50), 
    priority INT, 
    due_date DATE, 
    created_at TIMESTAMP, 
    updated_at TIMESTAMP
) 
AS $$
BEGIN
    RETURN QUERY 
    SELECT t.task_id, t.title, t.description, t.status, t.priority, t.due_date, t.created_at, t.updated_at
    FROM tasks t
    WHERE t.task_id = p_task_id;
END;
$$ LANGUAGE plpgsql;


--Get all tasks function
CREATE OR REPLACE FUNCTION get_all_tasks() 
RETURNS TABLE(
    task_id INT, 
    title VARCHAR(255), 
    description TEXT, 
    status VARCHAR(50), 
    priority INT, 
    due_date DATE, 
    created_at TIMESTAMP, 
    updated_at TIMESTAMP
) 
AS $$
BEGIN
    RETURN QUERY 
    SELECT t.task_id, t.title, t.description, t.status, t.priority, t.due_date, t.created_at, t.updated_at 
    FROM tasks t
    ORDER BY t.task_id;
END;
$$ LANGUAGE plpgsql;

-- Create a "readonly" role for users who should only be able to view data (no modifications)
CREATE ROLE readonly;

-- Grant the readonly role select permission on all tables in the public schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;

-- Create a "readwrite" role for users who should be able to view and modify data
CREATE ROLE readwrite;

-- Grant the readwrite role select, insert, update, and delete permissions on all tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite;

-- Assign the "readonly" role to a specific user
GRANT readonly TO lord;

-- Assign the "readwrite" role to another specific user
GRANT readwrite TO man_karta;
GRANT readwrite TO cobbina;


