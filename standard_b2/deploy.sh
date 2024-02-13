#! /bin/bash

echo "deploying vm"

az vm create \
  --name agvm \
  --admin-username azureuser \
  --authentication-type ssh \
  --assign-identity [system] /subscriptions/84714425-7bde-41fc-adbf-dadbc3daab9b/resourcegroups/AGs_resource/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azureuser \
  --resource-group AGs_resource \
  --image Ubuntu2204 \
  --location eastus \
  --size Standard_B2s \
  --custom-data cloud-init.txt \
  --ssh-key-name home_laptop \
  --os-disk-size-gb 30

az vm extension set \
  --publisher Microsoft.Azure.ActiveDirectory \
  --name AADSSHLoginForLinux \
  --resource-group AGs_resource \
  --vm-name agvm

az vm user update --name agvm --resource-group AGs_resource --username azureuser --ssh-key-value "$(< ../publickeys.txt)"
echo "deployment complete"

