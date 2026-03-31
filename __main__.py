"""Claims processing staging environment on Azure.

Uses pre-built Terraform module wrappers for networking, AKS, PostgreSQL,
and blob storage.  All inter-module references are wired as Pulumi outputs
so that dependency ordering is automatic.
"""

import pulumi
import pulumi_demo_network as demo_network
import pulumi_app_cluster as app_cluster
import pulumi_app_database as app_database
import pulumi_app_storage as app_storage

# ---------------------------------------------------------------------------
# 1. Networking foundation
# ---------------------------------------------------------------------------
network = demo_network.Module(
    "demo-network",
    app_name="claims-processing",
    environment="staging",
    location="eastus",
)

# ---------------------------------------------------------------------------
# 2. AKS cluster
#
# NOTE: The generated TF-module SDKs type all outputs as Output[Optional[Any]]
# while consuming modules expect Input[str].  The values are always populated
# strings at runtime, so the type: ignore annotations are safe here.
# ---------------------------------------------------------------------------
cluster = app_cluster.Module(
    "app-cluster",
    app_name="claims-processing",
    environment="staging",
    node_count=3,
    resource_group_name=network.resource_group_name,  # type: ignore[arg-type]
    location=network.location,  # type: ignore[arg-type]
    subnet_id=network.aks_subnet_id,  # type: ignore[arg-type]
)

# ---------------------------------------------------------------------------
# 3. PostgreSQL Flexible Server
# ---------------------------------------------------------------------------
database = app_database.Module(
    "app-database",
    app_name="claims-processing",
    environment="staging",
    sku_name="B_Standard_B2ms",
    storage_mb=65536,
    resource_group_name=network.resource_group_name,  # type: ignore[arg-type]
    location=network.location,  # type: ignore[arg-type]
    delegated_subnet_id=network.postgresql_subnet_id,  # type: ignore[arg-type]
    private_dns_zone_id=network.postgresql_dns_zone_id,  # type: ignore[arg-type]
)

# ---------------------------------------------------------------------------
# 4. Blob storage account
# ---------------------------------------------------------------------------
storage = app_storage.Module(
    "app-storage",
    app_name="claims-processing",
    environment="staging",
    versioning_enabled=True,
    resource_group_name=network.resource_group_name,  # type: ignore[arg-type]
    location=network.location,  # type: ignore[arg-type]
)

# ---------------------------------------------------------------------------
# 5. Stack outputs
# ---------------------------------------------------------------------------
pulumi.export("cluster_name", cluster.cluster_name)
pulumi.export("kubeconfig_command", cluster.kubeconfig_command)
pulumi.export("db_fqdn", database.db_fqdn)
pulumi.export("db_username", database.db_username)
pulumi.export("storage_account_name", storage.storage_account_name)
pulumi.export("storage_blob_endpoint", storage.primary_blob_endpoint)
