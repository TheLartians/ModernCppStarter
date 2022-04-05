# build
FROM buildpack-deps:bullseye as webapp-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    cmake \
    ninja-build \
    # configure/build with Boost as system lib - this should be orders of magnitude faster to configure than
    # downloading via CPM.cmake while Boost's CMake support is still experimental
    libboost-all-dev \
    ;
COPY . .
RUN cmake -S standalone -B build -G Ninja -D CMAKE_BUILD_TYPE=Release
RUN cmake --build build


# deploy
FROM debian:bullseye-slim as webapp-run
WORKDIR /app
COPY --from=webapp-build /build/GreeterStandalone .
CMD ["./GreeterStandalone"]
