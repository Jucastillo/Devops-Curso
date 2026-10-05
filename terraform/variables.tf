variable "aws_region" {
  description = "Región de despliegue en AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto (prefijo de recursos)"
  type        = string
  default     = "api-devops"
}

variable "vpc_cidr" {
  description = "Rango CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs de subredes públicas (2 por AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs de subredes privadas (para los nodos EKS)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "eks_cluster_version" {
  description = "Versión de Kubernetes"
  type        = string
  default     = "1.29"
}

variable "eks_node_count" {
  description = "Cantidad de nodos worker"
  type        = number
  default     = 2
}

variable "eks_node_type" {
  description = "Tipo de instancia EC2 para los nodos"
  type        = string
  default     = "t3.small"
}