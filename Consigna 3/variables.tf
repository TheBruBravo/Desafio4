variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "rg-containerapp"
}

variable "containerapp_name" {
  default = "my-containerapp"
}

variable "acr_name" {
  default = "acrtfexample" # DEBE ser único a nivel global
}
