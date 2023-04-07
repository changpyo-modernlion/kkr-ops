{{/*
Expand the name of the chart.
*/}}
{{- define "admin-wallet-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "admin-wallet-api.fullname" -}}
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
{{- define "admin-wallet-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "admin-wallet-api.labels" -}}
helm.sh/chart: {{ include "admin-wallet-api.chart" . }}
{{ include "admin-wallet-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "admin-wallet-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "admin-wallet-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "admin-wallet-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "admin-wallet-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create kongplugin name of cors
*/}}
{{- define "admin-wallet-api.cors" -}}
{{ $fullName := include "admin-wallet-api.fullname" . }}
{{- printf "%s-%s" $fullName "cors" | trunc 63 }}
{{- end }}

{{/*
Create kongplugin name of validate auth server token
*/}}
{{- define "admin-wallet-api.validateAuthServerToken" -}}
{{ $fullName := include "admin-wallet-api.fullname" . }}
{{- printf "%s-%s" $fullName "validate-auth-server-token" | trunc 63 }}
{{- end }}
