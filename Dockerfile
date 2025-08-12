# Use official Ubuntu image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    curl \
    gdb \
    lldb \
    python3 \
    python3-pip \
    python3-jinja2 \
    clang \
    clang-tidy \
    lcov \
    doxygen \
    meson \
    libpsl-dev \
    sudo \
    pkg-config \
    && apt-get clean

RUN pip3 install clang-format==14.0.6 cmake_format==0.6.11 pyyaml

# Load shell.
CMD ["/bin/bash"]
