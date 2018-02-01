FROM intelpython/intelpython3_core

#3.4.3
ENV PYTHON_VERSION 3.5
ENV NUM_CORES 16

RUN echo deb http://httpredir.debian.org/debian jessie-backports main non-free \
                  >> /etc/apt/sources.list
RUN echo deb-src http://httpredir.debian.org/debian jessie-backports main non-free \
                  >> /etc/apt/sources.list
RUN apt-get update -y

RUN apt-get install ffmpeg -y
RUN apt-get install unzip cmake zlib1g-dev -y
RUN apt-get install libavcodec-dev libavformat-dev libavdevice-dev -y

RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip -O opencv3.zip && \
    unzip -q opencv3.zip && mv /opencv-3.4.0 /opencv
RUN wget https://github.com/opencv/opencv_contrib/archive/3.4.0.zip -O opencv_contrib3.zip && \
    unzip -q opencv_contrib3.zip && mv /opencv_contrib-3.4.0 /opencv_contrib

RUN mkdir /opencv/build
WORKDIR /opencv/build

RUN apt-get install \
    libavutil-dev \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavdevice-dev \
    pkg-config \
    -y

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
    -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
	-D BUILD_PYTHON_SUPPORT=ON \
	-D PYTHON_EXECUTABLE=/opt/conda/bin/python \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
	-D BUILD_EXAMPLES=OFF \
    -D WITH_FFMPEG=ON \
	-D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D BUILD_LIBPROTOBUF_FROM_SOURCES=ON \
	-D WITH_IPP=ON \
	-D WITH_V4L=ON \
	-D BUILD_TBB=ON \
	-D WITH_TBB=ON \
    -DENABLE_PRECOMPILED_HEADERS=OFF ..

#RUN make -j$NUM_CORES
RUN make VERBOSE=1
RUN make install
RUN ldconfig
RUN ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so /opt/conda/lib/python3.6/site-packages/cv2.so
# Define default command.
CMD ["bash"]



