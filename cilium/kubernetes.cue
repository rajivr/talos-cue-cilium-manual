package cilium

import (
	"k8s.io/api/core/v1"
)

kubernetes: serviceAccounts: {
	for k, x in serviceAccount {
		"\(k)": v1.#ServiceAccount & x.kubernetes & {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata:   x.metadata & {
				name: x.name
			}
		}
	}
}
