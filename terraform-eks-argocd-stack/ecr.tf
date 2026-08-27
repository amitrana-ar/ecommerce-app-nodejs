module "ecr" {
    source = "terraform-aws-modules/ecr/aws"
    
    for_each = toset(var.repo_name)

    repository_name = each.value
    repository_read_access_arns = [aws_iam_role.eks_node_group.arn]
    tags = {
        name = local.name
        Environment = local.env
    }

repository_lifecycle_policy = jsonencode({
    rules = [
        {
            rulePriority = 1,
            description = "Keep last 10 images",
            selection = {
                tagStatus = "any",
                countType = "imageCountMoreThan",
                countNumber = 10
            },
            action = {
                type = "expire"
            }
        }
    ]
})

}