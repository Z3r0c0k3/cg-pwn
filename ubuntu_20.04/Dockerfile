FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USER_COUNT=20
ENV USER_COUNT=$USER_COUNT

COPY PWNABLE /app/PWNABLE
COPY PWNABLE2 /app/PWNABLE2
COPY peda_auto_set.sh /root/peda_auto_set.sh

RUN apt-get update && \
    apt-get install -y \
    gdb \
    python3 \
    python3-pip \
    openssh-server \
    sudo \
    git \
    vim \
    ruby \
    net-tools \
    netcat \
    curl && \
    if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
    apt-get install -y gcc-multilib; \
    fi && \
    rm -rf /var/lib/apt/lists/*


RUN pip3 install pwntools
RUN git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit
RUN gem install elftools -v 1.2.0
RUN gem install one_gadget -v 1.9.0

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'root:zerocoke' | chpasswd
RUN mkdir -p /run/sshd
RUN cp -r /app/PWNABLE /root/PWNABLE && chown -R root:root /root/PWNABLE
RUN cp -r /app/PWNABLE2 /root/PWNABLE2 && chown -R root:root /root/PWNABLE2


RUN for i in `seq -w 1 ${USER_COUNT:-10}`; do \
    useradd -m user$i -s /bin/bash; \
    echo "user$i:abc1234#" | chpasswd; \
    echo "source /home/user$i/peda/peda.py" > /home/user$i/.gdbinit; \
    chown user$i:user$i /home/user$i/.gdbinit; \
    cp -r /root/peda /home/user$i/peda && chown -R user$i:user$i /home/user$i/peda; \
    cp -r /app/PWNABLE /home/user$i/PWNABLE && chown -R user$i:user$i /home/user$i/PWNABLE; \
    cp -r /app/PWNABLE2 /home/user$i/PWNABLE2 && chown -R user$i:user$i /home/user$i/PWNABLE2; \
    done

RUN rm -rf /app

RUN echo '#!/bin/bash' > /start.sh
RUN echo '/usr/sbin/sshd -D' >> /start.sh
RUN chmod +x /start.sh

EXPOSE 2023

CMD ["/start.sh"]