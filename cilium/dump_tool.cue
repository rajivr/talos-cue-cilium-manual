package cilium

import (
	"encoding/yaml"
	"tool/cli"
)

command: dump: {
	print: cli.Print & {
		text: yaml.MarshalStream(objects)
	}
}
