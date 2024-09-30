{
	"data": {
		"infrastructure": {
			"ari": .outputs.profileId.value,
			"endpoints": [
				.outputs.endpoint.value
			]
		},
		"security": {}
	},
	"specs": {
		 "azure": {
			"region": .params.provisioner.location
		}
	}
}
