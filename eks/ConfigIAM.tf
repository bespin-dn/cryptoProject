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

## Create KMS Policy and Role
resource "aws_iam_policy" "eksClusterKMSAccessPolicy" {
    name = "GSEKSClusterKMSAccessPolicy"
    description = "GSEKSClusterKMSAccessPolicy by terraform"

    policy = jsonencode({
        Version: "2012-10-17",
        Statement: [
            {
                Effect: "Allow",
                Action: [
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:GenerateDataKey"
                ],
                Resource: "arn:aws:kms:ap-southeast-2:603229842386:key/5d32d411-248d-4a7c-90ec-f88d37741a08"
            }
        ]
    })

}
resource "aws_iam_role_policy_attachment" "eksClusterKMSAccessRoleAttach" {
    policy_arn = aws_iam_policy.eksClusterKMSAccessPolicy.arn
    role = aws_iam_role.eksClusterRole.name
}