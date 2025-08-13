# Use official Ubuntu image
FROM ubuntu:24.04

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
    python3-venv \
    clang \
    clang-tidy \
    lcov \
    doxygen \
    meson \
    libpsl-dev \
    sudo \
    pkg-config \
    ghostscript \
    && apt-get clean

# Create and activate a virtual environment for Python tools
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set CLANG_FORMAT_EXECUTABLE environment variable to use clang-format from the venv
RUN ln -s /opt/venv/bin/clang-format /usr/local/bin/clang-format

# Upgrade pip and install Python packages in venv
RUN pip install --upgrade pip && \
    pip install clang-format==14.0.6 cmake_format==0.6.11 pyyaml jinja2 pygments

# Load shell
CMD ["/bin/bash"]
