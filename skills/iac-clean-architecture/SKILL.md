---
name: iac-clean-architecture
description: >-
  Enforce zero hardcoded resource IDs, implicit DAG dependencies, and safe plan-only import workflows for OpenTofu and Terraform.
  WHEN: writing or reviewing `.tf` / HCL files, wiring OCI/AWS/Cloudflare resources, or importing existing cloud infrastructure with `tofu import`.
  WHEN NOT: working on non-HCL codebases or Ansible-only playbooks.
---

# Infrastructure as Code Clean Architecture (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p0`)](../../AGENTS.md#p0)

## Core Rules

1. **Zero Hardcoded Identifiers**: Never hardcode cloud resource IDs (OCI OCIDs, AWS ARNs, VPC/VCN IDs, subnet IDs, security group IDs, image IDs) in consuming blocks; always wire exported HCL attributes (`oci_core_subnet.public_subnet.id`, `aws_vpc.main.id`).
2. **Implicit DAG over `depends_on`**: Rely on attribute references to build the dependency graph and enable IDE `Go to Definition`. Use `depends_on` only for hidden non-attribute side effects (such as IAM propagation delays).

## Pre-Existing Infrastructure Import Procedure

1. Back up state before importing:
   ```bash
   cp terraform.tfstate terraform.tfstate.bak_$(date +%s)
   ```
2. Query the cloud provider CLI (`oci network subnet get`, `aws ec2 describe-subnets`) or state to inspect exact live resource attributes (`cidr_block`, `dns_label`, `display_name`, `route_table_id`).
3. Write declarative HCL resource blocks using dynamic attribute references.
4. Import the resource into state:
   ```bash
   tofu import <resource_type>.<name> <cloud_resource_id>
   ```
5. Run `tofu plan` iteratively and tune arguments or `lifecycle` blocks until output states `No changes. Your infrastructure matches the configuration`.
6. Never run `tofu apply` or `terraform apply` during import alignment; stop immediately once `tofu plan` reports zero changes.

## Reference Details (P3)

- HCL anti-pattern vs recommended examples & wiring matrix: [wiring-examples.md](./references/wiring-examples.md)
