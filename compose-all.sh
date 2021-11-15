#!/usr/bin/env bash
docker-compose -f compose-zipkin.yaml -f compose-otel-collector.yaml -f compose-prometheus.yaml -f compose-grafana.yaml $1