ARG PYTHON_VERSION=3.12

FROM python:${PYTHON_VERSION}-slim AS builder

RUN python -m pip install --upgrade pip wheel
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --target=/app -r requirements.txt

FROM gcr.io/distroless/python3-debian12
COPY --from=builder /app /app
ENV PYTHONPATH=/app

WORKDIR /data
VOLUME /config /data
EXPOSE 5232
USER 1000:1000
ENTRYPOINT ["python", "-m", "radicale"]
CMD ["--config", "/config/config"]
