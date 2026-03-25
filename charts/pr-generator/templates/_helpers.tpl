{{/*
Expand the name of the chart.
*/}}
{{- define "pr-generator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "pr-generator.fullname" -}}
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
Create chart label.
*/}}
{{- define "pr-generator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "pr-generator.labels" -}}
helm.sh/chart: {{ include "pr-generator.chart" . }}
{{ include "pr-generator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "pr-generator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pr-generator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Validate that at least one provider is enabled.
Fails helm install/upgrade at template rendering time rather than at runtime.
*/}}
{{- define "pr-generator.validateProviders" -}}
{{- if and (not .Values.config.providers.github.enabled) (not .Values.config.providers.bitbucket.enabled) -}}
{{- fail "At least one provider must be enabled. Set config.providers.github.enabled=true or config.providers.bitbucket.enabled=true." -}}
{{- end -}}
{{- end }}
