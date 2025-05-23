TEST?=$$(go list ./... | grep -v 'vendor')
HOSTNAME=clickhouse.cloud
NAMESPACE=terraform
NAME=clickhouse
BINARY=terraform-provider-${NAME}
VERSION=0.1
OS_ARCH=darwin_arm64

default: install

build:
	go build -o ${BINARY}

release:
	GOOS=darwin GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_darwin_amd64
	GOOS=freebsd GOARCH=386 go build -o ./bin/${BINARY}_${VERSION}_freebsd_386
	GOOS=freebsd GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_freebsd_amd64
	GOOS=freebsd GOARCH=arm go build -o ./bin/${BINARY}_${VERSION}_freebsd_arm
	GOOS=linux GOARCH=386 go build -o ./bin/${BINARY}_${VERSION}_linux_386
	GOOS=linux GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_linux_amd64
	GOOS=linux GOARCH=arm go build -o ./bin/${BINARY}_${VERSION}_linux_arm
	GOOS=openbsd GOARCH=386 go build -o ./bin/${BINARY}_${VERSION}_openbsd_386
	GOOS=openbsd GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_openbsd_amd64
	GOOS=solaris GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_solaris_amd64
	GOOS=windows GOARCH=386 go build -o ./bin/${BINARY}_${VERSION}_windows_386
	GOOS=windows GOARCH=amd64 go build -o ./bin/${BINARY}_${VERSION}_windows_amd64

install: build
	mkdir -p ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}
	mv ${BINARY} ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}

test: 
	go test -i $(TEST) || exit 1                                                   
	echo $(TEST) | xargs -t -n4 go test $(TESTARGS) -timeout=30s -parallel=4                    

enable_git_hooks: ## Add githooks for code validation before commit, as symlink so they get updated automatically
	mkdir -p .git/hooks
	cd .git/hooks && ln -fs ../../.githooks/* .
	echo "Git hooks were updated from .githooks/ into .git/hooks/"

docs: ensure-tfplugindocs
	$(TFPLUGINDOCS) generate --provider-name=clickhouse

docs-alpha: ensure-tfplugindocs
	$(TFPLUGINDOCS) generate --provider-name=clickhouse --additional-go-build-args="-tags alpha"

fmt: ensure-golangci-lint
	go fmt ./...
	$(GOLANGCILINT) run --fix --allow-serial-runners

mock:
	cd ./pkg/internal/api && minimock -i github.com/smugantechamb/terraform-provider-clickhouse/pkg/internal/api.Client -o client_mock.go -n ClientMock -p api && cd ../../..

TFPLUGINDOCS = /tmp/tfplugindocs-patched
ensure-tfplugindocs: ## Download tfplugindocs locally if necessary.
	$(call get-tfplugindocs,$(TFPLUGINDOCS),github.com/whites11/terraform-plugin-docs)

GOLANGCILINT = $(shell go env GOPATH)/bin/golangci-lint
# Test if golangci-lint is available in the GOPATH, if not, set to local and download if needed
ifneq ($(shell test -f $(GOLANGCILINT) && echo -n yes),yes)
GOLANGCILINT = /tmp/golangci-lint
endif
ensure-golangci-lint: ## Download golangci-lint locally if necessary.
	$(call go-get-tool,$(GOLANGCILINT),github.com/golangci/golangci-lint/cmd/golangci-lint@v1.64.8)

# go-get-tool will 'go get' any package $2 and install it to $1.
define go-get-tool
@[ -f $(1) ] || { \
set -e ;\
TMP_DIR=$$(mktemp -d) ;\
cd $$TMP_DIR ;\
go mod init tmp ;\
gobin="$$(dirname $(1))" ;\
echo "Downloading $(2) into $$gobin" ;\
GOBIN=$$gobin go install $(2) ;\
rm -rf $$TMP_DIR ;\
}
endef

define get-tfplugindocs
@[ -f $(1) ] || { \
set -e ;\
TMP_DIR=$$(mktemp -d) ;\
cd $$TMP_DIR ;\
echo "Cloning https://$(2).git into $$TMP_DIR" ;\
git clone https://$(2).git tfplugindocs ;\
cd tfplugindocs ;\
echo "Building tfplugindocs into $(1)" ;\
go build -o $(1) cmd/tfplugindocs/main.go ;\
rm -rf $$TMP_DIR ;\
}
endef
