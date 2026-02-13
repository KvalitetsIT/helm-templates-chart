{{- define "common.labels" -}}
app.kubernetes.io/managed-by: "Helm"
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end }}

{{- define "cnp.applyDefaultPorts" -}}
{{- range (concat (.ingress | default (list)) (.egress | default (list))) -}}
  {{- range (.toPorts | default (list)) -}}
    {{- range (.ports | default (list)) -}}
      {{- $_ := set . "protocol" (default "TCP" .protocol) -}}
      {{- $_ := set . "port" (required "Port is required" .port | toString) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end }}

{{- define "common.metadata" -}}
{{- $metadata := (default dict .metadata) -}}
{{- if and .name (not (hasKey $metadata "name")) -}}
{{- $_ := set $metadata "name" .name -}}
{{- end -}}
{{- if and .namespace (not (hasKey $metadata "namespace")) -}}
{{- $_ := set $metadata "namespace" .namespace -}}
{{- end -}}
{{- toYaml $metadata -}}
{{- end }}
