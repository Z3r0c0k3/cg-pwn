FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    gdb \
    python3 \
    python3-pip \
    ssh \
    sudo \
    git \
    vim \
    ruby \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install pwntools
RUN git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit
RUN gem install one_gadget

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'root:zerocoke' | chpasswd
RUN mkdir -p /run/sshd

RUN for i in `seq 1 10`; do \
      useradd -m user$i -s /bin/bash; \
      echo "user$i:abc1234#" | chpasswd; \
    done

RUN echo '#!/bin/bash' > /start.sh
RUN echo '/usr/sbin/sshd -D' >> /start.sh
RUN chmod +x /start.sh

EXPOSE 2023

CMD ["/start.sh"]
