package cilium

configMap: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
