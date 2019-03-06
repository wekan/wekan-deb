wekan-release := 2.38

cur-dir       := $(shell pwd)

image:
	docker build . -t wekan-build

image-force: clean
	docker build . -t wekan-build --no-cache

deb: clean
	docker run -it --rm --name wekan-build --privileged --device /dev/fuse --env WEKAN_RELEASE=$(wekan-release) --volume=$(cur-dir)/build:/opt/build wekan-build ./build/build

clean:
	docker run -it --rm --name wekan-build --volume=$(cur-dir)/build:/opt/build wekan-build ./build/clean
