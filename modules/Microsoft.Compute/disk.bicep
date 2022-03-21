
param location string = resourceGroup().location
param tags object
param name string 
param diskSize int


resource disk 'Microsoft.Compute/disks@2021-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: diskSize
  }
}

