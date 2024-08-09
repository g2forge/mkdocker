# mkdocker

Docker image to serve a mkdocs site

# Commands

* `docker build ./ -t mkdocker:latest`
* `docker run --env "MKDOCKER_REPOSITORY_URL=github.com/gdgib/mkdocker" --env "MKDOCKER_REPOSITORY_BRANCH=G2-1615-Initial" --publish 127.0.0.1:8080:80 mkdocker`
