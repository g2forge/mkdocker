FROM nginx:alpine

RUN apk add --no-cache \
	bash \
	git \
	rsync \
	mkdocs \
	py3-pip \
	mkdocs-material \
	py3-pathspec py3-markupsafe py3-platformdirs
## The last line is only needed because nginx:alpine uses an older version, which doesn't have this dependency
## See https://pkgs.alpinelinux.org/package/edge/community/x86_64/mkdocs vs https://pkgs.alpinelinux.org/package/v3.19/community/x86_64/mkdocs

ENV MKDOCKER_REPOSITORY_URL github.com/g2forge/mkdocker
ENV MKDOCKER_REPOSITORY_LOGIN ''
ENV MKDOCKER_REPOSITORY_BRANCH main
ENV MKDOCKER_REPOSITORY_DIRECTORY example
ENV MKDOCKER_TEMP_DIRECTORY /mkdocker/temp
ENV MKDOCKER_LOCAL_DIRECTORY /mkdocker/docs
ENV MKDOCKER_VENV_DIRECTORY /mkdocker/venv
ENV MKDOCKER_SERVE 0

EXPOSE 80

RUN mkdir -pv /mkdocker
COPY mkdocker /mkdocker/
RUN dos2unix /mkdocker/scripts/mkdocker.sh && chmod +x /mkdocker/scripts/mkdocker.sh

CMD /mkdocker/scripts/mkdocker.sh
