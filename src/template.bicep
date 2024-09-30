param md_metadata object
param provisioner object
param endpoints array
param profile_config object
param azure_service_principal object

resource profile 'Microsoft.Cdn/profiles@2023-07-01-preview' = {
  name: md_metadata.name_prefix
  location: provisioner.location
  sku: {
    name: profile_config.sku
  }
  tags: md_metadata.default_tags
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2023-07-01-preview' = [for endpoint in endpoints: {
  parent: profile
  name: md_metadata.name_prefix
  location: provisioner.location
  tags: md_metadata.default_tags
  properties: {
    originHostHeader: endpoint.hostname
    origins: [
      {
        name: endpoint.origin_name
        properties: {
          hostName: endpoint.hostname
          httpPort: 80
          httpsPort: 443
        }
      }
    ]
    isHttpAllowed: endpoint.http_allowed
    isHttpsAllowed: endpoint.https_allowed
    queryStringCachingBehavior: endpoint.query_caching_behavior
    contentTypesToCompress: [
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
      'application/javascript'
    ]
  }
}]

output profileId string = profile.id
output endpoints array = [for endpoint in endpoints: {
  endpoint: endpoint.hostname
}]
