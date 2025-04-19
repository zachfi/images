FROM nvidia/cuda:12.1.0-base-ubuntu18.04

WORKDIR /root

# Update packages
RUN apt update
# Upgrade ubuntu
RUN apt-get upgrade -y
# Workaround on error: libOpenCL.so.1: cannot open shared object file: No such file or directory
RUN apt-get purge ocl-icd-opencl-dev; apt-get autoremove; apt-get install ocl-icd-opencl-dev wget -y

RUN wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.38/lolMiner_v1.38_Lin64.tar.gz
RUN tar -xzf lolMiner_v1.38_Lin64.tar.gz
RUN mv 1.38/lolMiner /usr/local/bin/lolMiner

ENTRYPOINT [ "lolMiner" ]
