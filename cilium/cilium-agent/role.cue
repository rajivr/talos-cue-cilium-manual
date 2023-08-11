package cilium

// Source: cilium/templates/cilium-agent/role.yaml
role: "cilium-config-agent": {
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
	}
	kubernetes: rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
