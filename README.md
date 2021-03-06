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
The script `compose-all.sh` incorporates all compose files
```bash
./compose-all.sh up #start
./compose-all.sh down #stop
```

## Grafana
Grafana is a web based tool for visualising dashboards/graphs on data it fetches from datasources.  
In this setup Grafana has been pre-configured ([datasource.yaml](grafana/datasources/datasource.yaml)) to use the dockerised Promethues as a datasource for fetching metric data.  

This allows you to play around creating dashboards on metrics scraped by Prometheus.   
You can even export dashboards from the UI to json files and store them under _./grafana/dashboards/_ this way the dashboards will be loaded during startup.

The user/password (_admin_/_secret_) to the UI is configured in the [compose-grafana.yaml](compose-grafana.yaml) file.  


## Open Telemetry (OTEL) Collector
Acts a collector/gateway for Open Telemetry data.   
In this setup it has only be configured ([otel-collector.yaml](otel-collector/otel-collector.yaml)) to receive trace data (not metric nor logging).   
Traces sent to this service will be logged to the console running the docker compose.  
The service listens to port `55690` on the local host, this is the port to send traces to.

Example of trace log:
```
2021-03-23T08:32:53.365Z        INFO    loggingexporter/logging_exporter.go:327 TracesExporter  {"#spans": 3}
2021-03-23T08:32:53.365Z        DEBUG   loggingexporter/logging_exporter.go:366 ResourceSpans #0
Resource labels:
     -> service.name: STRING(otlp-test-app)
     -> telemetry.sdk.name: STRING(kamon)
     -> telemetry.sdk.language: STRING(scala)
     -> telemetry.sdk.version: STRING(2.1.12)
     -> service.instance.id: STRING(xxx-yyy)
     -> env: STRING(staging)
     -> service.namespace: STRING(namespace-1)
     -> service.version: STRING(x.x.x)
InstrumentationLibrarySpans #0
InstrumentationLibrary kamon 2.1.12
Span #0
    Trace ID       : c2f8723d98431a6867ec0f4c416da008
    Parent ID      : 
    ID             : 00c76be115219aa8
    Name           : /purchase-item/{id}
    Kind           : SPAN_KIND_PRODUCER
    Start time     : 2021-03-23 08:32:48.218734795 +0000 UTC
    End time       : 2021-03-23 08:32:48.972185679 +0000 UTC
    Status code    : STATUS_CODE_OK
    Status message : 
Attributes:
     -> method: STRING(POST)
Span #1
    Trace ID       : c2f8723d98431a6867ec0f4c416da008
    Parent ID      : 00c76be115219aa8
    ID             : 1fd240d8d4635441
    Name           : add-order
    Kind           : SPAN_KIND_CLIENT
    Start time     : 2021-03-23 08:32:48.726453188 +0000 UTC
    End time       : 2021-03-23 08:32:48.971912872 +0000 UTC
    Status code    : STATUS_CODE_OK
    Status message : 
Attributes:
     -> method: STRING(put)
Span #2
    Trace ID       : c2f8723d98431a6867ec0f4c416da008
    Parent ID      : 00c76be115219aa8
    ID             : 5cc1fc597e1d7841
    Name           : check-credits
    Kind           : SPAN_KIND_CLIENT
    Start time     : 2021-03-23 08:32:48.231882663 +0000 UTC
    End time       : 2021-03-23 08:32:48.720293579 +0000 UTC
    Status code    : STATUS_CODE_OK
    Status message : 
Attributes:
     -> method: STRING(query)
```

## Prometheus
Prometheus is a service for scraping (over HTTP) metric data, storing it in a time series database.   
One can query this data using either a HTTP API or using the UI.   
Applications exposing metric data do so over HTTP (usually :9095/metrics).  
   
Prometheus needs to be configured ([prometheus.yaml](prometheus/prometheus.yaml)) with all end points it shall scrape.  
This example is pre-configured with one application running locally on your host exposing metrics on port _9095_.   
This has been achieved using a special feature in Docker allowing the app inside the docker to access the host outside the container.  
NOTE: `host.docker.internal` is confirmed to work on a Mac, unsure if it works on all O/S:es.
You may need to change the host to reflect the actual IP of your local machine.
```yaml
  - job_name: 'local-test-app'
    scrape_interval: 10s
    metrics_path: /metrics #not really needed as this is the default path
    static_configs:
      - targets: [ 'host.docker.internal:9095' ]
```
Refer to the [scrape configuration docs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for further details.

## Zipkin
Zipkin has a UI (see link below) allowing you to find traces exported by your app.   
The service listens to port `9411` on the local host, this is the port to send traces to.

## Local links
When starting the services these can be accessed via the following adresses:

* Grafana - [http://localhost:3000](http://localhost:3000)
* Open Telemetry (OTEL) Collector - Has no UI
* Prometheus - [http://localhost:9090](http://localhost:9090)
* Zipkin - [http://localhost:9411](http://localhost:9411)
