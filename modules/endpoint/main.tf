#Creating IAM role
resource "aws_iam_role" "bge_sagemaker_endpoint_role" {
    name = var.access_role
    
    assume_role_policy = jsonencode({
        Version   = "2012-10-17",
        Statement = [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "sagemaker.amazonaws.com"
                },
            },
        ],
    })
}

#Creating S3 full access policy for the role
resource "aws_iam_policy" "s3_full_access_policy_sagemaker_bge" {
    name = "s3_full_access_policy_sagemaker_bge"

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": "*"
            }
        ]
    }) 
}

#Attaching S3 full access policy to the role
resource "aws_iam_policy_attachment" "s3_full_access_policy_attachment_sagemaker_bge" {
    name       = "s3_full_access_policy_sagemaker_bge"
    policy_arn = aws_iam_policy.s3_full_access_policy_sagemaker_bge.arn
    roles      = [aws_iam_role.bge_sagemaker_endpoint_role.name] 
}

resource "aws_iam_policy" "aws_repository_access_policy_bge"{
    name = "aws_repository_access_policy_bge"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:GetRepositoryPolicy",
                    "ecr:DescribeRepositories",
                    "ecr:ListImages",
                    "ecr:DescribeImages",
                    "ecr:BatchGetImage",
                    "ecr:GetLifecyclePolicy",
                    "ecr:GetLifecyclePolicyPreview",
                    "ecr:ListTagsForResource",
                    "ecr:DescribeImageScanFindings",
                    
                ],
                "Resource": [
                "arn:aws:ecr:us-west-2:*:repository/*"
            ]
            }
        ]
    })
}

resource "aws_iam_policy_attachment" "image_attachment_sagemaker" {
    name       = "image_access_policy_sagemaker"
    policy_arn = aws_iam_policy.aws_repository_access_policy_bge.arn
    roles      = [aws_iam_role.bge_sagemaker_endpoint_role.name] 
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access_policy_attach" {
  role       = aws_iam_role.bge_sagemaker_endpoint_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_model" "bge_sagemaker_model" {
    name = "bge-sagemaker-model"
    execution_role_arn = aws_iam_role.bge_sagemaker_endpoint_role.arn
    primary_container {
      image = var.image_container
      model_data_url = var.model_data
    }

}

resource "aws_sagemaker_endpoint_configuration" "bge_sagemaker_endpoint_configuration"{
    name = "bge-endpoint-configuration-tf"
    production_variants{
        model_name = aws_sagemaker_model.bge_sagemaker_model.name
        variant_name = "Version1"
        initial_instance_count = 1

        # for CPU instance
        instance_type = "ml.m5.xlarge"

        # for GPU instance
        # instance_type = "ml.g4dn.xlarge"

        # for serverless endpoint
        # serverless_config {
        #     memory_size_in_mb = var.memory_size_in_mb
        #     max_concurrency = var.max_concurrency
        # }
    }
}

resource "aws_sagemaker_endpoint" "sagemaker_endpoint"{
    name = "bge-endpoint"
    endpoint_config_name = aws_sagemaker_endpoint_configuration.bge_sagemaker_endpoint_configuration.name
}
