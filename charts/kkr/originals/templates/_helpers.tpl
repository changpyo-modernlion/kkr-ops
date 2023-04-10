{{/*
Expand the name of the chart.
*/}}
{{- define "originals.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "originals.fullname" -}}
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
{{- define "originals.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "originals.labels" -}}
helm.sh/chart: {{ include "originals.chart" . }}
{{ include "originals.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "originals.selectorLabels" -}}
app.kubernetes.io/name: {{ include "originals.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "originals.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "originals.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Datadog Labels
*/}}
{{- define "originals.datadogLabels" -}}
tags.datadoghq.com/env: {{ .Release.Namespace }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Chart.Version }}
{{- end }}

{{/*
Datadog selectorLabels
*/}}
{{- define "originals.datadogSelectorLabels" -}}
{{ include "originals.datadogLabels" . }}
admission.datadoghq.com/enabled: "true"
admission.datadoghq.com/config.mode: "socket"
{{- end }}

{{/*
Create kongplugin name of cors
*/}}
{{- define "originals.cors" -}}
{{ $fullName := include "originals.fullname" . }}
{{- printf "%s-%s" $fullName "cors" | trunc 63 }}
{{- end }}

{{/*
Create kongplugin name of validate auth server token
*/}}
{{- define "originals.validateAuthServerToken" -}}
{{ $fullName := include "originals.fullname" . }}
{{- printf "%s-%s" $fullName "validate-auth-server-token" | trunc 63 }}
{{- end }}
