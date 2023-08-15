package cilium

// Source: cilium/templates/cilium-agent/daemonset.yaml
daemonSet: cilium: {
	metadata: labels: {
		"k8s-app":                   "cilium"
		"app.kubernetes.io/part-of": "cilium"
		"app.kubernetes.io/name":    "cilium-agent"
	}
	kubernetes: spec: {
		selector: matchLabels: "k8s-app": "cilium"
		updateStrategy: {
			rollingUpdate: maxUnavailable: 2
			type: "RollingUpdate"
		}
		template: {
			metadata: {
				annotations: {
					"prometheus.io/port":   "9962"
					"prometheus.io/scrape": "true"
					// Set app AppArmor's profile to "unconfined". The value of this annotation
					// can be modified as long users know which profiles they have available
					// in AppArmor.
					"container.apparmor.security.beta.kubernetes.io/cilium-agent":       "unconfined"
					"container.apparmor.security.beta.kubernetes.io/clean-cilium-state": "unconfined"
				}
				labels: {
					"k8s-app":                   "cilium"
					"app.kubernetes.io/name":    "cilium-agent"
					"app.kubernetes.io/part-of": "cilium"
				}
			}
			spec: {
				containers: [{
					name:            "cilium-agent"
					image:           "quay.io/cilium/cilium:v1.13.4@sha256:bde8800d61aaad8b8451b10e247ac7bdeb7af187bb698f83d40ad75a38c1ee6b"
					imagePullPolicy: "IfNotPresent"
					command: [
						"cilium-agent",
					]
					args: [
						"--config-dir=/tmp/cilium/config-map",
					]
					startupProbe: {
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
						}
						failureThreshold: 105
						periodSeconds:    2
						successThreshold: 1
					}
					livenessProbe: {
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
						}
						periodSeconds:    30
						successThreshold: 1
						failureThreshold: 10
						timeoutSeconds:   5
					}
					readinessProbe: {
						httpGet: {
							host:   "127.0.0.1"
							path:   "/healthz"
							port:   9879
							scheme: "HTTP"
							httpHeaders: [{
								name:  "brief"
								value: "true"
							}]
						}
						periodSeconds:    30
						successThreshold: 1
						failureThreshold: 3
						timeoutSeconds:   5
					}
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
						name:  "CILIUM_CLUSTERMESH_CONFIG"
						value: "/var/lib/cilium/clustermesh/"
					}, {
						name: "CILIUM_CNI_CHAINING_MODE"
						valueFrom: configMapKeyRef: {
							name:     "cilium-config"
							key:      "cni-chaining-mode"
							optional: true
						}
					}, {
						name: "CILIUM_CUSTOM_CNI_CONF"
						valueFrom: configMapKeyRef: {
							name:     "cilium-config"
							key:      "custom-cni-conf"
							optional: true
						}
					}, {
						name:  "KUBERNETES_SERVICE_HOST"
						value: "192.168.121.100"
					}, {
						name:  "KUBERNETES_SERVICE_PORT"
						value: "6443"
					}]
					lifecycle: {
						postStart: exec: command: [
							"bash",
							"-c",
							"""
		/cni-install.sh --enable-debug=false --cni-exclusive=true --log-file=/var/run/cilium/cilium-cni.log

		""",
						]

						preStop: exec: command: [
							"/cni-uninstall.sh",
						]
					}
					ports: [{
						name:          "peer-service"
						containerPort: 4244
						hostPort:      4244
						protocol:      "TCP"
					}, {
						name:          "prometheus"
						containerPort: 9962
						hostPort:      9962
						protocol:      "TCP"
					}, {
						name:          "envoy-metrics"
						containerPort: 9964
						hostPort:      9964
						protocol:      "TCP"
					}]
					securityContext: {
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
						capabilities: {
							add: [
								"CHOWN",
								"KILL",
								"NET_ADMIN",
								"NET_RAW",
								"IPC_LOCK",
								"SYS_ADMIN",
								"SYS_RESOURCE",
								"DAC_OVERRIDE",
								"FOWNER",
								"SETGID",
								"SETUID",
							]
							drop: [
								"ALL",
							]
						}
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						// Unprivileged containers need to mount /proc/sys/net from the host
						// to have write access
						mountPath: "/host/proc/sys/net"
						name:      "host-proc-sys-net"
					}, {
						// Unprivileged containers need to mount /proc/sys/kernel from the host
						// to have write access
						mountPath: "/host/proc/sys/kernel"
						name:      "host-proc-sys-kernel"
					}, {
						name:      "bpf-maps"
						mountPath: "/sys/fs/bpf"
						// Unprivileged containers can't set mount propagation to bidirectional
						// in this case we will mount the bpf fs from an init container that
						// is privileged and set the mount propagation from host to container
						// in Cilium.
						mountPropagation: "HostToContainer"
					}, {
						// Check for duplicate mounts before mounting
						name:      "cilium-cgroup"
						mountPath: "/sys/fs/cgroup"
					}, {
						name:      "cilium-run"
						mountPath: "/var/run/cilium"
					}, {
						name:      "etc-cni-netd"
						mountPath: "/host/etc/cni/net.d"
					}, {
						name:      "clustermesh-secrets"
						mountPath: "/var/lib/cilium/clustermesh"
						readOnly:  true
					}, {
						// Needed to be able to load kernel modules
						name:      "lib-modules"
						mountPath: "/lib/modules"
						readOnly:  true
					}, {
						name:      "xtables-lock"
						mountPath: "/run/xtables.lock"
					}, {
						name:      "tmp"
						mountPath: "/tmp"
					}]
				}]
				initContainers: [{
					name:            "config"
					image:           "quay.io/cilium/cilium:v1.13.4@sha256:bde8800d61aaad8b8451b10e247ac7bdeb7af187bb698f83d40ad75a38c1ee6b"
					imagePullPolicy: "IfNotPresent"
					command: [
						"cilium",
						"build-config",
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
						name:  "KUBERNETES_SERVICE_HOST"
						value: "192.168.121.100"
					}, {
						name:  "KUBERNETES_SERVICE_PORT"
						value: "6443"
					}]
					volumeMounts: [{
						name:      "tmp"
						mountPath: "/tmp"
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
				}, {
					// Mount the bpf fs if it is not mounted. We will perform this task
					// from a privileged container because the mount propagation bidirectional
					// only works from privileged containers.
					name:            "mount-bpf-fs"
					image:           "quay.io/cilium/cilium:v1.13.4@sha256:bde8800d61aaad8b8451b10e247ac7bdeb7af187bb698f83d40ad75a38c1ee6b"
					imagePullPolicy: "IfNotPresent"
					args: [
						"mount | grep \"/sys/fs/bpf type bpf\" || mount -t bpf bpf /sys/fs/bpf",
					]
					command: [
						"/bin/bash",
						"-c",
						"--",
					]
					terminationMessagePolicy: "FallbackToLogsOnError"
					securityContext: privileged: true
					volumeMounts: [{
						name:             "bpf-maps"
						mountPath:        "/sys/fs/bpf"
						mountPropagation: "Bidirectional"
					}]
				}, {
					name:            "clean-cilium-state"
					image:           "quay.io/cilium/cilium:v1.13.4@sha256:bde8800d61aaad8b8451b10e247ac7bdeb7af187bb698f83d40ad75a38c1ee6b"
					imagePullPolicy: "IfNotPresent"
					command: [
						"/init-container.sh",
					]
					env: [{
						name: "CILIUM_ALL_STATE"
						valueFrom: configMapKeyRef: {
							name:     "cilium-config"
							key:      "clean-cilium-state"
							optional: true
						}
					}, {
						name: "CILIUM_BPF_STATE"
						valueFrom: configMapKeyRef: {
							name:     "cilium-config"
							key:      "clean-cilium-bpf-state"
							optional: true
						}
					}, {
						name:  "KUBERNETES_SERVICE_HOST"
						value: "192.168.121.100"
					}, {
						name:  "KUBERNETES_SERVICE_PORT"
						value: "6443"
					}]
					terminationMessagePolicy: "FallbackToLogsOnError"
					securityContext: {
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
						capabilities: {
							add: [
								"NET_ADMIN",
								"SYS_ADMIN",
								"SYS_RESOURCE",
							]
							drop: [
								"ALL",
							]
						}
					}
					volumeMounts: [{
						name:      "bpf-maps"
						mountPath: "/sys/fs/bpf"
					}, {
						// Required to mount cgroup filesystem from the host to cilium agent pod
						name:             "cilium-cgroup"
						mountPath:        "/sys/fs/cgroup"
						mountPropagation: "HostToContainer"
					}, {
						name:      "cilium-run"
						mountPath: "/var/run/cilium"
					}]
					resources: requests: {
						cpu:    "100m"
						memory: "100Mi"
					}
				}, {
					// wait-for-kube-proxy
					// Install the CNI binaries in an InitContainer so we don't have a writable host mount in the agent
					name:            "install-cni-binaries"
					image:           "quay.io/cilium/cilium:v1.13.4@sha256:bde8800d61aaad8b8451b10e247ac7bdeb7af187bb698f83d40ad75a38c1ee6b"
					imagePullPolicy: "IfNotPresent"
					command: [
						"/install-plugin.sh",
					]
					resources: requests: {
						cpu:    "100m"
						memory: "10Mi"
					}
					securityContext: {
						seLinuxOptions: {
							level: "s0"
							type:  "spc_t"
						}
						capabilities: drop: [
							"ALL",
						]
					}
					terminationMessagePolicy: "FallbackToLogsOnError"
					volumeMounts: [{
						name:      "cni-path"
						mountPath: "/host/opt/cni/bin"
					}]
				}]
				restartPolicy:                 "Always"
				priorityClassName:             "system-node-critical"
				serviceAccount:                "cilium"
				serviceAccountName:            "cilium"
				automountServiceAccountToken:  true
				terminationGracePeriodSeconds: 1
				hostNetwork:                   true
				affinity: podAntiAffinity: requiredDuringSchedulingIgnoredDuringExecution: [{
					labelSelector: matchLabels: "k8s-app": "cilium"
					topologyKey: "kubernetes.io/hostname"
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					// For sharing configuration between the "config" initContainer and the agent
					name: "tmp"
					emptyDir: {}
				}, {
					// To keep state between restarts / upgrades
					name: "cilium-run"
					hostPath: {
						path: "/var/run/cilium"
						type: "DirectoryOrCreate"
					}
				}, {
					// To keep state between restarts / upgrades for bpf maps
					name: "bpf-maps"
					hostPath: {
						path: "/sys/fs/bpf"
						type: "DirectoryOrCreate"
					}
				}, {
					// To keep state between restarts / upgrades for cgroup2 filesystem
					name: "cilium-cgroup"
					hostPath: {
						path: "/sys/fs/cgroup"
						type: "DirectoryOrCreate"
					}
				}, {
					// To install cilium cni plugin in the host
					name: "cni-path"
					hostPath: {
						path: "/opt/cni/bin"
						type: "DirectoryOrCreate"
					}
				}, {
					// To install cilium cni configuration in the host
					name: "etc-cni-netd"
					hostPath: {
						path: "/etc/cni/net.d"
						type: "DirectoryOrCreate"
					}
				}, {
					// To be able to load kernel modules
					name: "lib-modules"
					hostPath: path: "/lib/modules"
				}, {
					// To access iptables concurrently with other processes (e.g. kube-proxy)
					name: "xtables-lock"
					hostPath: {
						path: "/run/xtables.lock"
						type: "FileOrCreate"
					}
				}, {
					// To read the clustermesh configuration
					name: "clustermesh-secrets"
					secret: {
						secretName: "cilium-clustermesh"
						// note: the leading zero means this number is in octal representation: do not remove it
						defaultMode: 0o400
						optional:    true
					}
				}, {
					name: "host-proc-sys-net"
					hostPath: {
						path: "/proc/sys/net"
						type: "Directory"
					}
				}, {
					name: "host-proc-sys-kernel"
					hostPath: {
						path: "/proc/sys/kernel"
						type: "Directory"
					}
				}]
			}
		}
	}
}
