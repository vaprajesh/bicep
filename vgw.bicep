param name string
param location string

@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string = 'Vpn'
param sku string
param vpnGatewayGeneration string

@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string = 'RouteBased'
param existingVirtualNetworkName string
param newSubnetName string
param subnetAddressPrefix string
param newPublicIpAddressName string

resource name_resource 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: name
  location: location
  tags: {
  }
  properties: {
    gatewayType: gatewayType
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('TEMP', 'Microsoft.Network/virtualNetworks/subnets', existingVirtualNetworkName, newSubnetName)
          }
          publicIPAddress: {
            id: resourceId('TEMP', 'Microsoft.Network/publicIPAddresses', newPublicIpAddressName)
          }
        }
      }
    ]
    vpnType: vpnType
    vpnGatewayGeneration: vpnGatewayGeneration
    sku: {
      name: sku
      tier: sku
    }
  }
  dependsOn: [
    newPublicIpAddressName_resource
  ]
}

resource existingVirtualNetworkName_newSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-04-01' = {
  name: '${existingVirtualNetworkName}/${newSubnetName}'
  location: location
  properties: {
    addressPrefix: subnetAddressPrefix
  }
}

resource newPublicIpAddressName_resource 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: newPublicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: []
}
