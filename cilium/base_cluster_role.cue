package cilium

// `clusterRole` does not have `metadata: namespace:` field.
clusterRole: [Name=_]: #Base & {
	name: string | *Name
}
