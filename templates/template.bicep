param location string
param extendedLocation object
param virtualNetworkName string
param resourceGroup string
param addressSpaces array
param ipv6Enabled bool
param subnetCount int
param subnet0_name string
param subnet0_addressRange string
param subnet0_serviceEndpoints array
param subnet1_name string
param subnet1_addressRange string
param subnet1_serviceEndpoints array
param ddosProtectionPlanEnabled bool
param firewallEnabled bool
param bastionEnabled bool
param firewallName string
param firewallSubnetAddressSpace string
param publicIpAddress string

resource virtualNetworkName_resource 'Microsoft.Network/VirtualNetworks@2021-01-01' = {
  name: virtualNetworkName
  location: location
  extendedLocation: (empty(extendedLocation) ? json('null') : extendedLocation)
  tags: {
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    subnets: [
      {
        name: '172.16.1.0'
        properties: {
          addressPrefix: '172.16.1.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
      {
        name: '172.16.2.0'
        properties: {
          addressPrefix: '172.16.2.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Web'
            }
          ]
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallSubnetAddressSpace
        }
      }
    ]
    enableDdosProtection: ddosProtectionPlanEnabled
  }
  dependsOn: []
}

resource publicIpAddress_resource 'Microsoft.Network/publicIpAddresses@2019-02-01' = {
  name: publicIpAddress
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewallName_resource 'Microsoft.Network/azureFirewalls@2019-04-01' = {
  name: firewallName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resourceId(resourceGroup, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'AzureFirewallSubnet')
          }
          publicIPAddress: {
            id: resourceId(resourceGroup, 'Microsoft.Network/publicIpAddresses', publicIpAddress)
          }
        }
      }
    ]
  }
  dependsOn: [
    resourceId(resourceGroup, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
  ]
}