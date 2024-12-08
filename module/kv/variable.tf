variable "name" {
  type = string
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}


variable "additional_policy" {
  type = map(object({
    certificate_permissions= list(string)
    key_permissions= list(string)
    secret_permissions= list(string)
    storage_permissions= list(string)
  }))
  default = {
  }
}