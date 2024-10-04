import psycopg2
from psycopg2.extras import RealDictCursor


# Database connection details
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="taskdb",  # Replace with your database name
            user="username",  # Replace with your PostgreSQL username
            password="password",  # Replace with your PostgreSQL password
        )
        return conn
    except psycopg2.DatabaseError as e:
        print(f"Database connection error: {e}")
        return None


def update_task(task_id, title, description, done):
    conn = get_db_connection()
    if conn is None:
        print("Failed to connect to the database.")
        return
    cursor = conn.cursor()
    try:
        cursor.execute(
            "UPDATE tasks SET title = %s, description = %s, done = %s WHERE id = %s;",
            (title, description, done, task_id),
        )
        conn.commit()
    except psycopg2.Error as e:
        print(f"Error updating task: {e}")
    finally:
        cursor.close()
        conn.close()
