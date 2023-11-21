APP=$(shell basename $(shell git remote get-url origin))
APP_NAME=kbot
REGISTRY=zadorozhnai
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
WINDOWS_AMD64=$(APP_NAME)_windows_amd64.exe
LINUX_AMD64=$(APP_NAME)_linux_amd64
LINUX_ARM64=$(APP_NAME)_linux_arm64
DARWIN_AMD64=$(APP_NAME)_darwin_amd64
DARWIN_ARM64=$(APP_NAME)_darwin_arm64
IMAGE_TAG=${REGISTRY}/${APP}:${VERSION}


format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get windows linux darwin amd arm

windows: $(WINDOWS_AMD64)

linux amd: $(LINUX_AMD64)

linux arm: $(LINUX_ARM64)

darwin amd: $(DARWIN_AMD64)

darwin arm: $(DARWIN_ARM64)

$(WINDOWS_AMD64):
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(LINUX_AMD64):
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(LINUX_ARM64):
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(DARWIN_AMD64):
    CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(DARWIN_ARM64):
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

image: windows linux darwin amd arm

linux amd:
    docker build . --platform linux/amd64 -t ${IMAGE_TAG}

linux arm:
	docker build . --platform linux/arm64 -t ${IMAGE_TAG}

windows:
	docker build . --platform windows -t ${IMAGE_TAG}

darwin amd:
	docker build . --platform darwin/amd64 -t ${IMAGE_TAG}

darwin arm:
	docker build . --platform darwin/arm64 -t ${IMAGE_TAG}


push:
	docker push ${IMAGE_TAG}

clean:
	rm -rf kbot
	docker rmi ${IMAGE_TAG}