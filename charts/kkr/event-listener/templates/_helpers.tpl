{{/*
Expand the name of the chart.
*/}}
{{- define "event-listener.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "event-listener.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "event-listener.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "event-listener.labels" -}}
helm.sh/chart: {{ include "event-listener.chart" . }}
{{ include "event-listener.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "event-listener.selectorLabels" -}}
app.kubernetes.io/name: {{ include "event-listener.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "event-listener.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "event-listener.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Datadog Labels
*/}}
{{- define "event-listener.datadogLabels" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels
*/}}
{{- define "event-listener.datadogSelectorLabels" -}}
{{ include "event-listener.datadogLabels" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}