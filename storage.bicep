param location string = 'WestUS3'
resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'khushivir1234'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: location
}
