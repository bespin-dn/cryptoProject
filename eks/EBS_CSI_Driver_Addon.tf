resource "aws_eks_addon" "ebs_csi_driverAddOn" {
    Cluster_name = aws_eks_cluster.eksCluster.name
    addon_name = "aws-ebs-csi-driver"
    addon_version = ""v1.32.0-eksbuild.1""
    service_account_role_arn = ""
}