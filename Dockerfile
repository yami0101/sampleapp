FROM ruby:2.3.3
MAINTAINER sdjomin01@gmail.com

# Adding postgres repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    locales \
    libpq-dev nodejs \
    postgresql-client-9.6 \
    qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x xvfb \
    && rm -rf /var/lib/apt/lists/*

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
ENV RELEASE_PATH /home/sampleapp/current

RUN mkdir -p $RELEASE_PATH
WORKDIR $RELEASE_PATH

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile $RELEASE_PATH/Gemfile
COPY Gemfile.lock $RELEASE_PATH/Gemfile.lock
RUN bundle

#ENV GEM_HOME /tmp
#ENV PATH $GEM_HOME/bin:$PATH

# Copy the main application.
COPY . $RELEASE_PATH

#Precompile assets
RUN RAILS_ENV=development bundle exec rake db:create db:migrate db:seed
#EXPOSE $WEBKIT_PORT

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*