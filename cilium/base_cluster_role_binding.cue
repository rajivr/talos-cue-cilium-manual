package cilium

// `clusterRoleBinding` does not have `metadata: namespace:` field.
clusterRoleBinding: [Name=_]: #Base & {
	name: string | *Name
}
