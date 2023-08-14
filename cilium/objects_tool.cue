package cilium

objects: [ for x in objectSets for _, v in x {v}]

objectSets: [
	kubernetes.serviceAccounts,
	kubernetes.services,
	kubernetes.roles,
	kubernetes.roleBindings,
	kubernetes.clusterRoles,
	kubernetes.clusterRoleBindings,
	kubernetes.configMaps,
]
