ARG PYTHON_VERSION=3.12

FROM python:${PYTHON_VERSION}-slim AS builder

ARG RADICALE_VERSION=3.6.0

RUN python -m pip install --upgrade pip wheel
RUN python -m pip wheel --no-deps --wheel-dir=/wheels radicale==${RADICALE_VERSION}

FROM gcr.io/distroless/python3-debian12
COPY --from=builder /wheels /wheels
RUN python -m pip install --no-cache-dir /wheels/*

WORKDIR /data
VOLUME /config /data
EXPOSE 5232
USER 1000:1000
ENTRYPOINT ["python", "-m", "radicale"]
CMD ["--config", "/config/config"]
