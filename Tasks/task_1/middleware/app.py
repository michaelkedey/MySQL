from flask import Flask

app = Flask(__name__)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)



### get function

def get_task_title(task_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("CALL get_task_title(%s);", (task_id,))
    title = cursor.fetchone()[0]  # Fetch the output
    cursor.close()
    conn.close()
    return title
