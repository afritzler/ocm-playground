LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

## Tool binaries and scripts
COMPONENTCLI ?= $(LOCALBIN)/component-cli

## Tool Versions
COMPONENTCLI_VERSION ?= v0.53.0

component-descriptor: component-cli
	./hack/component_descriptor.sh foo

.PHONY: component-cli
component-cli: $(COMPONENTCLI) ## Download component-cli locally if necessary.
$(COMPONENTCLI): $(LOCALBIN)
	test -s $(LOCALBIN)/component-cli || GOBIN=$(LOCALBIN) go install github.com/gardener/component-cli/cmd/component-cli@$(COMPONENTCLI_VERSION)
