package cilium

objects: [ for x in objectSets for _, v in x {v}]

objectSets: [
	kubernetes.serviceAccounts,
]