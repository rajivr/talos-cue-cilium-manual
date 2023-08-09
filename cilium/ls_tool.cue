package cilium

import (
	"text/tabwriter"
	"tool/cli"
)

command: ls: {
	print: cli.Print & {
		text: tabwriter.Write([
			for x in objects {
				"\(x.kind)  \t\(x.metadata.name)"
			},
		])
	}
}
