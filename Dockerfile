FROM alpine:latest
RUN apk update && apk add bash curl git jq busybox-suid
RUN mkdir -p /etc/prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml
RUN mkdir -p /var/lib/grafana
COPY prom_export.sh /usr/local/bin/prom_export.sh
RUN chmod +x /usr/local/bin/prom_export.sh
RUN echo "*/1 * * * * /usr/local/bin/prom_export.sh" > /etc/crontabs/root
CMD ["crond", "-f"]
