module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 21.0"
    
    name = "${local.name}-cluster"
    kubernetes_version = "1.32"

    endpoint_public_access = true
    iam_role_arn = aws_iam_role.eks_cluster.arn
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets
    
    addons = {
        vpc-cni = {
            most_recent = true
            resolve_conflicts = "OVERWRITE"
        }
        kube-proxy = {
            most_recent = true
            resolve_conflicts = "OVERWRITE"
        }
        coredns = {
            most_recent = true
            resolve_conflicts = "OVERWRITE"
        }
    }

    access_entries = {
        amitrana = {
            principal_arn = "arn:aws:iam::727646469309:user/amitrana"
            policy_associations = {
                admin = {
                    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
                    access_scope = {
                        type = "cluster"
                    }
                }
            }
        }
    }     
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name = module.eks.cluster_name
  node_group_name = "${local.name}-node-group"
  node_role_arn = aws_iam_role.eks_node_group.arn
  subnet_ids = module.vpc.private_subnets
  version = "1.32"
  instance_types = ["t3.medium"]
  
  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
    aws_iam_role_policy_attachment.eks_ecr_public_policy,
    aws_iam_role_policy_attachment.eks_secretmaager_policy
  ]
}