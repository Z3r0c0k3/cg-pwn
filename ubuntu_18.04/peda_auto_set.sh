#!/bin/bash

echo "source /home/$USER/peda/peda.py" > /home/$USER/.gdbinit; \
sudo cp -r /root/peda /home/$USER/peda && sudo chown -R $USER:$USER /home/$USER/peda; \
sudo cp -r /app/PWNABLE /home/$USER/PWNABLE && sudo chown -R $USER:$USER /home/$USER/PWNABLE; \
sudo cp -r /app/PWNABLE2 /home/$USER/PWNABLE2 && sudo chown -R $USER:$USER /home/$USER/PWNABLE2; \