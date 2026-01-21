ARG PYTHON_VERSION=3.12

FROM python:${PYTHON_VERSION}-slim AS builder

ARG RADICALE_VERSION=3.6.0

ENV VENV=/venv

RUN python -m venv ${VENV} \
    && ${VENV}/bin/pip install --no-cache-dir \
        radicale==${RADICALE_VERSION}

FROM gcr.io/distroless/python3-debian12

ENV VENV=/venv

COPY --from=builder ${VENV} ${VENV}

WORKDIR /data

EXPOSE 5232

USER 1000:1000

ENTRYPOINT ["/venv/bin/python", "-m", "radicale"]
CMD ["--config", "/config/config"]
