FROM nvidia/cuda:9.0-runtime-ubuntu17.04

#3.4.3
ENV PYTHON_VERSION 3.5
ENV NUM_CORES 16


RUN apt-get update -y
RUN apt-get install libopenblas-dev

RUN apt-get install unzip cmake zlib1g-dev -y


# Define default command.
CMD ["bash"]



