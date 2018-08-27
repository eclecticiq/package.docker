FROM alpine

RUN apk --no-cache --update add \
  bzip2 \
  dpkg-dev \
  gnupg \
  gzip \
  perl \
  rpm-dev \
  ruby \
  ruby-etc \
  tar \
  zip \
  xz

ENV DPKG_SIG_VERSION 0.13.1+nmu4
RUN wget http://http.debian.net/debian/pool/main/d/dpkg-sig/dpkg-sig_${DPKG_SIG_VERSION}.tar.gz \
  && tar xzvf dpkg-sig_${DPKG_SIG_VERSION}.tar.gz --strip-components=1 -C /usr/local/bin/ --wildcards "*/dpkg-sig" \
  && rm dpkg-sig_${DPKG_SIG_VERSION}.tar.gz

RUN apk --no-cache --update add --virtual .deps \
  gcc \
  make \
  musl-dev \
  ruby-dev \
  && gem install fpm --no-rdoc --no-ri \
  && apk del .deps

RUN adduser -D package

USER package

CMD ["fpm"]
