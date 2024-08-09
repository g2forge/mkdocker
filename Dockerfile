FROM nginx:alpine

RUN apk add --no-cache \
	bash \
	git \
	mkdocs \
	py3-pathspec py3-markupsafe py3-platformdirs
## The last line is only needed because nginx:alpine uses an older version, which doesn't have this dependency
## See https://pkgs.alpinelinux.org/package/edge/community/x86_64/mkdocs vs https://pkgs.alpinelinux.org/package/v3.19/community/x86_64/mkdocs

ENV MKDOCKER_REPOSITORY_URL github.com/g2forge/mkdocker
ENV MKDOCKER_REPOSITORY_BRANCH main
ENV MKDOCKER_REPOSITORY_DIRECTORY example

EXPOSE 80

RUN mkdir -pv /mkdocker/scripts && mkdir -pv /mkdocker/docs
COPY mkdocker/scripts/mkdocker.sh /mkdocker/scripts/mkdocker.sh
RUN dos2unix /mkdocker/scripts/mkdocker.sh && chmod +x /mkdocker/scripts/mkdocker.sh

CMD /mkdocker/scripts/mkdocker.sh
