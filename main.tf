module "sagemaker_notebook_instance"{
    source        = "./modules/sagemaker_notebook_instance"
    name          = "bge-sagemaker-notebook-instance"
    access_role = "bge_sagemaker_instance_role"
    instance_type = "ml.t3.xlarge"
}

module "endpoints"{
 source           = "./modules/endpoint"
 # for gpu instance endpoint
 #  image_container  = "763104351884.dkr.ecr.us-west-2.amazonaws.com/huggingface-pytorch-inference:1.13-transformers4.26-gpu-py39-cu117-ubuntu20.04"

 # for cpu instance or serverless endpoint
 image_container = "763104351884.dkr.ecr.ap-south-1.amazonaws.com/pytorch-inference:1.7.1-cpu-py3"
 model_data        = "s3://bge-small-bucket/custom_inference/bge-large-en-v1.5/model.tar.gz"
 memory_size_in_mb = 3072
 max_concurrency   = 2
 access_role   = "bge_sagemaker_endpoint_role"
}