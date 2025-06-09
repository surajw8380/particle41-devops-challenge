###### README - Flask App & Containerization #######

This directory contains the source code for the **SimpleTimeService**, a minimal Flask-based web service that returns the current timestamp and client IP address. The app is packaged into a Docker container and deployed using AWS ECS Fargate.

---

## 📂 Contents

* `app.py`: Main Flask app
* `requirements.txt`: Python dependencies
* `Dockerfile`: Container specification

---

## 🚀 Application Overview

This Flask app exposes a simple `/` endpoint that responds with:

```json
{
  "timestamp": "<current date and time>",
  "ip": "<the IP address of the visitor>"
}
```

It is used as the primary application for deployment testing in this project.

---

## 🐳 Containerization with Docker

### Dockerfile Highlights:

* Uses lightweight `python:3.11-slim` base image
* Creates non-root user (`devopsadmin`) for security
* Installs Python dependencies
* Runs app on port `5000`

### Build & Run Locally

To test locally (if Docker is installed):

```bash
# Build image
docker build -t simpletimeservice .

# Run container
docker run -p 5000:5000 simpletimeservice

# Visit in browser
http://localhost:5000
```

### Docker Image Used in Deployment

Docker image pushed to Docker Hub:

```
suraj838098/simpletimeservice:latest
```

---

## 🔗 Related Infrastructure

The application container is deployed as an ECS Fargate service via Terraform in the `../terraform` directory.

---

## ✅ Requirements to Work on This App

* [Python 3.11+](https://www.python.org/downloads/)
* [Docker](https://docs.docker.com/get-docker/)

---

## 🧪 Local Test without Docker

```bash
pip install -r requirements.txt
python app.py
```

Then visit: http://localhost:5000
