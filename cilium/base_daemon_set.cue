package cilium

daemonSet: [Name=_]: #Base & {
	name: string | *Name

	metadata: namespace: "kube-system"
}
