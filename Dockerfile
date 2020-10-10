FROM ubuntu:bionic

ENV LANG=C.UTF-8
ENV CPUMINER_VERSION=v3.8.8.1

RUN apt-get update && apt-get -qy install \
 automake \
 build-essential \
 libcurl4-openssl-dev \
 libssl-dev \
 git \
 ca-certificates \
 zlib1g-dev\
 cmake\
 libuv1-dev\
 libssl-dev\
 libhwloc-dev\
 libjansson-dev\
 libgmp-dev\
 g++\
 --no-install-recommends

WORKDIR /tmp/cpuminer

## CPUMINER
RUN git clone -b $CPUMINER_VERSION --recursive https://github.com/pool-rio/cpuminer.git ./ && \
  ./autogen.sh && \
  CFLAGS="-O3 -march=native -Wall" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl && \
  make -j 3 && \
  mv cpuminer /usr/bin && \
  rm -rf /tmp/cpuminer

##
WORKDIR /tmp/xmrig
RUN git clone -b k12 --recursive https://github.com/pool-rio/xmrig.git ./ && \
  cmake -DWITH_HTTPD=OFF . && \
  make -j 3 && \
  mv xmrig /usr/bin && \
  rm -rf /tmp/xmrig

WORKDIR /miner

COPY .coins .
COPY start.sh .

CMD ./start.sh
