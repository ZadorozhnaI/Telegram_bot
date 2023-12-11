APP=$(shell basename $(shell git remote get-url origin))
APP_NAME=kbot
REGISTRY=ZadorozhnaI
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGEROS=linux darwin windows
TARGETARCH=arm64 amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGEROS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/s{APP}:{VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/s{APP}:{VERSION}-${TARGETARCH}

clean:
	rm -rf kbot