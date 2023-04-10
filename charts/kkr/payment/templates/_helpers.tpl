{{/*
Expand the name of the chart.
*/}}
{{- define "payment.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "payment.fullname" -}}
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
{{- define "payment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "payment.labels" -}}
helm.sh/chart: {{ include "payment.chart" . }}
{{ include "payment.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "payment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "payment.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "payment.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "payment.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Datadog Labels
*/}}
{{- define "payment.datadogLabels" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels
*/}}
{{- define "payment.datadogSelectorLabels" -}}
{{ include "payment.datadogLabels" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}

{{/*
Create kongplugin name of cors
*/}}
{{- define "payment.cors" -}}
{{ $fullName := include "payment.fullname" . }}
{{- printf "%s-%s" $fullName "cors" | trunc 63 }}
{{- end }}

{{/*
Create kongplugin name of validate auth server token
*/}}
{{- define "payment.validateAuthServerToken" -}}
{{ $fullName := include "payment.fullname" . }}
{{- printf "%s-%s" $fullName "validate-auth-server-token" | trunc 63 }}
{{- end }}
