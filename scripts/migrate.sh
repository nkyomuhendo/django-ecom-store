#!/bin/sh

SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL:-"hello@pitech.co.ug"}
cd /app/

/opt/venv/bin/python manage.py migrate --noinput
/opt/venv/bin/python manage.py createsuperuser --email $SUPERUSER_EMAIL --noinput || true