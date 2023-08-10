package cilium

// Source: cilium/templates/cilium-agent/service.yaml
service: "cilium-agent": {
	metadata: {
		annotations: {
			"prometheus.io/scrape": "true"
			"prometheus.io/port":   "9964"
		}
		labels: {
			"k8s-app":                   "cilium"
			"app.kubernetes.io/name":    "cilium-agent"
			"app.kubernetes.io/part-of": "cilium"
		}
	}
	kubernetes: spec: {
		clusterIP: "None"
		type:      "ClusterIP"
		selector: "k8s-app": "cilium"
		ports: [{
			name:       "envoy-metrics"
			port:       9964
			protocol:   "TCP"
			targetPort: "envoy-metrics"
		}]
	}
}
