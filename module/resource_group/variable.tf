variable "name" {
  type = string
}
variable "location" {
  type = string
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

