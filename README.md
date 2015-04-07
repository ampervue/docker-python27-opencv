# docker-python27-opencv


A Docker image running Ubuntu:trusty with Python 2.7, the latest FFMPEG (built from source), and OpenCV 3 (built from source)



### To Build

~~~~
docker build -t <imageName> .
~~~~

### To pull and run from hub.docker.com

Docker Hub: https://registry.hub.docker.com/u/dkarchmervue/python27-opencv/

Source and example: https://github.com/ampervue/docker-python27-opencv

~~~~
docker pull dkarchmervue/python27-opencv
docker run -ti dkarchmervue/python27-opencv bash
~~~~