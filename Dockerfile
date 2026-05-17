FROM python:3.12-slim

# Note: I added /opt/venv/bin to the PATH so you don't have to type 
# the full path to run python, pip, gunicorn, or uwsgi.
ENV PATH="/scripts:/opt/venv/bin:${PATH}"

COPY ./requirements.txt /requirements.txt

# 1. Install dependencies, build packages, and clean up in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
        # Permanent runtime dependency
        libpq5 \
        # Temporary build dependencies (needed for uWSGI)
        build-essential \
        python3-dev \
    # Create venv and install python packages
    && python3 -m venv /opt/venv \
    && pip install pip --upgrade \
    && pip install -r /requirements.txt \
    # Clean up build dependencies to keep the image small
    && apt-get purge -y --auto-remove build-essential python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

COPY ./app /app
WORKDIR /app
COPY ./scripts /scripts

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# 2. Add user (Debian syntax instead of Alpine's 'adduser -D')
RUN adduser --disabled-password --no-create-home user

RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
RUN chown -R user:user /app/

USER user

CMD ["entrypoint.sh"]