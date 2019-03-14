cur-dir       := $(shell pwd)

bundle:
	docker build -f Dockerfile-BuildBundle -t wekan-bundle .
	docker run -it --rm --name wekan-bundle --volume=$(cur-dir)/dist:/opt/dist wekan-bundle cp -v /opt/wekan_build/wekan.html /opt/dist/
	docker run -it --rm --name wekan-bundle --volume=$(cur-dir)/dist:/opt/dist wekan-bundle cp -v /opt/wekan_build/wekan.tar.gz /opt/dist/
	docker run -it --rm --name wekan-bundle --volume=$(cur-dir)/dist:/opt/dist wekan-bundle cp -v /opt/wekan_build/WEKAN_RELEASE /opt/dist/

image: bundle
	docker build -f Dockerfile-BuildPackage -t wekan-deb .

deb: image clean
	docker run -it --rm --name wekan-deb --privileged --device /dev/fuse --volume=$(cur-dir)/build:/opt/build --volume=$(cur-dir)/dist:/opt/dist wekan-deb ./build/build

clean:
	docker run -it --rm --name wekan-deb --volume=$(cur-dir)/build:/opt/build wekan-deb ./build/clean
