package cilium

// Source: cilium/templates/cilium-agent/clusterrole.yaml
clusterRole: cilium: {
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
	}
	kubernetes: rules: [{
		apiGroups: [
			"networking.k8s.io",
		]
		resources: [
			"networkpolicies",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"discovery.k8s.io",
		]
		resources: [
			"endpointslices",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"namespaces",
			"services",
			"pods",
			"endpoints",
			"nodes",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"apiextensions.k8s.io",
		]
		resources: [
			"customresourcedefinitions",
		]
		verbs: [
			"list",
			"watch",
			"get",
		]
	}, {

		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumloadbalancerippools",
			"ciliumbgppeeringpolicies",
			"ciliumclusterwideenvoyconfigs",
			"ciliumclusterwidenetworkpolicies",
			"ciliumegressgatewaypolicies",
			"ciliumendpoints",
			"ciliumendpointslices",
			"ciliumenvoyconfigs",
			"ciliumidentities",
			"ciliumlocalredirectpolicies",
			"ciliumnetworkpolicies",
			"ciliumnodes",
			"ciliumnodeconfigs",
		]
		verbs: [
			"list",
			"watch",
		]
		// This is used when validating policies in preflight. This will need to stay
		// until we figure out how to avoid "get" inside the preflight, and then
		// should be removed ideally.
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumidentities",
			"ciliumendpoints",
			"ciliumnodes",
		]
		verbs: [
			"create",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		// To synchronize garbage collection of such resources
		resources: [
			"ciliumidentities",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumendpoints",
		]
		verbs: [
			"delete",
			"get",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnodes",
			"ciliumnodes/status",
		]
		verbs: [
			"get",
			"update",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnetworkpolicies/status",
			"ciliumclusterwidenetworkpolicies/status",
			"ciliumendpoints/status",
			"ciliumendpoints",
		]
		verbs: [
			"patch",
		]
	}]
}
