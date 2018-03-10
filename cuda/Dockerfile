FROM nvidia/cuda:9.0-devel-ubuntu17.04

#3.4.3
ENV PYTHON_VERSION 3.5
ENV NUM_CORES 16

# necessary because nvidia doesn't update their images
RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update -y

RUN apt-get install libopenblas-dev -y
RUN apt-get install ffmpeg -y
RUN apt-get install unzip cmake zlib1g-dev build-essential wget curl -y
RUN apt-get install apt-transport-https -y

RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

RUN echo "deb https://apt.repos.intel.com/intelpython binary/" >> /etc/apt/sources.list
RUN echo "deb https://apt.repos.intel.com/mkl all main" >> /etc/apt/sources.list
RUN echo "deb https://apt.repos.intel.com/ipp all main" >> /etc/apt/sources.list
RUN echo "deb https://apt.repos.intel.com/tbb all main" >> /etc/apt/sources.list
RUN echo "deb https://apt.repos.intel.com/daal all main" >> /etc/apt/sources.list
RUN apt-get update -y

RUN apt-get install -y intelpython3 intel-tbb-2018.0-033 intel-mkl-2018.1-038 intel-ipp-2018.1-038

ENV PATH="/opt/intel/intelpython3/bin:${PATH}"


# # nvidia you're crap
# RUN apt-get install python3 python3-pip -y
# # RUN alias python=python3
# RUN ln -s /usr/bin/python3 /usr/bin/python
# RUN ln -s /usr/bin/pip3 /usr/bin/pip



# RUN pip install numpy scipy 

RUN apt-get install \
    libavutil-dev \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavdevice-dev \
    pkg-config \
    -y

RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip -O opencv3.zip && \
    unzip -q opencv3.zip && mv opencv-3.4.0 /opencv
RUN wget https://github.com/opencv/opencv_contrib/archive/3.4.0.zip -O opencv_contrib3.zip && \
    unzip -q opencv_contrib3.zip && mv opencv_contrib-3.4.0 /opencv_contrib

RUN mkdir /opencv/build
WORKDIR /opencv/build

# # RUN echo $(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")

#     # -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
#     # -D WITH_NVCUVID=ON\
#     # -D CUDA_FAST_MATH=1 \
#     # -D WITH_CUBLAS=1 \

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
    -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
    -D WITH_CUDA=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_OPENMP=ON\
    -D BUILD_PYTHON_SUPPORT=ON \
    -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF\
	-D PYTHON_EXECUTABLE=$(which python) \
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

RUN make -j$NUM_CORES
# # RUN make -j
RUN make install

# RUN apt-get install ssh -y

# Define default command.
CMD ["bash"]



