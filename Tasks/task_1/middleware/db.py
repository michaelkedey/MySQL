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
