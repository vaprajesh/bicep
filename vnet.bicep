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
param vnetaddressprefix string = '10.0.0.0/16'

@description('Subnet 1 Prefix')
param subnet1prefix string = '10.0.0.0/24'

@description('Subnet 1 Name')
param subnet1name string = 'subnet1'

@description('Subnet 2 Prefix')
param subnet2prefix string = '10.0.1.0/24'

@description('Subnet 2 Name')
param subnet2name string = 'subnet2'

@description('Subnet 3 Prefix')
param subnet3prefix string = '10.0.2.0/24'

@description('Subnet 3 Name')
param subnet3name string = 'subnet3'

@description('Gateway Subnet Prefix')
param vgwsubnetprefix string = '10.0.254.0/24'

@description('Gateway Subnet Name')
param vgwsubnetname string = 'GatewaySubnet'

@description('Location for all resources.')
param location string = resourceGroup().location

param resourceTags object = {
  Environment: environmentname
  CostCenter: '1000100'
  Team: 'Human Resources'
}

@description('The Vnet Name')
//param vnetname string = 'gw-${uniqueString(resourceGroup().id)}'
param newvnetname string = '${orgprefix}-${environmentname}-${location}-vnet'

@description('The Publice IP Name')
//param publiceip string = 'gw-${uniqueString(resourceGroup().id)}'
param newpublicipaddressname string = '${orgprefix}-${environmentname}-${location}-pip'

@description('The Publice IP Name')
//param publiceip string = 'gw-${uniqueString(resourceGroup().id)}'
param newvirtualnetworkgatewayname string = '${orgprefix}-${environmentname}-${location}-vgw'

param gatewayType string = 'Vpn'

param vpngatewaygeneration string = 'Generation1'

param vpntype string = 'RouteBased'

param vpnsku string = 'VpnGw1'

param vpntier string = 'VpnGw1'

// Resources //////////
resource newVnetName_resource 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: newvnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressprefix
      ]
    }
    subnets: [
      {
        name: subnet1name
        properties: {
          addressPrefix: subnet1prefix
        }
      }
      {
        name: subnet2name
        properties: {
          addressPrefix: subnet2prefix
        }
      }
      {
        name: subnet3name
        properties: {
          addressPrefix: subnet3prefix
        }
      }
      {
        name: vgwsubnetname
        properties: {
          addressPrefix: vgwsubnetprefix
        }
      }
    ]
  }
  tags: resourceTags
}

resource newVirtualNetworkGatewayName_resource 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: newvirtualnetworkgatewayname
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
            id: resourceId('TEMP', 'Microsoft.Network/virtualNetworks/subnets', newvnetname, vgwsubnetname)
          }
          publicIPAddress: {
            id: resourceId('TEMP', 'Microsoft.Network/publicIPAddresses', newpublicipaddressname)
          }
        }
      }
    ]
    vpnType: vpntype
    vpnGatewayGeneration: vpngatewaygeneration
    sku: {
      name: vpnsku
      tier: vpntier
    }
  }
  dependsOn: [
    newPublicIpAddressName_resource
    newVnetName_resource
  ]
}

resource newPublicIpAddressName_resource 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: newpublicipaddressname
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
