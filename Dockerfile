FROM gcc:9.2

ENV DEBIAN_FRONTEND noninteractive

# Installing Dependencies
RUN apt-get update && apt-get install -y \
    wget \
 && rm -rf /var/lib/apt/lists/* 

# Installing CMake
RUN wget "https://github.com/Kitware/CMake/releases/download/v3.18.3/cmake-3.18.3-Linux-x86_64.sh" \
 && chmod a+x cmake-3.18.3-Linux-x86_64.sh \
 && ./cmake-3.18.3-Linux-x86_64.sh --prefix=/usr/local --skip-license \
 && rm cmake-3.18.3-Linux-x86_64.sh

# Copying files
COPY . /app
WORKDIR /app

# Building
RUN cmake -Hall -Bbuild \
 && cmake --build build

# Running
CMD [ "./build/standalone/Greeter" ]
