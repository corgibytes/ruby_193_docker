# Ruby 1.9.3 Docker Image
A Docker image that contains the latest versions of [RubyGems](https://github.com/rubygems/rubygems), [Bundler](https://bundler.io/), etc that are compatible with Ruby 1.9.3.  So instead of having to create Dockerfiles that looked like:

```dockerfile
FROM ruby:1.9.3

# The Debian Jessie APT packages have been archived.  Update where to
# find the packages.  If you don't do this you will get an error message
# like:
#
#  W: Failed to fetch http://http.debian.net/debian/dists/jessie-updates/InRelease
#
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

# Install stuff.  Currently just the build essentials.
RUN apt-get update -qq && apt-get install -y build-essential

# Working folder.
RUN mkdir /app
WORKDIR /app
COPY . .

# Install Gems.  Use Bundler 1.17.3 as 2+ does not work with
# Ruby 1.9.3.  Also update the rubygems to prevent frozen string
# errors.  Rubygems 2.7.8 is the latest version to support Ruby 1.9.3.
RUN gem install rubygems-update -v 2.7.8
RUN update_rubygems
RUN gem install bundler -v 1.17.3
RUN bundle install
```

The files now look like:

```dockerfile
FROM corigbytes/ruby-1.9.3:1.0.1

# Working folder.
RUN mkdir /app
WORKDIR /app
COPY . .

# Install Gems.
RUN bundle install
```

# Getting the Image
You can find the image on DockerHub [here](https://hub.docker.com/r/corgibytes/ruby-1.9.3).  To get the latest version, which is not guaranteed to be stable:

`docker pull corgibytes/ruby-1.9.3`

To get a specific version, which is stable:

`docker pull corgibytes/ruby-1.9.3:<version>`

For example:

`docker pull corgibytes/ruby-1.9.3:1.0.0`

Example Dockerfile and Compose to run a Rails app that uses Ruby 1.9.3:

```dockerfile
# Dockerfile
FROM corigbytes/ruby-1.9.3:1.0.0`

# Working folder.
RUN mkdir /app
WORKDIR /app
COPY . .

# Install Gems.
RUN bundle install
```

```yml
# docker-compose.yml
version: '3.7'
services:
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    entrypoint: ./docker-entrypoint.sh
    volumes:
      - .:/app
      - bundler-data:/usr/local/bundle
    ports:
      - "3000:3000"
    depends_on:
      - db
      
  db: 
    image: postgres:9.6
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: password1234
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
  bundler-data:
```

```bash
# docker-entrypoint.sh
#!/bin/sh

rm -f tmp/pids/server.pid
exec "$@"
```

# Versioning
This image is setup using DockerHub's automate builds.  It will build on every commit to master and tag it as `latest`.  It will build also build on every tag that has the format `v.#.#.#` and tag the build as `#.#.#`.   For example if a release is tagged as `v.1.0.0` a DockerHub image will be created with the tag `1.0.0`.

The tagged versions are stable where as the latest version is not guaranteed to be stable.

You can find a full list of the built tags on [DockerHub](https://hub.docker.com/r/corgibytes/ruby-1.9.3/tags).

# Testing the Image
When making changes to the image you can test you changes by running the following command in the root of the repository:

```bash
docker build .
```

# Contributing
If you have any questions, notice a bug, or have a suggestion/enhancment please let me know by opening [issue](https://github.com/corgibytes/ruby_193_docker/issues) or [pull request](https://github.com/corgibytes/ruby_193_docker/pulls).

# Acknowledgements
Thanks to the Ruby team for creating orginial [Ruby Docker images](https://hub.docker.com/_/ruby).
