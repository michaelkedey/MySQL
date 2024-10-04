#### Project Idea: Task Management Application

#### Overview
**Create a `web-based` task management application where users can `create`, `read`, `update`, and `delete` tasks. This application will involve a `PostgreSQL` database for storing tasks, a `python` middleware for handling requests, and a frontend using `React`.**

#### Project Components

- Database
    - Postgres

- Middleware:
    - Set up a RESTful API using Python
        - Endpoints:
            - GET /tasks: Retrieve all tasks.
            - POST /tasks: Create a new task.
            - PUT /tasks/:id: Update a specific task.
            - DELETE /tasks/:id: Delete a specific task.

- Frontend:
    - Build a simple interface to interact with the API.
    - Features:
        - Display a list of tasks.
        - Form to add a new task.
        - Options to edit or delete existing tasks.

#### TEAMS
- Database Administrators
- Responsibilities:
    - Create and maintain the database schema.
    - Optimize queries for performance.
    - Ensure data integrity and security.
    - **Team**
        - Karta
        - Dzifa
        - Isreal

- Backend Enginners
- Responsibilities:
    - Set up RESTful endpoints.
    - Implement business logic and data processing.
    - Ensure secure communication between client and server.
    - **Team**
        - Lord
        - Blaq
        - Edward
        - Cobby

- Fronted Developers
- Responsibilities:
    - Design and implement the application’s UI.
    - Integrate the frontend with the middleware API.
    - Focus on user experience and accessibility.
    - **Team**
        - Tracy
        - Odeneho
        - Rogers

##### directory structure
```plaintext
.
├── db
├── frontend
├── middleware
└── README.md
```
