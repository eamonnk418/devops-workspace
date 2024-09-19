#!/bin/bash

# Node.js versions to be installed
NODE_VERSIONS=(
    "v18.20.4"
    "v20.17.0" 
    "v22.9.0"
)

# Import the GPG keys
gpg_keys=(
    "4ED778F539E3634C779C87C6D7062848A1AB005C" # Beth Griggs
    "141F07595B7B3FFE74309A937405533BE57C7D57" # Bryan English
    "74F12602B6F1C4E913FAA37AD3A89613643B6201" # Danielle Adams
    "DD792F5973C6DE52C432CBDAC77ABFA00DDBF2B7" # Juan José Arboleda
    "CC68F5A3106FF448322E48ED27F5E38D5B0A215F" # Marco Ippolito
    "8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600" # Michaël Zasso
    "890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4" # Rafael Gonzaga
    "C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C" # Richard Lau
    "108F52B48DB57BB0CC439B2997B01419BD92F80A" # Ruy Adorno
    "A363A499291CBBC940DD62E41F10027AF002F8B0" # Ulises Gascón
)

# Import GPG keys for signature verification
for key in "${gpg_keys[@]}"; do
    gpg --keyserver hkps://keys.openpgp.org --recv-keys "$key"
done

# Function to install Node.js for a specific version
install_node() {
    local version=$1
    echo "Downloading and verifying Node.js version $version"

    # Download SHASUMS256.txt and SHASUMS256.txt.sig
    curl -O https://nodejs.org/dist/$version/SHASUMS256.txt
    curl -O https://nodejs.org/dist/$version/SHASUMS256.txt.sig

    # Verify GPG signature of SHASUMS256.txt
    gpg --verify SHASUMS256.txt.sig SHASUMS256.txt
    if [ $? -ne 0 ]; then
        echo "GPG signature verification failed for $version!"
        exit 1
    fi

    # Download Node.js binaries
    curl -O https://nodejs.org/dist/$version/node-$version-linux-x64.tar.xz

    # Verify the checksum
    grep "node-$version-linux-x64.tar.xz" SHASUMS256.txt | sha256sum -c -
    if [ $? -ne 0 ]; then
        echo "Checksum verification failed for $version!"
        exit 1
    fi

    # Extract Node.js binaries
    tar -xf node-$version-linux-x64.tar.xz -C /usr/local --strip-components=1

    echo "Node.js version $version installed successfully."
}

# Loop through each version and install
for version in "${NODE_VERSIONS[@]}"; do
    install_node "$version"
done
