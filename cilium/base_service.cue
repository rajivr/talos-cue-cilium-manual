package cilium

service: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
