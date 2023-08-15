package cilium

// Source: cilium/templates/cilium-operator/deployment.yaml
deployment: "cilium-operator": {
	metadata: labels: {
		"io.cilium/app":             "operator"
		name:                        "cilium-operator"
		"app.kubernetes.io/part-of": "cilium"
		"app.kubernetes.io/name":    "cilium-operator"
	}
	kubernetes: spec: {
		// See docs on ServerCapabilities.LeasesResourceLock in file pkg/k8s/version/version.go
		// for more details.
		replicas: 1
		selector: matchLabels: {
			"io.cilium/app": "operator"
			name:            "cilium-operator"
		}
		strategy: {
			rollingUpdate: {
				maxSurge:       1
				maxUnavailable: 1
			}
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				annotations: {
					"prometheus.io/port":   "9963"
					"prometheus.io/scrape": "true"
				}
				labels: {
					"io.cilium/app":             "operator"
					name:                        "cilium-operator"
					"app.kubernetes.io/part-of": "cilium"
					"app.kubernetes.io/name":    "cilium-operator"
				}
			}
			spec: {
				containers: [{
					name:            "cilium-operator"
					image:           "quay.io/cilium/operator-generic:v1.13.4@sha256:09ab77d324ef4d31f7d341f97ec5a2a4860910076046d57a2d61494d426c6301"
					imagePullPolicy: "IfNotPresent"
					command: [
						"cilium-operator-generic",
					]
					args: [
						"--config-dir=/tmp/cilium/config-map",
						"--debug=$(CILIUM_DEBUG)",
					]
					env: [{
						name: "K8S_NODE_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "spec.nodeName"
						}
					}, {
						name: "CILIUM_K8S_NAMESPACE"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}, {
						name: "CILIUM_DEBUG"
						valueFrom: configMapKeyRef: {
							key:      "debug"
							name:     "cilium-config"
							optional: true
						}
					}, {
						name:  "KUBERNETES_SERVICE_HOST"
						value: "192.168.121.100"
					}, {
						name:  "KUBERNETES_SERVICE_PORT"
						value: "6443"
					}]
					ports: [{
						name:          "prometheus"
						containerPort: 9963
						hostPort:      9963
						protocol:      "TCP"
					}]
					livenessProbe: {
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9234
							scheme: "HTTP"
						}
						initialDelaySeconds: 60
						periodSeconds:       10
						timeoutSeconds:      3
					}
					volumeMounts: [{
						name:      "cilium-config-path"
						mountPath: "/tmp/cilium/config-map"
						readOnly:  true
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
				}]
				hostNetwork:                  true
				restartPolicy:                "Always"
				priorityClassName:            "system-cluster-critical"
				serviceAccount:               "cilium-operator"
				serviceAccountName:           "cilium-operator"
				automountServiceAccountToken: true
				// In HA mode, cilium-operator pods must not be scheduled on the same
				// node as they will clash with each other.
				affinity: {
					podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
						labelSelector: matchLabels: "io.cilium/app": "operator"
						topologyKey: "kubernetes.io/hostname"
					}]
				}
				nodeSelector: "kubernetes.io/os": "linux"
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					// To read the configuration from the config map
					name: "cilium-config-path"
					configMap: name: "cilium-config"
				}]
			}
		}
	}
}
