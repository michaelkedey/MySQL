import psycopg2
from psycopg2.extras import RealDictCursor


# Database connection details
def get_db_connection():
    conn = psycopg2.connect(
        host="localhost",
        database="taskdb",  # Replace with your database name
        user="username",  # Replace with your PostgreSQL username
        password="password",  # Replace with your PostgreSQL password
    )
    return conn


# Function to fetch all tasks
def fetch_all_tasks():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM tasks ORDER BY id;")
    tasks = cursor.fetchall()
    cursor.close()
    conn.close()
    return tasks


# Function to insert a task
def insert_task(title, description):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO tasks (title, description) VALUES (%s, %s);", (title, description)
    )
    conn.commit()
    cursor.close()
    conn.close()


# Function to update a task
def update_task(task_id, title, description, done):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE tasks SET title = %s, description = %s, done = %s WHERE id = %s;",
        (title, description, done, task_id),
    )
    conn.commit()
    cursor.close()
    conn.close()


# Function to delete a task
def delete_task(task_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM tasks WHERE id = %s;", (task_id,))
    conn.commit()
    cursor.close()
    conn.close()


# Function to get a single task
def get_task_by_id(task_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM tasks WHERE id = %s;", (task_id,))
    task = cursor.fetchone()
    cursor.close()
    conn.close()
    return task
