#!/bin/bash

# Stop Tomcat
sudo systemctl stop tomcat9

# Wait for Tomcat to stop
sleep 5

# Check if Tomcat is still running
if ps aux | grep tomcat | grep -v grep > /dev/null; then
    echo "Tomcat is still running."
else
    echo "Tomcat has been stopped."
fi