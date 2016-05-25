FROM ampervue/python27

# https://github.com/ampervue/docker-python27-opencv

MAINTAINER David Karchmer <dkarchmer@gmail.com>

########################################
#
# Image based on Ubuntu:trusty
#
#   with Python 2.7
#   and OpenCV 3 (built)
#   plus a bunch of build essencials
#######################################

ENV OPENCV_VERSION  2.4.10

WORKDIR /usr/local/src

RUN git clone --depth 1 https://github.com/l-smash/l-smash \
   && git clone --depth 1 git://git.videolan.org/x264.git \
   && hg clone https://bitbucket.org/multicoreware/x265 \
   && git clone --depth 1 git://source.ffmpeg.org/ffmpeg \
   && git clone https://github.com/Itseez/opencv.git \
   && git clone https://github.com/Itseez/opencv_contrib.git \
   && git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git \
   && git clone --depth 1 https://chromium.googlesource.com/webm/libvpx \
   && git clone https://git.xiph.org/opus.git \
   && git clone --depth 1 https://github.com/mulx/aacgain.git

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
RUN pip install --no-cache-dir --upgrade numpy
WORKDIR /usr/local/src
RUN mkdir -p opencv/release
WORKDIR /usr/local/src/opencv/release
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_TBB=ON \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D WITH_V4L=ON \
          -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
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

#            --enable-libx265 - Remove until we can debug compile error
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
            --enable-nonfree
RUN make -j 4
RUN make install
# =================================


# Remove all tmpfile
# =================================
WORKDIR /usr/local/
RUN rm -rf /usr/local/src
# =================================

