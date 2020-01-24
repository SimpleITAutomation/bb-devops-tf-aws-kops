locals {
    tags = {
        Terraform                 = "true"
        Environment               = var.environment
    }
    
    # We'll use a shorter environment name in order to keep things simple
    short_environment             = replace(var.environment, "apps-", "")
    
    # The name of the cluster
    base_domain_name              = "binbash.aws"
    k8s_cluster_name              = "cluster-kops-1.k8s.${local.short_environment}.${local.base_domain_name}"
    
    # The kubernetes version
    k8s_cluster_version           = "1.14.10"
    
    # Kops AMI Identifier
    kops_ami_id                   = "kope.io/k8s-1.14-debian-stretch-amd64-hvm-ebs-2019-09-26"
    
    # Tags that will be applied to all K8s Kops cluster instances
    cluster_tags                  = {
        "kubernetes.io/cluster/${local.k8s_cluster_name}" = "owned"
    }

    # Tags that will be applied to all K8s Kops Worker nodes
    node_cloud_labels             = {}

    # K8s Kops Master Nodes Machine (EC2) type and size + ASG Min-Max
    kops_master_machine_type      = "t2.medium"
    kops_master_machine_max_size  = 3
    kops_master_machine_min_size  = 3

    # K8s Kops Worker Nodes Machine (EC2) type and size + ASG Min-Max
    kops_worker_machine_type      = "t2.small"
    kops_worker_machine_max_size  = 5
    kops_worker_machine_min_size  = 2
}
