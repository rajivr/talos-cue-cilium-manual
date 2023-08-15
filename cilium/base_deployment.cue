package cilium

deployment: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
