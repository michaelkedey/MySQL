import psycopg2
from psycopg2.extras import RealDictCursor


# Database connection details
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="academy.iridislabs.dev",
            database="tmapp_db",  # Replace with your database name
            user="cobbina",  # Replace with your PostgreSQL username
            password="cobby12345",  # Replace with your PostgreSQL password
        )
        return conn
    except psycopg2.DatabaseError as e:
        raise e
        

def insert_task(title, description, status, priority, due_date):
    conn = get_db_connection()
    if not conn:
        print('Failed to connect to the database')
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT insert_task(%s, %s, %s, %s, %s);",
            (title, description, status, priority, due_date)
        )
        conn.commit()
        cursor.close()
        conn.close()
    except psycopg2.Error as e:
        raise e   
# def insert_task(title, description, status, priority, due_date):
#     conn = get_db_connection()
#     cursor = conn.cursor()
#     cursor.execute(
#         "SELECT insert_task(%s, %s, %s, %s, %s);",
#         (title, description, status, priority, due_date)
#     )
#     conn.commit()
#     cursor.close()
#     conn.close()

# def update_task(task_id, title, description, done):
#     conn = get_db_connection()
#     try:
#         cursor = conn.cursor()
#         cursor.execute(
#             "UPDATE tasks SET title = %s, description = %s, done = %s WHERE id = %s;",
#             (title, description, done, task_id),
#         )
#         conn.commit()
#         cursor.close()
#         conn.close()
#     except psycopg2.Error as e:
#         raise e

def update_task(task_id, title, description, status, priority, due_date):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT update_task(%s, %s, %s, %s, %s, %s);",
            (task_id, title, description, status, priority, due_date)
        )
        conn.commit()
        cursor.close()
        conn.close()
    except psycopg2.Error as e:
        raise e
    
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


def get_task_by_id(task_id):

    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Directly call the PostgreSQL function using the task_id
        cursor.execute("SELECT * FROM get_task_by_id(%d);" % task_id)
        
        task = cursor.fetchone()  # Fetch a single task by its ID
        cursor.close()
        conn.close()
        return task
    except psycopg2.Error as e:
        raise e

# Function to delete a task using the database function
def delete_task(task_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT delete_task(%s);", (task_id,))
        conn.commit()
        cursor.close()
        conn.close()
    except psycopg2.Error as e:
        raise e
