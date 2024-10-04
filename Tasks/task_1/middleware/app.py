from flask import Flask, abort, jsonify
from middleware.db import update_task, fetch_all_tasks

app = Flask(__name__)


@app.route("/api/update/<int:id>/", strict_slashes=True)
def update(id):
    if not id:
        return jsonify({"error": "id is required"}), 400
    cursor = update_task(id)


@app.route('/')
def get_all():
    # tasks = fetch_all_tasks()
    tasks = [{
        'id': 1,
        'title': 'Go to Work',
        'description': 'I have to work for a living'
    },
    {
        'id': 2,
        'title': 'Go to Work',
        'description': 'I have to work for a living'
    },
    {
        'id': 3,
        'title': 'Go to Work',
        'description': 'I have to work for a living'
    }]
    return jsonify({'tasks': tasks}), 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)