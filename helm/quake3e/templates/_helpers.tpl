{{- define "quake3e.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "quake3e.labels" -}}
app.kubernetes.io/name: quake3e
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "quake3e.selector" -}}
app.kubernetes.io/name: quake3e
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "quake3e.rconSecret" -}}
{{- default (printf "%s-rcon" (include "quake3e.fullname" .)) .Values.rcon.existingSecret -}}
{{- end -}}
