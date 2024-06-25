resource "aws_eks_cluster" "eksCluster" {
    name = "gs-eks"
    role_arn = aws_iam_role.eksClusterRole.arn
    version = "1.30"

    vpc_config {
        subnet_ids = ["subnet-064a39205efb5bb13", "subnet-0ef390357f7932ebe"]
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSClusterPolicyAttach,
        aws_iam_role_policy_attachment.AmazonEKSVPCResourceControllerAttach,
        aws_iam_role_policy_attachment.eksClusterKMSAccessRoleAttach
    ]
}

resource "aws_eks_node_group" "eksNodeGroup" {
    cluster_name = aws_eks_cluster.eksCluster.name
    node_group_name = "gs-nodegroup"
    node_role_arn = aws_iam_role.eksNodeGroupRole.arn
    subnet_ids = ["subnet-064a39205efb5bb13", "subnet-0ef390357f7932ebe"]

    ami_type = "AL2023_x86_64_STANDARD"
    disk_size = 30
    instance_types = [var.instance_type]

    scaling_config {
        desired_size = 2
        min_size =1
        max_size = 5
    }

    update_config {
        max_unavailable = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicyAttach,
        aws_iam_role_policy_attachment.AmazonEKSCNIPolicyAttach,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnlyAttach
    ]
}
