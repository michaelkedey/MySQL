from flask import Flask, abort, jsonify, request
from db import update_task, fetch_all_tasks, insert_task, get_task_by_id, delete_task_by_id
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*":{"origins":"*"}})


# PUT /tasks/<id> - Update a specific task
@app.route('/update-tasks/<int:id>', methods=['PUT'])
def update_task(id):
    try:
        data = request.json
        title = data['title']
        description = data.get('description', '')
        status = data.get('status', 'pending')
        priority = data.get('priority', 1)
        due_date = data.get('due_date')

        update_task(id, title, description, status, priority, due_date)  # Call PostgreSQL update function
        return jsonify({'message': 'Task updated successfully'})
    except Exception as e:
        return jsonify({'error ':str(e)}), 400


@app.route('/create-tasks', methods=['POST'])
def create_task():
    try:
        data = request.json
        title = data['title']
        description = data.get('description', '')
        status = data.get('status', 'pending')
        priority = data.get('priority', 1)
        due_date = data.get('due_date')

        insert_task(title, description, status, priority, due_date)  # Call PostgreSQL insert function
        return jsonify({'message': 'Task created successfully'}), 201
    except Exception as e:
        return jsonify({'error ':str(e)}), 400


@app.route('/')
def get_all():
    try:
        tasks = fetch_all_tasks()

        return jsonify({'tasks': tasks}), 200
    except Exception as e:
        return jsonify({'error ':str(e)}), 400
    
# @app.route('/task/delete/<int:id>', methods=['POST'])
# def delete_task():
#     try: 
#         delete_task_by_id()
#         return 200
#     except Exception as e: 
#         return jsonify({'error ':str(e)}), 400



@app.route('/<int:id>', methods=['GET'])
def get_task(id):
    task = get_task_by_id(id)  # Use function from db.py
    if task:
        return jsonify(task)
    else:
        return jsonify({'message': 'Task not found'}), 404

@app.route('/delete-task/<int:id>', methods=['DELETE'])
def delete_task(id):
    delete_task_by_id(id)  # Call PostgreSQL delete function
    return jsonify({'message': 'Task deleted successfully'})

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
