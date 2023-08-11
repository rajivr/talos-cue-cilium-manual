package cilium

roleBinding: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
