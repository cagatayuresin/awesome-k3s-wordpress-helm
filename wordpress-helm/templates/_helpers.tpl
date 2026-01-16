{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "wordpress.fullname" -}}
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
{{- define "wordpress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wordpress.labels" -}}
helm.sh/chart: {{ include "wordpress.chart" . }}
{{ include "wordpress.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wordpress.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wordpress.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
WordPress labels
*/}}
{{- define "wordpress.wordpress.labels" -}}
{{ include "wordpress.labels" . }}
app.kubernetes.io/component: wordpress
{{- end }}

{{/*
WordPress selector labels
*/}}
{{- define "wordpress.wordpress.selectorLabels" -}}
{{ include "wordpress.selectorLabels" . }}
app.kubernetes.io/component: wordpress
{{- end }}

{{/*
MySQL labels
*/}}
{{- define "wordpress.mysql.labels" -}}
{{ include "wordpress.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
MySQL selector labels
*/}}
{{- define "wordpress.mysql.selectorLabels" -}}
{{ include "wordpress.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Create the name of the namespace
*/}}
{{- define "wordpress.namespace" -}}
{{- .Values.namespace | default .Release.Namespace }}
{{- end }}

{{/*
Create MySQL service name
*/}}
{{- define "wordpress.mysql.serviceName" -}}
{{- printf "%s-mysql" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create WordPress service name
*/}}
{{- define "wordpress.wordpress.serviceName" -}}
{{- printf "%s-wordpress" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create secret name
*/}}
{{- define "wordpress.secretName" -}}
{{- printf "%s-secrets" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create MySQL PVC name
*/}}
{{- define "wordpress.mysql.pvcName" -}}
{{- printf "%s-mysql-data" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create WordPress PVC name
*/}}
{{- define "wordpress.wordpress.pvcName" -}}
{{- printf "%s-wordpress-data" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create certificate name
*/}}
{{- define "wordpress.certificateName" -}}
{{- printf "%s-tls" (include "wordpress.fullname" .) }}
{{- end }}

{{/*
Create TLS secret name
*/}}
{{- define "wordpress.tlsSecretName" -}}
{{- printf "%s-tls-secret" (include "wordpress.fullname" .) }}
{{- end }}
