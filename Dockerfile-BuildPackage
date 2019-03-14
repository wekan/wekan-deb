FROM debian:7

ENV NODE_RELEASE     8.15.1
ENV APPIMAGE_RELEASE 11

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install wget curl dpkg-dev debhelper libfontconfig1-dev fuse && apt-get clean
WORKDIR /opt/
RUN wget https://github.com/AppImage/AppImageKit/releases/download/$APPIMAGE_RELEASE/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage
RUN curl https://nodejs.org/dist/latest-v8.x/node-v$NODE_RELEASE-linux-x64.tar.gz -o node-v$NODE_RELEASE-linux-x64.tar.gz && tar xzf node-v$NODE_RELEASE-linux-x64.tar.gz
