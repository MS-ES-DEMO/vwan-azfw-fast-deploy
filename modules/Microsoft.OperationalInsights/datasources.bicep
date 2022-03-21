
param tags object
param logWorkspaceName string 



resource diskSpaceCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Pct-Free-Space'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: '% Free Space'
  }
}

resource diskReadSecCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Avg-DiskSecRead'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Avg. Disk sec/Read'
  }
}

resource diskTransferCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Avg-DiskSecTransfer'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Avg. Disk sec/Transfer'
  }
}

resource diskWriteCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Avg-DiskSecWrite'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Avg. Disk sec/Write'
  }
}

resource lDiskBytesSecCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-BytesSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Bytes/sec'
  }
}

resource lDiskBytesReadCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-ReadBytesSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Read Bytes/sec'
  }
}

resource lDiskReadCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-ReadsSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Reads/sec'
  }
}

resource lDiskTransferCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-TransfersSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Transfers/sec'
  }
}

resource lDiskBytesWriteCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-WriteBytesSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Write Bytes/sec'
  }
}

resource lDiskWriteSecCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-Disk-WritesSec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Disk Writes/sec'
  }
}

resource lDiskFreeBytesCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-LogicalDisk-FreeMegabytes'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'LogicalDisk'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Free Megabytes'
  }
}

resource memoryCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-Memory-AvailableMBytes'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Available MBytes'
  }
}

resource memoryPctCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-Memory-AvailableMemPct'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Memory'
    instanceName: '*'
    intervalSeconds: 60
    counterName: '% Committed Bytes in Use'
  }
}

resource nwBytesRxCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-NetworkAdapter-BytesReceived-sec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Network Adapter'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Bytes Received/sec'
  }
}

resource nwBytesTxCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-NetworkAdapter-BytesSent-sec'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Network Adapter'
    instanceName: '*'
    intervalSeconds: 60
    counterName: 'Bytes Sent/sec'
  }
}

resource cpuTimeCtr 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-Processor-Pct-Processor-Time-Total'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: '_Total'
    intervalSeconds: 60
    counterName: '% Processor Time'
  }
}


resource cpuBpProcess 'Microsoft.OperationalInsights/workspaces/datasources@2015-11-01-preview' = {
  tags: tags
  name: '${logWorkspaceName}/VMInsights-BP-Server-Pct-Processor-Time-Total'
  kind: 'WindowsPerformanceCounter'
  properties: {
    objectName: 'Processor'
    instanceName: 'BPServer'
    intervalSeconds: 60
    counterName: '% Processor Time'
  }
}
