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

def insert_task(title, description):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("CALL insert_task(%s, %s);", (title, description))  # Calling the stored procedure
    conn.commit()  # Commit the transaction
    cursor.close()
    conn.close()