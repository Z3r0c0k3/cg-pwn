#!/bin/bash

echo "source /home/$USER/peda/peda.py" > /home/$USER/.gdbinit; \
chown $USER:$USER /home/$USER/.gdbinit; \
cp -r /root/peda /home/$USER/peda && chown -R $USER:$USER /home/$USER/peda; \