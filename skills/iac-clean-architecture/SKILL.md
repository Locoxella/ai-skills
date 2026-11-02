---
name: iac-clean-architecture
description: >-
  Standard and best practices for OpenTofu and Terraform IaC development.
  Enforces zero-hardcoding of resource IDs (OCIDs, ARNs, VPC/Subnet IDs), dynamic
  attribute references, implicit dependency graphs, interactive IDE navigation, and safe
  import methodology for pre-existing cloud infrastructure.
---

# Infrastructure as Code (OpenTofu & Terraform) Best Practices

This skill outlines mandatory development practices for Terraform and OpenTofu across all repositories and cloud providers (OCI, AWS, GCP, Cloudflare, etc.).

## 1. Golden Rule: Zero Hardcoded Resource Identifiers
Hardcoding static resource IDs (e.g. AWS ARNs, OCI OCIDs, VPC/Subnet IDs, AMI/Image IDs) inside resource arguments is strictly prohibited.

```hcl
# ❌ ANTI-PATTERN: Hardcoded resource identifier
resource "oci_bastion_bastion" "bastion" {
  name             = "my-bastion"
  target_subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaauuz6jqxlsduhikx37zo33zm5thxybhb2ppx7ltvulhfhq6ralzoa"
}

# ✅ RECOMMENDED: Dynamic attribute reference (Implicit Dependency)
resource "oci_bastion_bastion" "bastion" {
  name             = "my-bastion"
  target_subnet_id = oci_core_subnet.public_subnet.id
}
```

## 2. Leverage Implicit Dependencies
Terraform and OpenTofu construct their dependency graph (DAG) by analyzing attribute references between blocks.

- **Always prefer implicit dependencies**: Referencing `oci_core_subnet.public_subnet.id` or `aws_vpc.main.id` guarantees that the provider manages lifecycle order properly.
- **Interactive Code Navigation**: Referencing resource attributes allows developers and IDEs to jump directly to definitions (`Go to Definition`).
- **Minimize `depends_on`**: Do not use `depends_on` as a substitute for passing resource references. Restrict `depends_on` only to hidden side effects (e.g., waiting for an IAM role propagation or CloudWatch log group creation).

## 3. Pre-existing Infrastructure Import Methodology (CRITICAL WORKFLOW)
When bringing pre-existing infrastructure under IaC management:

### ⚠️ Strict Safety Directives
- **NEVER RUN `apply` DURING IMPORT ITERATIONS**: Running `apply` against pre-existing resources with an incomplete or drifting HCL schema can cause accidental resource destruction, downtime, or unwanted updates.
- **Iterative `plan`-Only Alignment**: Always use `plan` repeatedly until output reaches `No changes. Your infrastructure matches the configuration`.

### Standard Import Workflow:
1. **State Backup**:
   Always back up the existing state before importing:
   ```bash
   cp terraform.tfstate terraform.tfstate.bak_$(date +%s)
   ```
2. **Inspect Existing Attributes via Cloud CLI / State**:
   Query provider CLI (e.g. `oci network subnet get`, `aws ec2 describe-subnets`) or inspect state attributes to gather precise parameters (`cidr_block`, `dns_label`, `display_name`, `route_table_id`).
3. **Declare Clean HCL Blocks**:
   Write resource declarations as if creating from scratch, wiring dynamic dependencies (`vcn_id = oci_core_vcn.net.id`, `route_table_id = oci_core_route_table.rt.id`).
4. **Import Resource into State**:
   ```bash
   tofu import <resource_type>.<name> <cloud_resource_id>
   ```
5. **Run Plan to Detect Drift**:
   ```bash
   tofu plan
   ```
6. **Tune Declarations**:
   Adjust optional arguments, lifecycle ignores, or default resource management blocks until `tofu plan` reports **zero changes** (`No changes`).
7. **Do NOT run apply**:
   Once `plan` reports 0 changes, the state and code are perfectly aligned with live infrastructure without risk of modification.

## 4. Cross-Resource Wiring Matrix
Common attribute references to always wire dynamically:
- **Subnets & VNICs**: `subnet_id = <resource>.<name>.id`
- **VPC / VCN**: `vcn_id = oci_core_vcn.<name>.id` / `vpc_id = aws_vpc.<name>.id`
- **Security Groups / Lists**: `security_list_ids = [oci_core_security_list.<name>.id]`
- **Gateways & Route Tables**: `network_entity_id = <gateway>.id`, `route_table_id = <route_table>.id`
- **Block Storage Attachments**: `instance_id = <instance>.id`, `volume_id = <volume>.id`
