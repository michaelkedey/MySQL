from flask import Flask, abort, jsonify, request
from middleware.db import update_task, fetch_all_tasks, delete_completed_tasks, insert_task

app = Flask(__name__)


@app.route("/update/<int:id>/", strict_slashes=True)
def update(id):
    if not id:
        return jsonify({"error": "id is required"}), 400
    cursor = update_task(id)


@app.route('/insert/', methods=['POST'])
def add_task():
    title = request.form['title']
    description = request.form.get('description', '')
    try:
        insert_task(title, description)  # Calls the PostgreSQL procedure to insert a task
        return jsonify({"Data inserted successfully"}), 200
    except Exception as e:
        return jsonify({'error ':str(e)}), 400


@app.route('/')
def get_all():
    try:
        # tasks = [{
        #     'id': 1,
        #     'title': 'Go to Work',
        #     'description': 'I have to work for a living'
        # },
        # {
        #     'id': 2,
        #     'title': 'Go to Work',
        #     'description': 'I have to work for a living'
        # },
        # {
        #     'id': 3,
        #     'title': 'Go to Work',
        #     'description': 'I have to work for a living'
        # }]
        tasks = fetch_all_tasks()

        return jsonify({'tasks': tasks}), 200
    except Exception as e:
        return jsonify({'error ':str(e)}), 400
    
@app.route('/task/delete/<int:id>', methods=['POST'])
def delete_task():
    try: 

        delete_completed_tasks()
        return 200
    except Exception as e: 
        return jsonify({'error ':str(e)}), 400



if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
