FROM nginx:alpine

RUN apk add --no-cache \
	bash \
	mkdocs

ENV MKDOCKER_REPOSITORY_URL github.com/g2forge/mkdocker
ENV MKDOCKER_REPOSITORY_DIRECTORY example

EXPOSE 80

RUN mkdir -pv /mkdocker/scripts && mkdir -pv /mkdocker/docs
COPY /mkdocker/scripts/mkdocker.sh /mkdocker/scripts/mkdocker.sh
RUN chmod +x /mkdocker/scripts/mkdocker.sh

CMD /mkdocker/scripts/mkdocker.sh
