package cilium

// Source: cilium/templates/cilium-agent/rolebinding.yaml
roleBinding: "cilium-config-agent": {
	metadata: labels: "app.kubernetes.io/part-of": "cilium"
	kubernetes: {
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "Role"
			name:     "cilium-config-agent"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "cilium"
			namespace: "kube-system"
		}]
	}
}
