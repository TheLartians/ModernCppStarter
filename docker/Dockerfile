FROM ubuntu:20.04 as build
# install dev tools
ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    cmake \
    git \
    gcc \
    g++ \
    ; \
    rm -rf /var/lib/apt/lists/*
# build in release mode
WORKDIR /build-all
COPY ./all ./all
COPY ./cmake ./cmake
COPY ./documentation ./documentation
COPY ./include ./include
COPY ./source ./source
COPY ./standalone ./standalone
COPY ./test ./test
COPY ./CMakeLists.txt .
RUN cmake -S all -B build -D CMAKE_BUILD_TYPE=Release
RUN cmake --build build

# make a test image - could also be done directly from/in the build image
FROM ubuntu:20.04 as test
WORKDIR /test
COPY --from=build /build-all/build/test/GreeterTests ./
CMD ["./GreeterTests"]

# make an image to deploy our 'app'
FROM ubuntu:20.04 as deploy
WORKDIR /app
COPY --from=build /build-all/build/standalone/Greeter ./
CMD ["./Greeter"]
