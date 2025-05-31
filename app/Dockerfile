# Using lightweight Python image
FROM python:3.11-slim

# Set environment variables to prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a non-root user and group
RUN groupadd -r devopsadmin && useradd -r -g devopsadmin devopsadmin

# Set the working directory
WORKDIR /app

# Copy the requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Change ownership of the app directory
RUN chown -R devopsadmin:devopsadmin /app

# Switch to non-root user
USER devopsadmin

# Expose the Flask port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
