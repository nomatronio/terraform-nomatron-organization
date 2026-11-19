variable "nomatron_address" {
  type        = string
  description = "Nomatron API address."
}

variable "nomatron_token" {
  type        = string
  sensitive   = true
  description = "Nomatron API token."
}

provider "nomatron" {
  address = var.nomatron_address
  token   = var.nomatron_token
}
