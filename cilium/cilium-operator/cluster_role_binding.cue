package cilium

// Source: cilium/templates/cilium-operator/clusterrolebinding.yaml
clusterRoleBinding: "cilium-operator": {
	metadata: {
		labels: "app.kubernetes.io/part-of": "cilium"
	}
	kubernetes: {
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "cilium-operator"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "cilium-operator"
			namespace: "kube-system"
		}]
	}
}
