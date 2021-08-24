// ** Descriptive variables used for names / identification etc **
variable "region" {
  type        = string
  description = "The FIL application id for the product this will be used to tag resources for billing purposes"
}

variable "app_id" {
  type        = string
  description = "The FIL application id for the product this will be used to tag resources for billing purposes"
}
variable "chargeback_id" {
  type        = string
  description = "The FIL application id for the product this will be used to tag resources for billing purposes.  Use to override app_id for grouped applications."
  default     = null
}

variable "product_name" {
  type        = string
  description = "The short name for your product"
}

variable "workspace" {
  type        = string
  description = "This is used as a prefix for all managed resources. Will default to the Terraform workspace if not supplied."
  default     = null
}