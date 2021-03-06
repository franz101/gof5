PKG:=github.com/kayrus/gof5
APP_NAME:=gof5
PWD:=$(shell pwd)
UID:=$(shell id -u)
VERSION:=$(shell git describe --tags --always --dirty="-dev")
GOOS:=$(shell go env GOOS)
LDFLAGS:=-X main.Version=$(VERSION) -w -s

# CGO must be enabled
export CGO_ENABLED:=1

build: fmt vet
	go build -mod=vendor -ldflags="$(LDFLAGS)" -o bin/$(APP_NAME)_$(GOOS)

docker:
	docker run -ti --rm -e GOCACHE=/tmp -v $(PWD):/$(APP_NAME) -u $(UID):$(UID) --workdir /$(APP_NAME) golang:latest make

fmt:
	gofmt -s -w pkg

vet:
	go vet -mod=vendor ./...

static:
	staticcheck ./pkg/...

mod:
	go mod vendor

test:
	go test -v ./pkg/...
