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
        raise e
        

def insert_task(title, description):
    conn = get_db_connection()
    if not conn:
        print('Failed to connect to the database')
    try:
        cursor = conn.cursor()
        cursor.execute("CALL insert_task(%s, %s);", (title, description))  # Calling the stored procedure
        conn.commit()
    except psycopg2.Error as e:
        print(f'Error updating tacsk: {e}')
    finally:
        cursor.close()
        conn.close()
    


def update_task(task_id, title, description, done):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
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


def fetch_all_tasks():

    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT * FROM get_all_tasks();")
        tasks = cursor.fetchall()  # Fetch all rows
        cursor.close()
        conn.close()
        return tasks
    except psycopg2.Error as e:
        raise e
