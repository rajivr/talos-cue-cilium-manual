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
