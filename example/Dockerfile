FROM dkarchmervue/python27-opencv

# https://github.com/ampervue/docker-python27-opencv

MAINTAINER David Karchmer <dkarchmer@gmail.com>

# ============================================================================
# As an example, we compile a small program to load an image and write out
#     a gray scale version of it.
# See http://docs.opencv.org/doc/tutorials/introduction/load_save_image/load_save_image.html
#
# ~~~~
# git clone https://dkarchmer-vue@bitbucket.org/ampervue/python27-opencv.git
# cd example
# docker build -t opencvtest .
# docker run --rm -ti opencvtest sample.jpg
#
# # Mount current directory on container so that file can be written back to host
# docker run --rm -ti -v ${PWD}:/code opencvtest sample.jpg
# ls app/Gray_Image.jpg
# open app/Gray_Image.jpg
#
# # To run with bash
# docker run --entrypoint bash -ti opencvtest
# ~~~~
# ============================================================================

# Step 1: Install any Python packages
# ----------------------------------------

RUN mkdir /code
WORKDIR /code


# Step 2: Copy code
# ----------------------------------------

ADD app /code/app

# Step 3: Compile Code
# ----------------------------------------

WORKDIR /code/app

RUN g++ -ggdb `pkg-config --cflags opencv` -o `basename opencvtest.cpp .cpp` opencvtest.cpp `pkg-config --libs opencv`

CMD [ "/code/app/sample.jpg" ]
ENTRYPOINT [ "/code/app/opencvtest" ]






