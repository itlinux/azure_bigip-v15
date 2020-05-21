resource random_integer "password-length" {
  min = 12
  max = 25
}

resource "random_password" "dpasswrd" {
  length           = random_integer.password-length.result
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%@"
  #the override special are for the F5 to add specific sets of carathers 
}
