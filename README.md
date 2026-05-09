# Tutorial Django Website

This is a backend web application built with Django, designed as a comprehensive tutorial project. It includes fundamental features like user authentication, RESTful APIs, and JWT-based security.

## Technologies & Tools

This project is built using the following modern tech stack:

*   **Backend Framework**: [Django](https://www.djangoproject.com/) (v5.2+)
*   **API Framework**: [Django REST Framework](https://www.django-rest-framework.org/) (DRF)
*   **Authentication**: [SimpleJWT](https://django-rest-framework-simplejwt.readthedocs.io/en/latest/) for JSON Web Token (JWT) authentication.
*   **Database**: PostgreSQL (via psycopg2)
*   **WSGI Server**: [Gunicorn](https://gunicorn.org/)
*   **Reverse Proxy / Web Server**: [Nginx](https://nginx.org/)
*   **Containerization**: [Docker](https://www.docker.com/) & Docker Compose

## Development Setup

To develop and test the application locally in standard development mode:

1.  **Clone the repository and enter the directory**:
    ```bash
    cd tutorial-django-website
    ```

2.  **Setup the environment and install dependencies** (using [uv](https://github.com/astral-sh/uv)):
    `uv` will seamlessly manage the virtual environment and dependencies for you.
    ```bash
    uv sync
    ```

3.  **Run Database Migrations**:
    Prefix commands with `uv run` to execute them automatically inside the isolated environment.
    ```bash
    # Ensure you set the required environment variables first
    export SECRET_KEY="your-dev-secret-key"
    export POSTGRES_DB="myproject_db"
    export POSTGRES_USER="myproject_user"
    export POSTGRES_PASSWORD="your-local-dev-password"
    export POSTGRES_HOST="localhost"
    export POSTGRES_PORT="5432"
    export DEBUG="True"
    uv run python manage.py migrate
    ```

4.  **Start the development server**:
    ```bash
    uv run python manage.py runserver
    ```
    The site will be available at `http://127.0.0.1:8000`.

## Local Production Deployment

To simulate or run the project in a production-like environment (with Nginx, Gunicorn, and high availability), you can deploy it locally using Docker Compose.

1.  **Ensure Docker and Docker Compose are installed and running** on your system.

2.  **Spin up the containers**:
    Use the following commands, making sure to define all required variables.
    ```bash
    export SECRET_KEY="your-production-secret-key"
    export POSTGRES_DB="myproject_db"
    export POSTGRES_USER="myproject_user"
    export POSTGRES_PASSWORD="your-secure-db-password"
    docker compose up --build -d
    ```

3.  **Access the application**:
    The Nginx reverse proxy listens on port `80`. Open your browser and go to:
    ```
    http://localhost
    ```
    *Note: Nginx handles the static files serving and proxies dynamic workloads to 2 Gunicorn (web) replicas for high availability.*

4.  **Stopping the services**:
    ```bash
    docker compose down
    ```
