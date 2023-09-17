#Creating IAM role
resource "aws_iam_role" "bge_sagemaker_instance_role" {
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
resource "aws_iam_role_policy_attachment" "sagemaker_full_access_policy_attach_bge" {
  role       = aws_iam_role.bge_sagemaker_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
#-------------------------------------------------------------------------------------------------------------------------------------------------

#Creating S3 full access policy for the role
resource "aws_iam_policy" "s3_full_access_policy_sagemaker_instance" {
    name = "s3_full_access_policy_bge_sagemaker_instance"

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:*",
                    "s3-object-lambda:*"
                ],
                "Resource": "*"
            }
        ]
    }) 
}

#Attaching S3 full access policy to the role
resource "aws_iam_policy_attachment" "s3_full_access_policy_attachment_sagemaker_instance" {
    name       = "s3_full_access_policy_attachment_bge_sagemaker_instance"
    policy_arn = aws_iam_policy.s3_full_access_policy_sagemaker_instance.arn
    roles      = [aws_iam_role.bge_sagemaker_instance_role.name] 
}


resource "aws_sagemaker_notebook_instance" "ni" {
  name          = var.name
  role_arn      = aws_iam_role.bge_sagemaker_instance_role.arn
  instance_type = var.instance_type

}