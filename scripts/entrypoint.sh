#!/bin/sh

set -e


SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL:-"hello@pitech.co.ug"}
cd /app/


# echo "Waiting for PostgreSQL..."
# while ! nc -z $DB_HOST $DB_PORT; do
#   sleep 0.1
# done
# echo "PostgreSQL started"

echo "Waiting for PostgreSQL..."
while ! /opt/venv/bin/python -c "import socket; socket.create_connection(('$DB_HOST', $DB_PORT))" 2>/dev/null; do
  sleep 0.1
done
echo "PostgreSQL started"

# echo "Waiting for Redis..."
# while ! nc -z redis 6379; do
#   sleep 0.1
# done
# echo "Redis started"

echo "Running migrations..."
# python manage.py migrate --noinput
/opt/venv/bin/python manage.py migrate --noinput

echo "Creating superuser if needed..."
/opt/venv/bin/python manage.py createsuperuser --noinput --email admin@pitech.co.ug --username admin || true

echo "Collecting static files..."
# python manage.py collectstatic --noinput --clear
/opt/venv/bin/python manage.py collectstatic --noinput  --clear

# echo "Setting up initial data..."
# /opt/venv/bin/python deploy/initial_data_setup.py || echo "Initial data setup failed or already exists"

echo "Starting server..."
/opt/venv/bin/uwsgi --socket :8000 --master --enable-threads --module app.wsgi