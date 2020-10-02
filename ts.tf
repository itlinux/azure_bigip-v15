data "template_file" "ts_json" {
  depends_on = [data.template_file.vm_onboard]
  count      = var.specs[terraform.workspace]["instance_count"]
  template   = file("${path.module}/ts.json")

  vars = {
    region      = var.specs[terraform.workspace]["location"]
    law_id      = var.workspace_id
    law_primkey = var.shared_key
  }
}
resource "null_resource" "ts_telemetry" {
  count = var.specs[terraform.workspace]["instance_count"]
  provisioner "local-exec" {
    command = <<-EOT
        sleep 120
    curl -s -k -X POST https://${azurerm_linux_virtual_machine.virtualmachine[count.index].public_ip_address}:443/mgmt/shared/telemetry/declare \
              -H 'Content-Type: application/json' \
              --max-time 600 \
              --retry 10 \
              --retry-delay 30 \
              --retry-max-time 600 \
              --retry-connrefused \
              -u "admin:${random_password.dpasswrd.result}" \
              -d '${data.template_file.ts_json[count.index].rendered}'
        EOT
  }

  depends_on = [
    azurerm_linux_virtual_machine.virtualmachine
  ]
  # if there is any change to the content of the ts declaration
  # resubmit the declaration. this allows for circumstances when
  # invariant structures are added to the declaration
  triggers = {
    ts_content = data.template_file.ts_json[count.index].rendered
  }
}
