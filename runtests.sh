export bigip_pip=$(terraform show -json | jq '.values.root_module.resources[] | select(.address | contains("azurerm_linux_virtual_machine.virtualmachine"))  | .values.public_ip_address'|awk -F \" '{print $2}')
export BIGIP_PASSWORD=$(terraform show -json | jq '.values.root_module.resources[] | select(.address | contains("random_password.dpasswrd"))  | .values.result'|awk -F \" '{print $2}')
export BIGIP_USER="admin"
export DO_VERSION=1.15.0
export AS3_VERSION=3.22.1
export TS_VERSION=1.14.0
for ip in $bigip_pip; do inspec exec bigip --reporter cli --show-progress --input bigip_address=$ip bigip_port=443 user=$BIGIP_USER password=$BIGIP_PASSWORD do_version=$DO_VERSION as3_version=$AS3_VERSION ts_version=$TS_VERSION; done
