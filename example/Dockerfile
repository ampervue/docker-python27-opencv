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
# docker run -it --rm -p 5901:5901 -e USER=root opencvtest \
#    bash -c "vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log"
#
# Connect to vnc://<host>:5901 via VNC client.
# On a terminal, call program with: `opencvtest sample.jpg` and open generated Gray_Image.jpg
# ~~~~
# ============================================================================

# Step 0: Install a VNC Server so we can use OpenCV GUI features
# --------------------------------------------------------------

# Install VNC server and an editor
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  x11-apps \
  firefox \
  lxde-core \
  lxterminal \
  tightvncserver \
  emacs \
  gpicview \
  && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xresources

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

# Define default command.
CMD ["bash"]

# Expose ports.
EXPOSE 5901








