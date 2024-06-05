FROM python:3.9-alpine3.13

# Set the maintainer label to the person or organization responsible for maintaining the Docker image.
LABEL maintainer="Vineet Das"

# Set environment variable to ensure Python output is not buffered
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy application files
COPY ./app /app

# Set the working directory
WORKDIR /app

# Make port 8000 available to the world outside this container
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


ENV PATH="/py/bin:$PATH"


USER django-user