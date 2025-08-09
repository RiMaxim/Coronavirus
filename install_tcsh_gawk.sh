#!/bin/bash

# Minimal Dependency Installer (tcsh + gawk)
# Works with or without sudo privileges

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Install locations
LOCAL_DIR="$HOME/.local"
BIN_DIR="$LOCAL_DIR/bin"
SRC_DIR="$HOME/src"

# Check sudo
has_sudo() {
    if sudo -v >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Install with package manager
install_with_apt() {
    echo -e "${GREEN}Installing with apt (requires sudo)...${NC}"
    sudo apt-get update -qq
    sudo apt-get install -y tcsh gawk
}

# Compile from source
install_from_source() {
    mkdir -p "$SRC_DIR" "$BIN_DIR"
    
    # Install tcsh
    if ! command -v tcsh &>/dev/null; then
        echo -e "${GREEN}Compiling tcsh...${NC}"
        wget -qO- ftp://ftp.astron.com/pub/tcsh/tcsh-6.24.07.tar.gz | tar xz -C "$SRC_DIR"
        cd "$SRC_DIR/tcsh-6.24.07"
        ./configure --prefix="$LOCAL_DIR" --bindir="$BIN_DIR"
        make && make install
        cd -
    fi

    # Install gawk
    if ! command -v gawk &>/dev/null; then
        echo -e "${GREEN}Compiling gawk...${NC}"
        wget -qO- https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.gz | tar xz -C "$SRC_DIR"
        cd "$SRC_DIR/gawk-5.3.2"
        ./configure --prefix="$LOCAL_DIR" --bindir="$BIN_DIR"
        make && make install
        cd -
    fi
}

# Add to PATH
add_to_path() {
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo -e "${YELLOW}Adding $BIN_DIR to PATH...${NC}"
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
        export PATH="$BIN_DIR:$PATH"
    fi
}

# Main installation
if has_sudo; then
    install_with_apt
else
    echo -e "${YELLOW}No sudo access - installing locally to $LOCAL_DIR${NC}"
    mkdir -p "$LOCAL_DIR"
    install_from_source
    add_to_path
fi

# Verify
echo -e "\n${GREEN}Verifying installations:${NC}"
for cmd in tcsh gawk; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "${GREEN}✓ $cmd found at $(which $cmd)${NC}"
    else
        echo -e "${RED}✗ $cmd installation failed${NC}"
        exit 1
    fi
done

echo -e "\n${GREEN}Success!${NC}"
if ! has_sudo; then
    echo -e "${YELLOW}Restart your shell or run: source ~/.bashrc${NC}"
fi
