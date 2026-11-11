# HCL Dynamic Wiring Examples & Matrix (`last-verified: 2026-11-11`)

## 1. Anti-Pattern vs. Recommended Attribute Reference

```hcl
# ANTI-PATTERN: Hardcoded resource identifier
resource "oci_bastion_bastion" "bastion" {
  name             = "my-bastion"
  target_subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaauuz6jqxlsduhikx37zo33zm5thxybhb2ppx7ltvulhfhq6ralzoa"
}

# RECOMMENDED: Dynamic attribute reference (Implicit Dependency)
resource "oci_bastion_bastion" "bastion" {
  name             = "my-bastion"
  target_subnet_id = oci_core_subnet.public_subnet.id
}
```

## 2. Cross-Resource Wiring Matrix

| Resource Relationship | Required Dynamic Expression |
|---|---|
| Subnets & VNICs | `subnet_id = <resource>.<name>.id` |
| VPC / VCN | `vcn_id = oci_core_vcn.<name>.id` / `vpc_id = aws_vpc.<name>.id` |
| Security Groups / Lists | `security_list_ids = [oci_core_security_list.<name>.id]` / `security_group_ids = [aws_security_group.<name>.id]` |
| Gateways & Route Tables | `network_entity_id = <gateway>.id`, `route_table_id = <route_table>.id` |
| Block Storage Attachments | `instance_id = <instance>.id`, `volume_id = <volume>.id` |
