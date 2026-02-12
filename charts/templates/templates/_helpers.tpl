{{- define "common.labels" -}}
app.kubernetes.io/managed-by: "Helm"
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end }}

{{- define "cnp.applyDefaultPortProtocols" -}}
{{- range (concat (.ingress | default (list)) (.egress | default (list))) -}}
  {{- range (.toPorts | default (list)) -}}
    {{- range (.ports | default (list)) -}}
     {{- $_ := set . "protocol" (default "TCP" .protocol) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end }}
