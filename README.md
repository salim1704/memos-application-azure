# Azure Container Apps — Memos Deployment

## Overview

An end-to-end Azure Container Apps deployment of a privacy-focused memo application, built using Docker, Terraform, and GitHub Actions to automate infrastructure provisioning and application delivery.

---

## Live Application



---

## Key Features

- Infrastructure as Code using Terraform (modular design)
- Multi-stage Docker build (86% image size reduction)
- OIDC-based CI/CD (no stored cloud credentials)
- Azure Container Apps (zone-redundant environment)
- Azure Front Door (Standard tier) with managed TLS
- Azure Container Registry (admin disabled)
- User-assigned Managed Identity for secure image pulls
- Log Analytics + Azure Managed Grafana observability dashboard
- Remote Terraform state with blob versioning

---

## Architecture

<!-- Add architecture diagram here -->
<img width="817" height="631" alt="image" src="https://github.com/user-attachments/assets/664759e4-3c0a-4155-bfc8-af9a81e614ce" />




### Edge Layer — Azure Front Door

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/393124c1-e734-49b3-9341-0a00b73ad58f" />

### Infrastructure Components

- **Compute:** Azure Container Apps (Consumption plan, zone-redundant)
- **Networking:** VNet with delegated subnet + NSG
- **Edge/CDN:** Azure Front Door Standard with managed TLS
- **Registry:** Azure Container Registry (Basic tier)
- **Identity:** User-assigned managed identity (AcrPull role)
- **Monitoring:** Log Analytics workspace + Azure Managed Grafana
- **State Backend:** Azure Storage with blob versioning

## Repository Structure

```
memos-application-azure
├── docker/                          # Multi-stage Dockerfile
│   └── Dockerfile
├── app/                             # Application source code
├── terraform-bootstrap/             # Azure Storage backend for remote state
│   └── main.tf
├── terraform/                       # Infrastructure (modular)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── modules/
│       ├── resource_group/          # Resource group
│       ├── vnet/                    # VNet, subnet, NSG
│       ├── monitoring/              # Log Analytics workspace
│       ├── acr/                     # Azure Container Registry
│       ├── identity/                # Managed identity + role assignment
│       ├── container_app/           # Container Apps environment + app
│       ├── front_door/              # Front Door + custom domain + TLS
│       └── grafana/                 # Azure Managed Grafana
├── .github/
│   └── workflows/                   # CI/CD pipelines
│       ├── apply.yaml               # Provision infrastructure
│       ├── deploy.yaml              # Build, scan, push, deploy
│       └── destroy.yaml             # Teardown infrastructure
└── README.md
```
## Containerisation

### Docker Implementation

- Multi-stage Dockerfile
- Reduced image size from ~1.44GB to ~200MB
- Runs as non-root (UID 1000)
- Restricted file permissions
- Tested locally before deployment

<!-- ![Docker Build](screenshots/docker-build.png) -->

---

## Terraform Infrastructure

### Azure Resource Group

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/a7f557d3-c7eb-4667-9e7a-e61f82da3ba9" />

### Bootstrap (One-Time Setup)

- Azure Storage account for remote state
- Blob versioning enabled for state recovery
- Persists across apply/destroy cycles

### Core Infrastructure Modules

- Resource group
- VNet (10.0.0.0/16) with /21 delegated subnet
- Log Analytics workspace
- Azure Container Registry
- Managed identity and role assignments
- Container Apps environment and application
- Azure Front Door with custom domain and TLS
- Azure Managed Grafana

### Implementation Details

- Zone-redundant Container Apps environment
- NSG restricts inbound traffic to Azure Front Door only
- Managed identity used for ACR authentication
- Dynamic registry configuration to solve image deployment dependency ordering

<!-- ![Resource Group](screenshots/resource-group.png) -->

---

## CI/CD Automation

### Infrastructure Workflow (`apply.yaml`)

- Terraform init
- Validate
- Plan
- Apply

Triggered manually.

### Deployment Workflow (`deploy.yaml`)

Triggered automatically after successful infrastructure provisioning.

Pipeline stages:

- Build Docker image (commit SHA tag)
- Security scan via Trivy (CRITICAL severity)
- Push to Azure Container Registry
- Update Container App image via Azure CLI

<!-- ![CI/CD](screenshots/workflows.png) -->

---

## Security

- OIDC authentication (GitHub → Azure)
- No stored cloud credentials
- Managed identity for image pulls
- ACR admin access disabled
- HTTPS enforced via Front Door
- Minimum TLS 1.2
- Trivy vulnerability scanning on every deploy
- NSG restricts traffic to Azure Front Door service tag

<!-- ![TLS](screenshots/tls.png) -->

---

## Monitoring & Observability

- Log Analytics workspace (30-day retention)
- Azure Managed Grafana connected via managed identity
- Monitoring Reader role scoped to resource group

### Dashboard Panels

- Container log volume (time series)
- Recent errors (table)

<img width="1915" height="842" alt="grafana" src="https://github.com/user-attachments/assets/b97cd9b1-b45d-411c-b7c3-8f04cf627c13" />


## Tech Stack

- Azure (Container Apps, ACR, Front Door, VNet, Log Analytics, Managed Identity, Managed Grafana, Storage)
- Terraform (modular architecture)
- Docker (multi-stage builds)
- GitHub Actions (OIDC-based CI/CD)
- Trivy (image security scanning)

---

## Lessons Learned

- Azure Container Apps abstracts Kubernetes complexity while enforcing architectural constraints
- Zone-redundant environments require minimum subnet sizing and workload profile configuration
- Managed identities remove credential management overhead entirely
- Front Door custom domains require DNS validation before TLS provisioning
- Azure resource destruction for global services can take significant time
- Dynamic Terraform blocks solve image dependency ordering issues
- Resource providers must be registered before first use
