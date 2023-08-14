package cilium

import (
	core_v1 "k8s.io/api/core/v1"
	rbac_v1 "k8s.io/api/rbac/v1"
)

kubernetes: serviceAccounts: {
	for k, x in serviceAccount {
		"\(k)": core_v1.#ServiceAccount & x.kubernetes & {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: services: {
	for k, x in service {
		"\(k)": core_v1.#Service & x.kubernetes & {
			apiVersion: "v1"
			kind:       "Service"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: roles: {
	for k, x in role {
		"\(k)": rbac_v1.#Role & x.kubernetes & {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "Role"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: roleBindings: {
	for k, x in roleBinding {
		"\(k)": rbac_v1.#RoleBinding & x.kubernetes & {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "RoleBinding"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: clusterRoles: {
	for k, x in clusterRole {
		"\(k)": rbac_v1.#ClusterRole & x.kubernetes & {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRole"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: clusterRoleBindings: {
	for k, x in clusterRoleBinding {
		"\(k)": rbac_v1.#ClusterRoleBinding & x.kubernetes & {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRoleBinding"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}

kubernetes: configMaps: {
	for k, x in configMap {
		"\(k)": core_v1.#ConfigMap & x.kubernetes & {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}
