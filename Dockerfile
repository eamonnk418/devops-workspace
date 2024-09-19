# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Install required dependencies for Node.js
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the installation script into the container
COPY scripts/nodejs.sh ./
RUN chmod +x nodejs.sh

# Run the Node.js installation script
RUN ./nodejs.sh
