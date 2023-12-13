APP=$(shell basename $(shell git remote get-url origin))
APP_NAME=kbot
REGISTRY=zadorozhnai/$(APP)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)
	docker build . -t ghcr.io/${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)
push:
	docker push ${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)
	docker push ghcr.io/${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)
clean:
	rm -rf kbot
 	docker rmi -f ${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)
	docker rmi ghcr.io/${REGISTRY}:${VERSION}-$(TARGETOS)-$(TARGETARCH)