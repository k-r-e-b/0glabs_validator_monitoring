# Use a base image with Docker and Docker Compose installed
FROM alpine:latest

# Install necessary packages
RUN apk update && apk add bash curl git docker docker-compose

# Set up Prometheus
RUN mkdir -p /etc/prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Set up Grafana
RUN mkdir -p /var/lib/grafana
COPY grafana.db /var/lib/grafana/grafana.db

# Set up Docker Compose
COPY docker-compose.yml /root/docker-compose.yml

# Start Docker Compose
CMD ["sh", "-c", "docker-compose -f /root/docker-compose.yml up"]
