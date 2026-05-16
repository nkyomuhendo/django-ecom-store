FROM python:3.12-alpine

ENV PATH="/scripts:${PATH}"

COPY ./requirements.txt /requirements.txt

# 1. Install permanent runtime dependencies (libpq)
RUN apk add --update --no-cache libpq

# 2. Install temporary build dependencies under .tmp
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev python3-dev musl-dev postgresql-dev linux-headers

RUN python3 -m venv /opt/venv

RUN /opt/venv/bin/pip install pip --upgrade && \
    /opt/venv/bin/pip install -r requirements.txt

# 3. Clean up build dependencies (libpq will remain safe)
RUN apk del .tmp

RUN mkdir /app

COPY ./app /app
WORKDIR /app
COPY ./scripts /scripts

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
RUN chown -R user:user /app/

USER user

CMD ["entrypoint.sh"]