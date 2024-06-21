## Create EKS Cluster IAM Role
data "aws_iam_policy_document" "eksClusterAssumeRole" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["eks.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "eksClusterRole" {
    name = "GSEKSClusterRole"
    assume_role_policy = data.aws_iam_policy_document.eksClusterAssumeRole.json
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicyAttach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eksClusterRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceControllerAttach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role = aws_iam_role.eksClusterRole.name
}


## Create EKS NodeGroup IAM Role
data "aws_iam_policy_document" "eksNodeGroupAssumeRole" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "eksNodeGroupRole" {
    name = "GSEKSNodeGroupRole"
    assume_role_policy = data.aws_iam_policy_document.eksNodeGroupAssumeRole.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicyAttach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eksNodeGroupRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSCNIPolicyAttach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eksNodeGroupRole.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnlyAttach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eksNodeGroupRole.name
}