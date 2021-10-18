
param vnetInfo object
param nsgName string
param snetInfo object


resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: '${vnetInfo.name}'
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = if (!empty(nsgName)) {
  name: nsgName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${snetInfo.name}'
  parent: vnet
  properties: {
    addressPrefix: '${snetInfo.range}'
    networkSecurityGroup: (!empty(nsgName)) ? {
      id: nsg.id 
    }: json('null')
  }
}
