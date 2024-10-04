from flask import Flask
from middleware.db import (
    get_db_connection,
    update_task,
)

app = Flask(__name__)


@app.route("/api/update/<int:id>/", strict_slashes=True)
def update(id):

    cursor = update_task(id)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
