

# SageMaker Endpoint with Hugging Face Model Deployment

This Terraform project deploys an Amazon SageMaker endpoint using a Hugging Face model for natural language processing tasks. It includes a SageMaker notebook instance and a SageMaker endpoint.


### Instructions for the CPU, GPU or serverless configuration of endpoints are mentioned in the files

## Project Structure

The project directory structure is organized as follows:

```
project-root/
  ├── main.tf                      # Main Terraform configuration file
  ├── sagemakerinstance/  
  │   ├── inference.py             # Python script for inference
  │   ├── requirements.txt         # Python dependencies
  │   └── inference2.py            # Another Python script for inference
  │   └── model_artifacts.ipynb    # Jupyter notebook for model artifacts
  ├── modules/
  │   ├── sagemaker_notebook_instance/
  │   │   ├── main.tf              # SageMaker notebook instance module
  │   │   └── ...                  # Other module files
  │   ├── endpoint/
  │   │   ├── main.tf              # SageMaker endpoint module
  │   │   └── ...                  # Other module files
  │   └── ...                      # Other modules (if any)
  ├── variables.tf                 # Variable declarations
  ├── outputs.tf                   # Output declarations
  └── README.md                    # Project documentation
```

## Prerequisites

Before deploying the SageMaker endpoint, ensure you have the following prerequisites:

1. AWS CLI configured with appropriate permissions.
2. Terraform installed on your machine.

## Creating the Hugging Face Model `model.tar.gz` Artifact

To create the `model.tar.gz` artifact for your Hugging Face model, follow these steps:

1. Access your SageMaker notebook instance through the AWS SageMaker console.

2. In the SageMaker notebook instance, open the Jupyter notebook `model_artifacts.ipynb` located in the `sagemakerinstance/` directory.

3. Follow the instructions in the notebook to load your Hugging Face model, perform any necessary preprocessing, and save it as `model.tar.gz` in the desired S3 location. This artifact will be used for deployment in the SageMaker endpoint.

## Configuration

1. Clone this project repository.

2. Modify the `main.tf` file to customize the SageMaker notebook instance and endpoint configurations by changing the following variables in `main.tf`:

   - `name`: Set a name for your SageMaker notebook instance.
   - `access_role`: Specify the IAM role for SageMaker notebook instance.
   - `instance_type`: Choose the instance type for your notebook instance.
   - `image_container`: Specify the Docker container image for the SageMaker endpoint. Uncomment the GPU or CPU version based on your requirements.
   - `model_data`: Set the S3 path to the `model.tar.gz` artifact created in the previous step.
   - `memory_size_in_mb`: Set the desired memory size in megabytes for the endpoint.
   - `max_concurrency`: Set the maximum number of concurrent requests the endpoint can handle.
   - `access_role`: Specify the IAM role for the SageMaker endpoint.

3. In the `sagemakerinstance/` directory, include any additional files or scripts necessary for your SageMaker notebook instance, such as notebooks or data files.

4. Run the following commands to deploy the SageMaker endpoint:

   ```bash
   terraform init
   terraform apply
   ```

5. After the deployment is successful, Terraform will provide you with the endpoint URL and other relevant information.

## Accessing the SageMaker Notebook

You can access your SageMaker notebook instance by logging in to the AWS SageMaker console.

## Usage

You can use the SageMaker endpoint for inference by making POST requests to the provided endpoint URL with input data.

For example, you can use Python and the `boto3` library to make requests to the SageMaker endpoint:

```python
import boto3

client = boto3.client('sagemaker-runtime')

endpoint_name = "your-endpoint-name"
input_data = "Your input data as a string"

response = client.invoke_endpoint(
    EndpointName=endpoint_name,
    Body=input_data.encode('utf-8'),
    ContentType='application/json',
)

output_data = response['Body'].read().decode('utf-8')
print(output_data)
```

## Cleaning Up

After you have finished using the SageMaker endpoint, run the following command to destroy the AWS resources created by Terraform:

```bash
terraform destroy
```

## Disclaimer

This project is intended for demonstration purposes and should be used with caution in a production environment. Ensure that you follow AWS best practices for security and cost management.

For more information on configuring and customizing this Terraform project, refer to the Terraform documentation and AWS SageMaker documentation.