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


resource endpoint 'Microsoft.Cdn/profiles/endpoints@2023-07-01-preview' = [
  for endpoint in endpoints: {
    parent: profile
    name: '${md_metadata.name_prefix}-${replace(endpoint.hostname, '.', '-')}'
    location: provisioner.location
    tags: md_metadata.default_tags
    properties: {
      originHostHeader: endpoint.hostname
      origins: [
        {
          name: replace(endpoint.hostname, '.', '-')
          properties: {
            hostName: endpoint.hostname
            httpPort: endpoint.http_port
            httpsPort: endpoint.https_port
          }
        }
      ]
      isHttpAllowed: endpoint.http_allowed
      isHttpsAllowed: endpoint.https_allowed
      queryStringCachingBehavior: endpoint.query_caching_behavior
      // must be a valid MIME type: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
      contentTypesToCompress: endpoint.content_types
    }
  }
]



output profileId string = profile.id
output endpoints array = [
  for endpoint in endpoints: {
    name: '${md_metadata.name_prefix}-${endpoint.hostname}'
    hostname: endpoint.hostname
  }
]
