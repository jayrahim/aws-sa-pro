variable "ou_names" {
  type        = list(string)
  description = "A list of names of the organizational units"
  default     = ["staging", "production"]
}