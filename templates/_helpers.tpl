{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mysql.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mysql.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate mysql certificate
*/}}
{{- define "mysql.mysql-certificate" }}
{{- if (not (empty .Values.ingress.mysql.certificate)) }}
{{- printf .Values.ingress.mysql.certificate }}
{{- else }}
{{- printf "%s-mysql-letsencrypt" (include "mysql.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mysql hostname
*/}}
{{- define "mysql.mysql-hostname" }}
{{- if (and .Values.config.mysql.hostname (not (empty .Values.config.mysql.hostname))) }}
{{- printf .Values.config.mysql.hostname }}
{{- else }}
{{- if .Values.ingress.mysql.enabled }}
{{- printf .Values.ingress.mysql.hostname }}
{{- else }}
{{- printf "%s-mysql" (include "mysql.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql base url
*/}}
{{- define "mysql.mysql-base-url" }}
{{- if (and .Values.config.mysql.baseUrl (not (empty .Values.config.mysql.baseUrl))) }}
{{- printf .Values.config.mysql.baseUrl }}
{{- else }}
{{- if .Values.ingress.mysql.enabled }}
{{- $hostname := ((empty (include "mysql.mysql-hostname" .)) | ternary .Values.ingress.mysql.hostname (include "mysql.mysql-hostname" .)) }}
{{- $path := (eq .Values.ingress.mysql.path "/" | ternary "" .Values.ingress.mysql.path) }}
{{- $protocol := (.Values.ingress.mysql.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "mysql.mysql-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate busybox hostname
*/}}
{{- define "mysql.busybox-hostname" }}
{{- if (and .Values.config.busybox.hostname (not (empty .Values.config.busybox.hostname))) }}
{{- printf .Values.config.busybox.hostname }}
{{- else }}
{{- printf "%s-busybox" (include "mysql.fullname" .) }}
{{- end }}
{{- end }}
