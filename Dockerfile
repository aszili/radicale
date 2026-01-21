FROM gcr.io/distroless/python3-debian12

ARG PYTHON_VERSION=3.12
ARG RADICALE_VERSION=3.6.0

COPY --from=python:${PYTHON_VERSION}-slim /usr/local/lib/python${PYTHON_VERSION%.*} /usr/local/lib/python${PYTHON_VERSION%.*}
COPY --from=python:${PYTHON_VERSION}-slim /usr/local/bin/pip /usr/local/bin/pip

RUN python -m pip install --no-cache-dir radicale==${RADICALE_VERSION}

WORKDIR /data
VOLUME /config /data
EXPOSE 5232
USER 1000:1000
ENTRYPOINT ["python", "-m", "radicale"]
CMD ["--config", "/config/config"]