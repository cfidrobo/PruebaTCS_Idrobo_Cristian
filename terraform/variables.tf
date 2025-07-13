variable "project"    { type = string }
variable "region"     { type = string }
variable "credentials" { type = string }
variable "image" {
  description = "Container image to deploy"
  type        = string
}
