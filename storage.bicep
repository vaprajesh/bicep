param orgprefix string = 'hnis'
@allowed([
  'dev'
  'prod'
])
param environmentname string = 'dev'
param location string = resourceGroup().location

param resourceTags object = {
  Environment: environmentname
  CostCenter: '1000100'
  Team: 'Human Resources'
}

var storageaccountname = '${orgprefix}${environmentname}${location}sa'


resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageaccountname
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: location
  tags: resourceTags
}
