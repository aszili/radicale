ARG PYTHON_VERSION=3.12
ARG RADICALE_VERSION=3.6.0

FROM python:${PYTHON_VERSION}-slim AS builder

ENV VENV=/venv

RUN python -m venv ${VENV} \
    && ${VENV}/bin/pip install --no-cache-dir \
        radicale==${RADICALE_VERSION}

FROM gcr.io/distroless/python${PYTHON_VERSION}-debian12

ENV VENV=/venv
ENV PATH="${VENV}/bin:${PATH}"

COPY --from=builder ${VENV} ${VENV}

WORKDIR /data

EXPOSE 5232

USER 1000:1000

ENTRYPOINT ["python", "-m", "radicale"]
CMD ["--config", "/config/config"]
