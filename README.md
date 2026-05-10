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
*   **Code Quality & Linting**: [Ruff](https://docs.astral.sh/ruff/) (Linting/Formatting) and [Mypy](https://mypy.readthedocs.io/) (Static Type Checking)

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

## Automated CI/CD Pipeline

This project employs a fully automated Continuous Integration and Continuous Deployment (CI/CD) pipeline via GitHub Actions using a consolidated `main.yml` workflow.

1.  **Workflows**:
    *   `.github/workflows/main.yml`: Triggered on Push to `main` and Pull Requests. It executes three key phases sequentially:
        1.  **Lint & Type Check**: Validates the code using **Ruff** and **Mypy**. These tools are configured to output results directly into the GitHub UI. Any syntax or typing errors encountered in a Pull Request will be displayed as inline annotations (comments) alongside your code changes.
        2.  **Release Please (Automated Semantic Release)**: Using Google's `release-please-action`, this step analyzes your "Conventional Commits" on the `main` branch. It automatically opens a PR to update the `CHANGELOG.md`. Once that PR is merged, it bumps the version and automatically creates a new GitHub Release and Tag.
        3.  **Build and Push Docker Image**: If linting passes, this step securely logs into GHCR and builds the production Docker image. Direct pushes to `main` are tagged as `latest`. If `release-please` just created a new Tag (e.g. `v1.0.0`), the Docker image is automatically tagged with that specific version.
    *   `.github/workflows/deploy.yml`: A manual-trigger workflow. Since Environment Required Reviewers for *Private* repositories is a GitHub Enterprise feature, deployment to the production server is safeguarded by requiring you to manually trigger it. Go to the **Actions** tab on GitHub, select **Deploy to Production**, click **Run workflow**, and specify the precise Tag you want shipped.

2.  **Infrastructure (`docker-compose.prod.yml`)**:
    The production compose file differs from local development by downloading the predefined `IMAGE_NAME` from GHCR instead of building it from source locally.

3.  **GitHub Project Settings Configuration**:
    Before running the deployment, you must configure the following settings in your GitHub repository:

    *   **Configure a Self-Hosted Runner**:
        To securely deploy directly to your production server, set up a self-hosted runner:
        1. Go to your repository **Settings** > **Actions** > **Runners**.
        2. Click **New self-hosted runner** and choose your server's Operating System and Architecture.
        3. SSH into your production server and follow the provided command-line instructions to download and configure the runner application.
        4. Install the runner as a background service (Linux example: `sudo ./svc.sh install` then `sudo ./svc.sh start`) so it automatically starts on boot.

    *   **Configure an Environment**:
        1. Navigate to **Settings** > **Environments** and click **New environment**.
        2. Name it `production`.
        3. *(Note: If your repository is Public or you are using GitHub Enterprise, you can enable **Required reviewers** here to add an approval gate).*

    *   **Configure Secret Variables**:
        Navigate to **Settings** > **Secrets and variables** > **Actions**. You should add these secrets under **Environment secrets** (for the `production` environment) to keep them securely isolated, or under **Repository secrets**. Add the following keys:
        *   `SECRET_KEY`: Your secure Django secret key.
        *   `POSTGRES_DB`: Your production database name.
        *   `POSTGRES_USER`: Your production database user.
        *   `POSTGRES_PASSWORD`: Your secure database password.

Hello, again：)
