# Monitoring Playground

Examples on how to run popular monitoring tools locally for testing purposes.  
This repo contains [docker compose](https://docs.docker.com/compose/reference/) files for running the following services

* [Grafana](https://grafana.com/)
* [Open Telemetry (OTEL) Collector](https://opentelemetry.io/docs/collector/)
* [Prometheus](https://prometheus.io/)
* [Zipkin](https://zipkin.io/)

These compose files can be executed individually or as a group
```bash
docker-compose -f compose-zipkin.yaml -f compose-otel-collector.yaml -f compose-prometheus.yaml -f compose-grafana.yaml up
```