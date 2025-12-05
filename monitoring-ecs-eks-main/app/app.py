from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import boto3

app = Flask(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter("app_request_count", "Total HTTP requests", ["method", "endpoint", "http_status"])
REQUEST_LATENCY = Histogram("app_request_latency_seconds", "Request latency seconds", ["endpoint"])

# CloudWatch client (for custom metrics if you want)
cw = boto3.client("cloudwatch", region_name="ap-south-1")  # set region

users = []

@app.before_request
def start_timer():
    request._start_time = time.time()

@app.after_request
def record_metrics(response):
    latency = time.time() - request._start_time
    REQUEST_LATENCY.labels(endpoint=request.path).observe(latency)
    REQUEST_COUNT.labels(method=request.method, endpoint=request.path, http_status=response.status_code).inc()

    # Optional: publish a custom CloudWatch metric (RequestLatency)
    try:
        cw.put_metric_data(
            Namespace='MyService/App',
            MetricData=[{
                'MetricName': 'RequestLatency',
                'Dimensions': [{'Name':'Service', 'Value':'myservice'}],
                'Value': latency,
                'Unit': 'Seconds'
            }]
        )
    except Exception:
        # don't break app if CW call fails
        pass

    return response

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route("/health")
def health():
    return jsonify({"status":"ok"})

@app.route("/users", methods=["GET"])
def list_users():
    return jsonify(users)

@app.route("/users", methods=["POST"])
def create_user():
    data = request.get_json()
    if not data or "name" not in data:
        return jsonify({"error":"name required"}), 400
    user = {"id": len(users)+1, "name": data["name"]}
    users.append(user)
    return jsonify(user), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
