FROM python:3.10-slim

WORKDIR /app

# Install dependencies
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn prometheus-client

# Copy source code
COPY ./app ./app

# Expose Flask port
EXPOSE 5000
ENV PORT=5000

# Start with gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app.app:app"]
