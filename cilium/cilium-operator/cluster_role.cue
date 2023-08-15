package cilium

// Source: cilium/templates/cilium-operator/clusterrole.yaml
clusterRole: "cilium-operator": {
	metadata: labels: "app.kubernetes.io/part-of": "cilium"
	kubernetes: rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"pods",
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
			"nodes",
		]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources:
		// To remove node taints
		[
			"nodes",
			"nodes/status",
		]
		// To set NetworkUnavailable false on startup
		verbs: [
			"patch",
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
		resources:
		// to perform LB IP allocation for BGP
		[
			"services/status",
		]
		verbs: [
			"update",
			"patch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources:
		// to check apiserver connectivity
		[
			"namespaces",
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
		resources:
		// to perform the translation of a CNP that contains `ToGroup` to its endpoints
		[
			"services",
			"endpoints",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnetworkpolicies",
			"ciliumclusterwidenetworkpolicies",
		]
		verbs:
		// Create auto-generated CNPs and CCNPs from Policies that have 'toGroups'
		[
			"create",
			"update",
			"deletecollection",
			"patch",
			"get",
			"list",
			"watch",
		]
	}, {

		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnetworkpolicies/status",
			"ciliumclusterwidenetworkpolicies/status",
		]
		verbs:
		// Update the auto-generated CNPs and CCNPs status.
		[
			"patch",
			"update",
		]
		// To update the status of the CNPs and CCNPs
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumendpoints",
			"ciliumidentities",
		]
		verbs:
		// To perform garbage collection of such resources
		[
			"delete",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumidentities",
		]
		verbs:
		// To synchronize garbage collection of such resources
		[
			"update",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnodes",
		]
		verbs: [
			"create",
			"update",
			"get",
			"list",
			"watch",
			"delete",
		]
	}, {

		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumnodes/status",
		]
		verbs: [
			"update",
		]
		// To perform CiliumNode garbage collector
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumendpointslices",
			"ciliumenvoyconfigs",
		]
		verbs: [
			"create",
			"update",
			"get",
			"list",
			"watch",
			"delete",
			"patch",
		]
	}, {
		apiGroups: [
			"apiextensions.k8s.io",
		]
		resources: [
			"customresourcedefinitions",
		]
		verbs: [
			"create",
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
			"update",
		]
		resourceNames: [
			"ciliumloadbalancerippools.cilium.io",
			"ciliumbgppeeringpolicies.cilium.io",
			"ciliumclusterwideenvoyconfigs.cilium.io",
			"ciliumclusterwidenetworkpolicies.cilium.io",
			"ciliumegressgatewaypolicies.cilium.io",
			"ciliumendpoints.cilium.io",
			"ciliumendpointslices.cilium.io",
			"ciliumenvoyconfigs.cilium.io",
			"ciliumexternalworkloads.cilium.io",
			"ciliumidentities.cilium.io",
			"ciliumlocalredirectpolicies.cilium.io",
			"ciliumnetworkpolicies.cilium.io",
			"ciliumnodes.cilium.io",
			"ciliumnodeconfigs.cilium.io",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumloadbalancerippools",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"cilium.io",
		]
		resources: [
			"ciliumloadbalancerippools/status",
		]
		verbs: [
			"patch",
		]
	}, {
		// For cilium-operator running in HA mode.
		//
		// Cilium operator running in HA mode requires the use of ResourceLock for Leader Election
		// between multiple running instances.
		// The preferred way of doing this is to use LeasesResourceLock as edits to Leases are less
		// common and fewer objects in the cluster watch "all Leases".
		apiGroups: [
			"coordination.k8s.io",
		]
		resources: [
			"leases",
		]
		verbs: [
			"create",
			"get",
			"update",
		]
	}]
}
