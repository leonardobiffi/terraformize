resource "null_resource" "test" {
  count   = 1
}

variable "test_var" {
  description = "an example variable"
  default = "my_variable_default_value"
}

output "test" {
  value = var.test_var
}