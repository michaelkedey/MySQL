--Drop and create the database
DROP DATABASE IF EXISTS tmapp_db;
CREATE DATABASE tmapp_db;
\c tmapp_db;

--Create users table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--Create tasks table
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    priority INT DEFAULT 1 CHECK (priority BETWEEN 1 AND 3),  -- Constrain priority to a valid range
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

--Create comments table
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

--Create labels table
DROP TABLE IF EXISTS labels; 
CREATE TABLE labels (
    label_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

--Create tasks_labels table
DROP TABLE IF EXISTS task_labels; 
CREATE TABLE task_labels (
    task_id INT NOT NULL,
    label_id INT NOT NULL,
    PRIMARY KEY (task_id, label_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (label_id) REFERENCES labels(label_id) ON DELETE CASCADE
);


-- Index on user_id to speed up queries that fetch user tasks
CREATE INDEX idx_tasks_user_id ON tasks(user_id);

-- Index on status to quickly fetch tasks based on their status
CREATE INDEX idx_tasks_status ON tasks(status);

-- Index on priority for performance on sorting/filtering tasks by priority
CREATE INDEX idx_tasks_priority ON tasks(priority);

-- Index on due_date for quick sorting by deadlines
CREATE INDEX idx_tasks_due_date ON tasks(due_date);


-- Ensure unique emails and usernames
ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email),
ADD CONSTRAINT unique_username UNIQUE (username);

-- Ensure that task priority is within a certain range
ALTER TABLE tasks
ADD CONSTRAINT priority_check CHECK (priority BETWEEN 1 AND 3);


-- Create the "pgcrypto" extension to enable hashing and encryption functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert a new user into the "users" table with a hashed password using bcrypt
-- Insert additional users
INSERT INTO users (username, email, password_hash) VALUES 
('jane_doe', 'jane@example.com', crypt('password1', gen_salt('bf'))),
('alice_smith', 'alice@example.com', crypt('password2', gen_salt('bf'))),
('bob_johnson', 'bob@example.com', crypt('password3', gen_salt('bf'))),
('bob_johnson1', 'bob1@example.com', crypt('password4', gen_salt('bf'))),
('bob_johnson2', 'bob2@example.com', crypt('password5', gen_salt('bf')));


-- Insert additional tasks
INSERT INTO tasks (user_id, title, description, status, priority, due_date) VALUES 
(1, 'Task 1', 'Complete the project documentation.', 'pending', 1, '2024-10-10'),
(2, 'Task 2', 'Prepare presentation slides for the meeting.', 'in progress', 2, '2024-10-12'),
(3, 'Task 3', 'Write tests for the new feature.', 'pending', 1, NULL),
(5, 'Task 5', 'Write tests for the new feature.', 'pending', 2, NULL),
(4, 'Task 4', 'Deploy the application to production.', 'pending', 3, '2024-10-15');


-- Optional: Encrypt sensitive data (e.g., comments) using symmetric encryption with pgcrypto
-- Inserting encrypted data
-- Insert comments for Task 1
INSERT INTO comments (task_id, user_id, content) VALUES 
(1, 2, 'I will work on the documentation this weekend.'),
(1, 3, 'Please share your inputs on the draft.'),
(1, 4, 'Looking forward to seeing your updates.');

-- Insert comments for Task 2
INSERT INTO comments (task_id, user_id, content) VALUES 
(2, 1, 'Let me know if you need any help with the slides.'),
(2, 3, 'I can review the slides before the meeting.'),
(2, 4, 'The deadline is tight, but I’ll manage!');

-- Insert comments for Task 3
INSERT INTO comments (task_id, user_id, content) VALUES 
(3, 1, 'Tests are crucial for this feature.'),
(3, 2, 'I have a few ideas for tests that we can implement.'),
(3, 4, 'Let’s ensure we cover all edge cases.');

-- Insert comments for Task 4
INSERT INTO comments (task_id, user_id, content) VALUES 
(4, 2, 'Make sure to double-check everything before deployment.'),
(4, 3, 'I’ll be available for the deployment process.'),
(4, 1, 'Let’s plan for a rollback just in case.');



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


