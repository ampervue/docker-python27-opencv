FROM dkarchmervue/python27-opencv

# https://github.com/ampervue/docker-python27-opencv

MAINTAINER David Karchmer <dkarchmer@gmail.com>

# ============================================================================
# As an example, we compile a face recognition tool from
#   "Mastering OpenCV with Practical Computer Vision Projects"
#
# ~~~~
# git clone https://dkarchmer-vue@bitbucket.org/ampervue/python27-opencv.git
# cd example
# docker build -t face .
# docker run --rm -ti face --input <jpg picture>
#
# # Mount current directory on container so that file can be written back to host
# docker run --rm -ti -v ${PWD}:/code face --file <jpg input>
# ls thumbnail.jpg
# open thumbnail.jpg
#
# # To run with bash
# docker run --entrypoint bash -ti thumbnail
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






