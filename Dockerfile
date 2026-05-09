# Use official lightweight Python 3.10 image
FROM python:3.10-slim

# Set environment variables: no .pyc files, unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy pyproject.toml first to leverage Docker cache
COPY pyproject.toml /app/
RUN pip install --no-cache-dir .

# Copy remaining project files (honoring .dockerignore)
COPY . /app/

# Expose port 8000
EXPOSE 8000

# Run migrations, collectstatic and start gunicorn at runtime
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn myproject.wsgi:application --bind 0.0.0.0:8000 --workers 2 --threads 4"]