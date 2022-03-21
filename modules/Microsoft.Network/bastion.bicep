param name string
param location string
param tags object
param vnetResourceGroupName string
param vnetName string

param subnetName string = 'AzureBastionSubnet'
param skuName string = 'Standard'
@minValue(2)
@maxValue(50)
param scaleUnits int = 2
param disableCopyPaste bool = true
param dnsName string = name
param enableFileCopy bool = true
param enableIpConnect bool = true
param enableShareableLink bool = true
param enableTunneling bool = true

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: subnetName
  parent: vnet
}

resource ip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: '${name}publicIp'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    deleteOption: 'Delete'
    dnsSettings: {
      fqdn: name
      domainNameLabel: name
    }
  }
}


resource bastion 'Microsoft.Network/bastionHosts@2021-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    scaleUnits: scaleUnits
    disableCopyPaste: disableCopyPaste
    dnsName: dnsName
    enableFileCopy: enableFileCopy
    enableIpConnect: enableIpConnect
    enableShareableLink: enableShareableLink
    enableTunneling: enableTunneling
    ipConfigurations: [
      {
        name: '${name}ipConfiguration'
        properties: {
          publicIPAddress: {
            id: ip.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}
