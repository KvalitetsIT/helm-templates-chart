# templates

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Generic Helm chart for rendering Kubernetes resources from values. The chart renders nothing by default; resources are created only when explicitly configured.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| KvalitetsIT | <kithosting@kvalitetsit.dk> | <https://github.com/KvalitetsIT/helm-repo> |

## Values

### Sealed Secrets

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sealedSecrets | object | {} | Map of SealedSecret resources. Each key becomes the SealedSecret name. See [Sealed Secrets examples](#sealed-secrets) for usage. |
| sealedSecrets.\<example-secret>.metadata.name | string | "" | Optional. Override the rendered SealedSecret name. |
| sealedSecrets.\<example-secret>.metadata.namespace | string | "" | Optional. Override the rendered SealedSecret namespace. |
| sealedSecrets.\<example-secret>.encryptedData.\<secret-key> | string | {} | Required. Encrypted secret data. |
| sealedSecrets.\<example-secret>.template.type | string | "Opaque" | Optional. Kubernetes Secret type. |
| sealedSecrets.\<example-secret>.template.metadata.labels | object | {} | Optional. Additional labels for the Secret template. common.labels are always included. |
| sealedSecrets.\<example-secret>.template.metadata.annotations | object | {} | Optional. Annotations for the Secret template metadata. |
| sealedSecrets.\<example-secret>.template.data.\<data-key> | string | {} | Optional. Additional data fields for the Secret template. |

### Network Policies

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| networkPolicies.\<example-network-policy>.podSelector | object | {} | Required. Pod selector for the policy. Use {} to select all pods. |
| networkPolicies.\<example-network-policy>.policyTypes | list | [] | Optional. Policy types for the NetworkPolicy. |
| networkPolicies.\<example-network-policy>.ingress | list | [] | Optional. Ingress rules for the policy. |
| networkPolicies.\<example-network-policy>.egress | list | [] | Optional. Egress rules for the policy. |

### Cilium Network Policies

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ciliumNetworkPolicies | object | {} | Map of CiliumNetworkPolicy resources to render (Cilium CRDs). See [Cilium Network Policies examples](#cilium-network-policies) for usage. |
| ciliumNetworkPolicies.\<example-cnp>.metadata.name | string | "" | Optional. Override the rendered CiliumNetworkPolicy name. |
| ciliumNetworkPolicies.\<example-cnp>.metadata.namespace | string | "" | Optional. Override the rendered CiliumNetworkPolicy namespace. |
| ciliumNetworkPolicies.\<example-cnp>.description | string | "" | Optional. Description of the Cilium Network Policy. |
| ciliumNetworkPolicies.\<example-cnp>.endpointSelector | object | {} | Required. Endpoint selector for the policy. Use {} to select all endpoints. |
| ciliumNetworkPolicies.\<example-cnp>.ingress | list | [] | Optional. Ingress rules for the policy. |
| ciliumNetworkPolicies.\<example-cnp>.egress | list | [] | Optional. Egress rules for the policy. |

### Traefik Middlewares

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| traefikMiddlewares | object | {} | Map of Traefik Middleware resources to render (Traefik CRDs). See [Traefik Middlewares examples](#traefik-middlewares) for usage. |
| traefikMiddlewares.\<example-middleware>.metadata.name | string | "" | Optional. Override the rendered Middleware name. |
| traefikMiddlewares.\<example-middleware>.metadata.namespace | string | "" | Optional. Override the rendered Middleware namespace. |
| traefikMiddlewares.\<example-middleware>.spec | object | {} | Required. Middleware spec. |

### Resources

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| resources | object | {} | Map of Kubernetes resources to render as-is. Each key becomes the default metadata.name if not provided. |
| resources.example.metadata.name | string | "" | Optional. Override the rendered resource name. |
| resources.example.metadata.namespace | string | "" | Optional. Override the rendered resource namespace. |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| networkPolicies | object | {} | Map of Kubernetes NetworkPolicy resources to render. Each top-level key becomes the NetworkPolicy name. |

## Usage

This is a generic resource chart.
By default, it renders nothing.

Define resources like the sections below to enable rendering.

### Sealed Secrets

Renders Bitnami `SealedSecret` resources.
Each entry requires `encryptedData`. The `template` block is optional.
You can override the rendered resource name and namespace via `metadata.name` and `metadata.namespace`.

#### Examples:

```yaml
sealedSecrets:
  first-secret:
    encryptedData:
      ENV_VAR_ONE: dmVyeS1zZWNyZXQtZW52MDEyMzQ1Njc4OQ==

  second-secret:
    encryptedData:
      ENV_VAR_TWO: dmVyeS1zZWNyZXQtZW52MDEyMzQ1Njc4OQ==
    template:
      type: Opaque
      metadata:
        labels:
          app.kubernetes.io/name: app-two
          team: platform
        annotations:
          app.kubernetes.io/managed-by: "sealed-secrets"
          config.kubernetes.io/version: "1"

  third-secret:
    encryptedData:
      tls.crt: dmVyeS1zZWNyZXQtdGxzLWNydDAxMjM0NTY3ODk=
      tls.key: dmVyeS1zZWNyZXQtdGxzLWtleTAxMjM0NTY3ODk=
    template:
      type: kubernetes.io/tls

  fourth-secret:
    encryptedData:
      password: dmVyeS1zZWNyZXQtZW52MDEyMzQ1Njc4OQ==
    template:
      data:
        conn_string: "postgresql://user:{{ .password }}@localhost/mydatabase"

  fifth-secret:
    encryptedData:
      ENV_VAR_FIVE: dmVyeS1zZWNyZXQtZW52MDEyMzQ1Njc4OQ==
    metadata:
      name: custom-secret-name
      namespace: custom-namespace

```

### Cilium Network Policies

Renders Cilium `CiliumNetworkPolicy` resources.
Each entry requires `endpointSelector`. The other fields is optional.
You can override the rendered resource name and namespace via `metadata.name` and `metadata.namespace`.

#### Examples:

```yaml
ciliumNetworkPolicies:
  default-deny:
    description: "Default deny all ingress and egress traffic"
    endpointSelector: {}
    ingress:
      - {}
    egress:
      - {}

  app-1-netpol:
    endpointSelector:
      matchLabels:
        app: app-2
    ingress:
      - fromEndpoints:
          - matchLabels:
              app: app-1
    egress:
      - toEndpoints:
          - matchLabels:
              app: app-3
        toPorts:
          - ports:
              - port: "80"

  app-2-netpol:
    endpointSelector:
      matchLabels:
        app: app-3
    ingress:
      - fromEndpoints:
          - matchLabels:
              app: app-1
          - matchLabels:
              app: app-2
    egress:
      - toEndpoints:
          - matchLabels:
              app: app-1
        toPorts:
          - ports:
              - port: 5321
                protocol: UDP

  dns-policy:
    description: "Allow egress DNS traffic to kube-dns"
    endpointSelector: {}
    egress:
      - toEndpoints:
          - matchLabels:
              "k8s:io.kubernetes.pod.namespace": kube-system
              "k8s:k8s-app": kube-dns
        toPorts:
          - ports:
              - port: "53"
                protocol: UDP
              - port: "53"
                protocol: TCP
            rules:
              dns:
                - matchPattern: "*"

  custom-namespace:
    metadata:
      name: custom-namespace-policy
      namespace: custom-namespace
    description: "Allow all traffic within the custom namespace"
    endpointSelector:
      matchLabels:
        "k8s:io.kubernetes.pod.namespace": custom-namespace
    ingress:
      - fromEndpoints:
          - matchLabels:
              "k8s:io.kubernetes.pod.namespace": custom-namespace
    egress:
      - toEndpoints:
          - matchLabels:
              "k8s:io.kubernetes.pod.namespace": custom-namespace

```

### Network Policies

Renders Kubernetes `NetworkPolicy` resources.
Each entry requires `podSelector`. The other fields are optional.
You can override the rendered resource name and namespace via `metadata.name` and `metadata.namespace`.

#### Examples:

```yaml
networkPolicies:
  default-deny:
    podSelector: {}
    policyTypes:
      - Ingress
      - Egress

  app-1-netpol:
    podSelector:
      matchLabels:
        app: app-1
    ingress:
      - from:
          - podSelector:
              matchLabels:
                app: app-2
          - podSelector:
              matchLabels:
                app: app-3
    egress:
      - {}

  app-2-netpol:
    podSelector:
      matchLabels:
        app: app-2
    ingress:
      - from:
          - podSelector:
              matchLabels:
                app: app-1
    egress:
      - to:
          - podSelector:
              matchLabels:
                app: app-3
        ports:
          - port: 80

  app-3-netpol:
    podSelector:
      matchLabels:
        app: app-3
    ingress:
      - from:
          - podSelector:
              matchLabels:
                app: app-1
          - podSelector:
              matchLabels:
                app: app-2
    egress:
      - to:
          - podSelector:
              matchLabels:
                app: app-1
        ports:
          - port: 5321
            protocol: UDP

  custom-namespace-and-labels:
    metadata:
      name: custom-netpol
      namespace: custom-namespace
      labels:
        custom-label: custom-value
    podSelector:
      matchLabels:
        app: app-1
    ingress:
      - from:
          - podSelector:
              matchLabels:
                app: app-2
    egress:
      - to:
          - podSelector:
              matchLabels:
                app: app-3
        ports:
          - port: 80

```

### Traefik Middlewares

Renders Traefik `Middleware` resources (`traefik.io/v1alpha1`).
Each entry requires `spec`.
You can override the rendered resource name and namespace via `metadata.name` and `metadata.namespace`.

#### Examples:

```yaml
traefikMiddlewares:
  deny-v1-internal:
    spec:
      ipAllowList:
        sourceRange: []

  allow-office-and-vpn:
    metadata:
      name: allow-office-and-vpn
      namespace: custom-namespace
      labels:
        owner: platform
    spec:
      ipAllowList:
        sourceRange:
          - 192.0.2.10/32
          - 198.51.100.0/24

```

### Resources

Renders arbitrary resources from a map keyed by resource name.
The key is used as the default `metadata.name` if not provided.
Override the rendered resource name and namespace with `metadata.name` and `metadata.namespace`.

```yaml
resources:
  example:
    apiVersion: v1
    kind: ConfigMap
    data:
      value: hello

  another:
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: custom-name
      namespace: custom-namespace
    data:
      value: world

```

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
