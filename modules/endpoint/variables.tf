
variable "access_role" {
    type = string
    description = "iam role for endpoint"
  
}

variable "image_container" {
    type = string
    description = "container for the model"
  
}

variable "model_data" {
    type = string
    description = "url of the location of model artifacts"
  
}

variable "memory_size_in_mb" {
    type = number
    description = "memory size of the endpoint"
  
}

variable "max_concurrency" {
    type = number
    description = "no of concurrent instance to launced"
  
}
