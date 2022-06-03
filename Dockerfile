FROM python:3.6.10-slim-buster as builder

LABEL MAINTAINER "Khaerul Umam"
LABEL DESCRIPTION "Test Gracefully Killer"

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

FROM python:3.6.10-slim-buster as run

ARG APP_USER="grace"
ARG WORK_DIRECTORY="/app"

COPY . /app
WORKDIR ${WORK_DIRECTORY}

RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/* \
    && useradd -rm -d ${WORK_DIRECTORY} -s /bin/bash -U ${APP_USER} \ 
    && chown -R ${APP_USER}:${APP_USER} ${WORK_DIRECTORY} \ 
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} >/etc/timezone \ 
    && apt-get clean

USER ${APP_USER}

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR ${WORK_DIRECTORY}

CMD ["python", "app.py"]