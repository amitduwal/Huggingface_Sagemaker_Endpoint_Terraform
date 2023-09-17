variable "name" {
    description = "notebook name"
    type        = string
  
}



variable "instance_type" {
    description = "instance type"
    type        = string
    default     = "ml.t3.medium"
  
}

variable "access_role"{
    description = "access role"
    type        = string
}
