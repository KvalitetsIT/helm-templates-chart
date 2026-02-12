# Helm Templates Chart

This repository contains a generic Helm chart for rendering Kubernetes resources from values.
The chart is located at [`charts/templates`](charts/templates).

The chart is intentionally **generic**:

* It renders **nothing by default**
* Resources are created only when explicitly configured

---

## Design principles

The templates are designed to be as **Kubernetes-native** as possible:

* Value keys closely match the corresponding Kubernetes resource fields
* Resource structures follow the original API as closely as practical
* This reduces cognitive overhead and avoids introducing a custom abstraction layer

Some **light, opinionated defaults** are applied where Kubernetes already has common conventions, for example:

* Secret type defaults to `Opaque`
* Network protocol defaults to `TCP`

Beyond this, the chart avoids opinionated behavior.

---

## Repository structure

```text
.
├── charts/
│   └── templates/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-docs.yaml
│       ├── README.md.gotmpl
│       ├── README.md
│       ├── .helmignore
│       ├── templates/
│       └── ci/
│           ├── sealed-secrets-values.yaml
│           ├── network-policies-values.yaml
│           └── *-values.yaml
├── Makefile
├── ct.yaml
└── README.md
```

---

## Chart documentation (helm-docs)

Chart documentation is generated using
[helm-docs](https://github.com/norwoodj/helm-docs).

The generated chart README is composed from:

* Chart metadata in
  [`charts/templates/Chart.yaml`](charts/templates/Chart.yaml)
* Value descriptions in
  [`charts/templates/values-docs.yaml`](charts/templates/values-docs.yaml)
* Custom documentation in
  [`charts/templates/README.md.gotmpl`](charts/templates/README.md.gotmpl)
* Example values from
  [`charts/templates/ci/*-values.yaml`](charts/templates/ci)

---

## values.yaml vs values-docs.yaml vs ci/*-values.yaml

These files serve **different purposes** and are intentionally separated. 
Because resource configuration is map-based (keyed by resource name), an additional `values-docs.yaml` file is used to produce a meaningful Values table.

### values.yaml

* File: [`charts/templates/values.yaml`](charts/templates/values.yaml)
* Defines the **actual Helm defaults**
* Defaults are intentionally minimal or empty (for example `{}`)
* Used by Helm at install and upgrade time

### values-docs.yaml

* File: [`charts/templates/values-docs.yaml`](charts/templates/values-docs.yaml)
* Used **only for documentation**
* Required because the chart uses **maps instead of lists** for resources
* Allows helm-docs to expand map structures into a readable Values table
* Without this file, the generated README would contain minimal or unclear value paths
* Does **not** affect chart behavior

### ci/*-values.yaml

* Directory: [`charts/templates/ci`](charts/templates/ci)
* Concrete, copy-paste-friendly examples
* Used in `README.md.gotmpl` to show real-world configurations
* Do **not** affect chart behavior

---

## Custom chart documentation (README.md.gotmpl)

The chart defines a custom README template:

* File: [`charts/templates/README.md.gotmpl`](charts/templates/README.md.gotmpl)

This template is used to:

* Add usage documentation
* Describe supported resource types
* Embed example values from `ci/*-values.yaml`
* Control the structure of the generated README

---

## Generating documentation

Documentation is generated via the Makefile:

* File: [`Makefile`](Makefile)

Typical usage:

```sh
make docs
```

This will:

* Run `helm-docs` in a container
* Generate or update the chart README
* Use `values-docs.yaml` to expand map-based values into a readable Values table

---

## Adding new resources or examples

When adding a new resource type:

1. Add templates under
   [`charts/templates/templates`](charts/templates/templates)
2. Document values in
   [`charts/templates/values-docs.yaml`](charts/templates/values-docs.yaml)
3. Add usage documentation in
   [`charts/templates/README.md.gotmpl`](charts/templates/README.md.gotmpl)
4. Add one or more example values files under
   [`charts/templates/ci`](charts/templates/ci)

---

## Non-goals

This repository intentionally does **not**:

* Provide full application defaults
* Hide Kubernetes concepts
* Introduce a domain-specific abstraction layer
* Enforce business logic

It is designed to be a **reusable building block**, not a turnkey solution.