from flask import Flask, abort, jsonify
from middleware.db import update_task

app = Flask(__name__)


@app.route("/api/update/<int:id>/", strict_slashes=True)
def update(id):
    if not id:
        return jsonify({"error": "id is required"}), 400
    cursor = update_task(id)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)