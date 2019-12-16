FROM ruby:1.9.3

# The Debian Jessie APT packages have been archived.  Update where to
# find the packages.  If you don't do this you will get an error message
# like:
#
#  W: Failed to fetch http://http.debian.net/debian/dists/jessie-updates/InRelease
#
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

# Install the build essentials for building gems and the updated certificates
# to prevent "certificate verify failed" errors.
RUN apt-get update -qq && apt-get install -y build-essential ca-certificates

# Install Gems.  Use Bundler 1.17.3 as 2+ does not work with
# Ruby 1.9.3.  Also update the rubygems to prevent frozen string
# errors.  Rubygems 2.7.8 is the latest version to support Ruby 1.9.3.
RUN gem install rubygems-update -v 2.7.8
RUN update_rubygems
RUN gem install bundler -v 1.17.3
