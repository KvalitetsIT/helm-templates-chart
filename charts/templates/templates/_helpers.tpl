{{- define "common.labels" -}}
app.kubernetes.io/managed-by: "Helm"
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end }}

{{- define "cnp.renderRules" -}}
{{- $rules := deepCopy .rules -}}
{{- range $rule := $rules -}}
{{- range $toPorts := $rule.toPorts | default (list) -}}
{{- range $port := $toPorts.ports | default (list) -}}
{{- $_ := set $port "protocol" (default "TCP" $port.protocol) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- toYaml $rules | nindent .indent -}}
{{- end }}