package cilium

serviceAccount: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
