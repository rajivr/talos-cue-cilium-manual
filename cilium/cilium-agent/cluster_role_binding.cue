package cilium

// Source: cilium/templates/cilium-agent/clusterrolebinding.yaml
clusterRoleBinding: cilium: {
	metadata: labels: "app.kubernetes.io/part-of": "cilium"
	kubernetes: {
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "cilium"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "cilium"
			namespace: "kube-system"
		}]
	}
}
