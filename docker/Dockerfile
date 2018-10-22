FROM ubuntu:xenial
MAINTAINER Eevee <join.aero@gmail.com>

RUN buildDeps='build-essential pkg-config make cmake git' \
&& runDeps='libglfw3-dev libglew-dev' \
&& apt-get update \
&& apt-get install -y $buildDeps $runDeps \
&& cd /usr/src/ \
&& git clone --recurse https://github.com/joinAero/CppCISample.git \
&& cd CppCISample/ \
&& mkdir -p _build && cd _build/ \
&& cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. \
&& make && make install
# && rm -rf /var/lib/apt/lists/* \
# && apt-get purge -y --auto-remove $buildDeps

CMD ["/bin/bash"]
