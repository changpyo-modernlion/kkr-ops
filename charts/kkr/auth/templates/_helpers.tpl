{{/*
Expand the name of the chart.
*/}}
{{- define "auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "auth.fullname" -}}
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
{{- define "auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "auth.labels" -}}
helm.sh/chart: {{ include "auth.chart" . }}
{{ include "auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "auth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Datadog Labels
*/}}
{{- define "auth.datadogLabels" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels
*/}}
{{- define "auth.datadogSelectorLabels" -}}
{{ include "auth.datadogLabels" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}

{{/*
Datadog Labels For worker
*/}}
{{- define "auth.datadogLabelsForWorker" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}-worker
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels For worker
*/}}
{{- define "auth.datadogSelectorLabelsForWorker" -}}
{{ include "auth.datadogLabelsForWorker" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}

{{/*
Create kongplugin name of cors
*/}}
{{- define "auth.cors" -}}
{{ $fullName := include "auth.fullname" . }}
{{- printf "%s-%s" $fullName "cors" | trunc 63 }}
{{- end }}
