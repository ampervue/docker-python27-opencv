FROM ubuntu:trusty


MAINTAINER David Karchmer <dkarchmer@ampervue.com>

########################################
# Image based on Ubuntu:trusty
#
#   with Python 2.7
#   and OpenCV 3 (built)
#   plus a bunch of build essencials
#######################################

# Set Locale

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -qq remove ffmpeg

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list; \
    apt-get update -qq && apt-get install -y --force-yes \
    curl \
    git \
    g++ \
    autoconf \
    automake \
    mercurial \
    libopencv-dev \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    libtiff4-dev \
    libpng-dev \
    libjpeg-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine-dev \
    libgstreamer0.10-dev \
    libgstreamer-plugins-base0.10-dev \
    libv4l-dev \
    libtbb-dev \
    libgtk2.0-dev \
    libfaac-dev \
    libmp3lame-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libtool \
    v4l-utils \
    python2.7 \
    python2.7-dev \
    python-numpy \
    default-jdk \
    ant \
    wget \
    unzip; \
    apt-get clean

ENV YASM_VERSION    1.3.0
ENV OPENCV_VERSION  2.4.10

WORKDIR /usr/local/src

RUN git clone --depth 1 https://github.com/l-smash/l-smash
RUN git clone --depth 1 git://git.videolan.org/x264.git
RUN hg clone https://bitbucket.org/multicoreware/x265
RUN git clone --depth 1 git://source.ffmpeg.org/ffmpeg
RUN git clone https://github.com/Itseez/opencv.git
RUN git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
RUN git clone --depth 1 https://chromium.googlesource.com/webm/libvpx
RUN git clone --depth 1 git://git.opus-codec.org/opus.git
RUN git clone --depth 1 https://github.com/mulx/aacgain.git
RUN curl -Os http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz
RUN tar xzvf yasm-${YASM_VERSION}.tar.gz

# Build YASM
# =================================
WORKDIR /usr/local/src/yasm-${YASM_VERSION}
RUN ./configure
RUN make -j 4
RUN make install
# =================================


# Build L-SMASH
# =================================
WORKDIR /usr/local/src/l-smash
RUN ./configure
RUN make -j 4
RUN make install
# =================================


# Build libx264
# =================================
WORKDIR /usr/local/src/x264
RUN ./configure --enable-static
RUN make -j 4
RUN make install
# =================================


# Build libx265
# =================================
WORKDIR  /usr/local/src/x265/build/linux
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../../source
RUN make -j 4
RUN make install
# =================================

# Build libfdk-aac
# =================================
WORKDIR /usr/local/src/fdk-aac
RUN autoreconf -fiv
RUN ./configure --disable-shared
RUN make -j 4
RUN make install
# =================================

# Build libvpx
# =================================
WORKDIR /usr/local/src/libvpx
RUN ./configure --disable-examples
RUN make -j 4
RUN make install
# =================================

# Build libopus
# =================================
WORKDIR /usr/local/src/opus
RUN ./autogen.sh
RUN ./configure --disable-shared
RUN make -j 4
RUN make install
# =================================



# Build OpenCV 3.x
# =================================
RUN apt-get update -qq && apt-get install -y --force-yes libopencv-dev
WORKDIR /usr/local/src
RUN mkdir -p opencv/release
WORKDIR /usr/local/src/opencv/release
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_TBB=ON \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D WITH_V4L=ON \
          ..

RUN make -j4
RUN make install
RUN sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig
# =================================


# Build ffmpeg.
# =================================
RUN apt-get update -qq && apt-get install -y --force-yes \
    libass-dev

WORKDIR /usr/local/src/ffmpeg
RUN ./configure --extra-libs="-ldl" \
            --enable-gpl \
            --enable-libass \
            --enable-libfdk-aac \
            --enable-libfontconfig \
            --enable-libfreetype \
            --enable-libfribidi \
            --enable-libmp3lame \
            --enable-libopus \
            --enable-libtheora \
            --enable-libvorbis \
            --enable-libvpx \
            --enable-libx264 \
            --enable-libx265 \
            --enable-nonfree
RUN make -j 4
RUN make install
# =================================


# Remove all tmpfile
# =================================
WORKDIR /usr/local/
RUN rm -rf /usr/local/src
# =================================
