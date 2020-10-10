FROM ubuntu:bionic

ENV LANG=C.UTF-8

WORKDIR /miner

RUN apt-get update && apt-get -qy install \
 automake \
 build-essential \
 libcurl4-openssl-dev \
 libssl-dev \
 git \
 ca-certificates \
 zlib1g-dev\
 libjansson-dev libgmp-dev g++ --no-install-recommends


RUN git clone -b v3.8.8.1 --recursive https://github.com/pool-rio/cpuminer.git ./

RUN ./autogen.sh
RUN CFLAGS="-O3 -march=native -Wall" CXXFLAGS="$CFLAGS -std=gnu++11" ./configure --with-curl

RUN make -j 3

COPY .coins .
COPY start.sh .

CMD ./start.sh
