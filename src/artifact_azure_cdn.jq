{
	"data": {
		"infrastructure": {
			"ari": .outputs.profileId.value,
			"endpoints": .outputs.endpoints.value
		},
		"security": {}
	},
	"specs": {
		 "azure": {
			"region": .params.provisioner.location
		}
	}
}
