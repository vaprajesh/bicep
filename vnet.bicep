// Parameters //////////
@description('This is organization prefix')
param orgprefix string = 'hnis'

@description('The name of the environment. This must be dev or prod')
@allowed([
  'dev'
  'prod'
])
param environmentname string = 'dev'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '10.0.0.0/24'

@description('Subnet 1 Name')
param subnet1Name string = 'Subnet1'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '10.0.1.0/24'

@description('Subnet 2 Name')
param subnet2Name string = 'Subnet2'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '10.0.2.0/24'

@description('Subnet 3 Name')
param subnet3Name string = 'Subnet3'

@description('Location for all resources.')
param location string = resourceGroup().location

param resourceTags object = {
  Environment: environmentname
  CostCenter: '1000100'
  Team: 'Human Resources'
}

// Variables //////////
var vnetname = '${orgprefix}-${environmentname}-${location}-vnet'

// Resources //////////
@description('Virtual Network')
resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
        }
      }
    ]
  }
  tags: resourceTags
}
