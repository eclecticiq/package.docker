FROM alpine

ARG FPM_VERSION

# Install runtime dependencies
RUN apk --no-cache --update add \
  bzip2 \
  dpkg-dev \
  gnupg \
  gzip \
  perl \
  perl-digest-perl-md5 \
  rpm-dev \
  ruby \
  ruby-etc \
  tar \
  zip \
  xz

# Install dpkg-sig and dependencies
# TODO: create a package for Alpine linux
ENV DPKG_SIG_VERSION 0.13.1+nmu4
RUN wget http://http.debian.net/debian/pool/main/d/dpkg-sig/dpkg-sig_${DPKG_SIG_VERSION}.tar.gz \
  && tar xzvf dpkg-sig_${DPKG_SIG_VERSION}.tar.gz --strip-components=1 -C /usr/local/bin/ --wildcards "*/dpkg-sig" \
  && rm dpkg-sig_${DPKG_SIG_VERSION}.tar.gz
RUN apk --no-cache --update add --virtual .perl \
  perl-utils \
  perl-module-build \
  perl-test-pod \
  perl-test-pod-coverage \
  && cpan install Config::File \
  && rm -rf /root/.cpan \
  && apk del .perl

# Install fpm gem
RUN apk --no-cache --update add --virtual .deps \
  gcc \
  make \
  musl-dev \
  ruby-dev \
  && gem install fpm --version $FPM_VERSION --no-rdoc --no-ri \
  && apk del .deps

RUN adduser -D package

USER package

WORKDIR /home/package

CMD ["fpm"]
