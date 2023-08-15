package cilium

// Defines settings that apply to all abstract objects.
#Base: {
	name: string

	// Set of Kubernetes specific settings that will be merged at the
	// top-level. The allowed fields are type specific.
	kubernetes: {...}
	...
}
