{{/*
Expand the name of the chart.
*/}}
{{- define "backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "backend.fullname" -}}
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

{{- define "backend.hostname" -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "backend.labels" -}}
helm.sh/chart: {{ include "backend.chart" . }}
{{ include "backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "backend.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Datadog Labels
*/}}
{{- define "backend.datadogLabels" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels
*/}}
{{- define "backend.datadogSelectorLabels" -}}
{{ include "backend.datadogLabels" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}

{{/*
Create kongplugin name of cors
*/}}
{{- define "backend.cors" -}}
{{ $fullName := include "backend.fullname" . }}
{{- printf "%s-%s" $fullName "cors" | trunc 63 }}
{{- end }}

{{/*
Create kongplugin name of validate auth server token
*/}}
{{- define "backend.validateAuthServerToken" -}}
{{ $fullName := include "backend.fullname" . }}
{{- printf "%s-%s" $fullName "validate-auth-server-token" | trunc 63 }}
{{- end }}

{{/*
Create kongplugin name of upstream timeout setting
*/}}
{{- define "backend.upstreamTimeout" -}}
{{ $fullName := include "backend.fullname" . }}
{{- printf "%s-%s" $fullName "upstream-timeout" | trunc 63 }}
{{- end }}
