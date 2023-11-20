APP=$(shell basename $(shell git remote get-url origin))
APP_NAME=kbot
REGISTRY=ZadorozhnaI
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
WINDOWS=$(APP_NAME)_windows_amd64.exe
LINUX=$(APP_NAME)_linux_amd64
DARWIN=$(APP_NAME)_darwin_amd64
IMAGE_TAG=${REGISTRY}/${APP}:${VERSION}



format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get windows linux darwin

windows: $(WINDOWS)

linux: $(LINUX)

darwin: $(DARWIN)

$(WINDOWS:)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(LINUX):
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}

$(DARWIN):
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=${VERSION}
image:
	docker build . -t ${IMAGE_TAG}

push:
	docker push ${IMAGE_TAG}

clean:
	rm -rf kbot
