package cilium

role: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
