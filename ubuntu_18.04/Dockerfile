# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Build-time argument for target architecture (provided by Docker BuildKit)
ARG TARGETARCH

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required packages:
# vim, sudo, net-tools, netcat, curl, git, python3, python3-pip, openssh-server, ruby, build-essential, gdb, etc.
RUN apt-get update && apt-get install -y \
    vim \
    sudo \
    net-tools \
    netcat \
    curl \
    git \
    python3 \
    python3-pip \
    openssh-server \
    ruby \
    build-essential \
    gdb

# Multi-architecture support:
# For arm64: install qemu-user-static for running i386/amd64 binaries emulation.
# For amd64: install gcc-multilib for i386 binary support.
RUN if [ "${TARGETARCH}" = "arm64" ]; then \
    apt-get install -y qemu-user-static; \
    elif [ "${TARGETARCH}" = "amd64" ]; then \
    apt-get install -y gcc-multilib; \
    fi

# Set root password to 'zerocoke'
RUN echo "root:zerocoke" | chpasswd

# Create 20 regular user accounts (user01 to user20) with password 'abc1234#'
RUN for i in $(seq -w 1 20); do \
    useradd -m user${i} && echo "user${i}:abc1234#" | chpasswd; \
    done

RUN pip3 install --upgrade pip setuptools wheel setuptools-rust

# Install pwntools using pip3
RUN pip3 install pwntools

# Install one_gadget using Ruby gem.
# Pre-install elftools version 1.1.3 to satisfy dependency for Ruby 2.5.0, then install one_gadget version 1.9.0
RUN gem install elftools -v 1.1.3 && gem install one_gadget -v 1.9.0

RUN git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit

COPY PWNABLE /app/PWNABLE
COPY PWNABLE2 /app/PWNABLE2
COPY peda_auto_set.sh /root/peda_auto_set.sh
COPY psem.sh /root/psem.sh

RUN chmod +x /root/peda_auto_set.sh

# Configure SSH server:
# - Create the necessary runtime directory
# - Change SSH port to 1804
# - Enable password authentication
# - Allow root login via password
RUN mkdir /var/run/sshd && \
    sed -i 's/#Port 22/Port 1804/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Execute the gdb-peda setup script for each regular user
RUN for i in $(seq -w 1 20); do \
    useradd -m user$i -s /bin/bash; \
    sed -i "s|/home/user${i}:/bin/sh|/home/user${i}:/bin/bash|g" /etc/passwd; \
    echo "user$i:abc1234#" | chpasswd; \
    echo "source /home/user$i/peda/peda.py" > /home/user$i/.gdbinit; \
    chown user$i:user$i /home/user$i/.gdbinit; \
    cp -r /root/peda /home/user$i/peda && chown -R user$i:user$i /home/user$i/peda; \
    cp -r /app/PWNABLE /home/user$i/PWNABLE && chown -R user$i:user$i /home/user$i/PWNABLE; \
    cp -r /app/PWNABLE2 /home/user$i/PWNABLE2 && chown -R user$i:user$i /home/user$i/PWNABLE2; \
    done

# Expose SSH port 1804
EXPOSE 1804

# Start the SSH server when the container runs
CMD ["/usr/sbin/sshd", "-D"]
