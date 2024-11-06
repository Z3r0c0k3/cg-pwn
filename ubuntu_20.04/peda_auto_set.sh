#!/bin/bash

echo "source /home/$USER/peda/peda.py" > /home/$USER/.gdbinit; \
chown $USER:$USER /home/$USER/.gdbinit; \
cp -r /root/peda /home/$USER/peda && chown -R $USER:$USER /home/$USER/peda; \
cp -r /app/PWNABLE /home/$USER/PWNABLE && chown -R $USER:$USER /home/$USER/PWNABLE; \
cp -r /app/PWNABLE2 /home/$USER/PWNABLE2 && chown -R $USER:$USER /home/$USER/PWNABLE2; \